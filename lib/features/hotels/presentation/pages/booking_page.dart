import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities.dart';
import '../cubit/bookings_cubit.dart';
import '../../../../core/layout/breakpoints.dart';

final _phonePattern = RegExp(r'^\+?[0-9 ()\-]{9,18}$');

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.hotel});

  final Hotel hotel;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: context.read<AuthCubit>().state.user?.name ?? '',
  );
  final _phone = TextEditingController();
  RoomType _room = RoomType.all.first;
  DateTimeRange? _range;
  int _guests = 2;
  PaymentMethod _payment = PaymentMethod.atHotel;
  bool _saving = false;
  String? _error;

  int get _nights => _range?.duration.inDays ?? 0;
  int get _rate => widget.hotel.priceFor(_room);
  int get _roomTotal => _nights * _rate;
  int get _fee => (_roomTotal * Booking.serviceFeeRate).round();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final l10n = context.l10n;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDateRange: _range,
      helpText: l10n.selectYourStay,
      saveText: l10n.done,
    );
    if (picked != null) {
      setState(() {
        _range = picked;
        _error = null;
      });
    }
  }

  void _selectRoom(RoomType room) => setState(() {
    _room = room;
    _error = null;
    if (_guests > room.maxGuests) _guests = room.maxGuests;
  });

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_nights > Hotel.maxNights) {
      setState(() => _error = context.l10n.maxStay(Hotel.maxNights));
      return;
    }
    FocusScope.of(context).unfocus();
    final range = _range!;
    final l10n = context.l10n;
    final bookings = context.read<BookingsCubit>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final format = _dateFormat();

    setState(() {
      _saving = true;
      _error = null;
    });
    final Booking booking;
    try {
      booking = await bookings.book(
        BookingRequest(
          hotel: widget.hotel,
          room: _room,
          checkIn: range.start,
          checkOut: range.end,
          guests: _guests,
          guestName: _name.text.trim(),
          guestPhone: _phone.text.trim(),
          payment: _payment,
        ),
      );
    } on BookingFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = switch (e.reason) {
          BookingFailureReason.notAvailable => l10n.notAvailable(
            _room.title(l10n),
          ),
          BookingFailureReason.alreadyBooked => l10n.alreadyBooked,
          BookingFailureReason.unknown => l10n.bookingFailed,
        };
      });
      return;
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l10n.bookingFailed;
      });
      return;
    }
    if (!mounted) return;
    setState(() => _saving = false);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: Text(l10n.bookingConfirmed),
        content: Text(
          '${widget.hotel.name}\n${format.format(range.start)} – '
          '${format.format(range.end)}\n\n${l10n.bookingCode(booking.code)}',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.great),
          ),
        ],
      ),
    );
    navigator.popUntil((route) => route.isFirst);
    messenger.showSnackBar(SnackBar(content: Text(l10n.findInBookings)));
  }

  DateFormat _dateFormat() =>
      DateFormat('EEE, d MMM', Localizations.localeOf(context).toString());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final format = _dateFormat();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookYourStay)),
      body: Form(
        key: _formKey,
        child: ReadableWidth(
          maxWidth: 640,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: AppImage(widget.hotel.cover),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.hotel.name,
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            widget.hotel.city,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.roomType, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              for (final room in RoomType.all) ...[
                _RoomOption(
                  room: room,
                  price: widget.hotel.priceFor(room),
                  selected: room == _room,
                  onTap: () => _selectRoom(room),
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 14),
              Text(l10n.dates, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _pickDates,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _DateBox(
                            label: l10n.checkIn,
                            date: _range?.start,
                            format: format,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: theme.colorScheme.outline,
                        ),
                        Expanded(
                          child: _DateBox(
                            label: l10n.checkOut,
                            date: _range?.end,
                            format: format,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.guests, style: theme.textTheme.titleMedium),
                        Text(
                          l10n.guestsUpTo(_room.maxGuests, _room.title(l10n)),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton.outlined(
                    tooltip: l10n.fewerGuests,
                    onPressed: _guests > 1
                        ? () => setState(() => _guests--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$_guests',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton.outlined(
                    tooltip: l10n.moreGuests,
                    onPressed: _guests < _room.maxGuests
                        ? () => setState(() => _guests++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(l10n.guestDetails, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                decoration: InputDecoration(
                  labelText: l10n.guestName,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    (v == null || v.trim().length < 2) ? l10n.enterName : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.telephoneNumber],
                decoration: InputDecoration(
                  labelText: l10n.guestPhone,
                  hintText: '+998 90 123 45 67',
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                validator: (v) => _phonePattern.hasMatch(v?.trim() ?? '')
                    ? null
                    : l10n.enterPhone,
              ),
              const SizedBox(height: 24),
              Text(l10n.paymentMethod, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              _PaymentOption(
                icon: Icons.storefront_outlined,
                title: l10n.payAtHotel,
                subtitle: l10n.payAtHotelDesc,
                selected: _payment == PaymentMethod.atHotel,
                onTap: () => setState(() => _payment = PaymentMethod.atHotel),
              ),
              const SizedBox(height: 10),
              _PaymentOption(
                icon: Icons.credit_card_outlined,
                title: l10n.payOnline,
                subtitle: l10n.payOnlineDesc,
                selected: _payment == PaymentMethod.online,
                onTap: () => setState(() => _payment = PaymentMethod.online),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      _PriceRow(
                        l10n.nightsPrice(_rate, _nights),
                        '\$$_roomTotal',
                      ),
                      const SizedBox(height: 10),
                      _PriceRow(
                        l10n.serviceFee((Booking.serviceFeeRate * 100).round()),
                        '\$$_fee',
                      ),
                      const Divider(height: 28),
                      _PriceRow(
                        l10n.total,
                        '\$${_roomTotal + _fee}',
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(
            onPressed: _nights > 0 && !_saving ? _confirm : null,
            child: _saving
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                      if (_payment == PaymentMethod.online) ...[
                        const SizedBox(width: 12),
                        Text(l10n.processingPayment),
                      ],
                    ],
                  )
                : Text(
                    _nights > 0
                        ? l10n.confirmAndBook(_roomTotal + _fee)
                        : l10n.selectDatesToContinue,
                  ),
          ),
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? scheme.primaryContainer : theme.cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? scheme.primary : scheme.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? scheme.primary : scheme.outline,
              ),
              const SizedBox(width: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomOption extends StatelessWidget {
  const _RoomOption({
    required this.room,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final RoomType room;
  final int price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return _Option(
      selected: selected,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.title(l10n), style: theme.textTheme.titleMedium),
                Text(room.details(l10n), style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Text('\$$price', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Option(
      selected: selected,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.label,
    required this.date,
    required this.format,
  });

  final String label;
  final DateTime? date;
  final DateFormat format;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          date == null ? context.l10n.addDate : format.format(date!),
          style: theme.textTheme.titleSmall?.copyWith(
            color: date == null ? theme.colorScheme.primary : null,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = bold
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium;
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}

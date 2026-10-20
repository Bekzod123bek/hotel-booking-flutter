import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_image.dart';
import '../../domain/entities.dart';
import '../cubit/bookings_cubit.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.hotel});

  final Hotel hotel;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _format = DateFormat('EEE, d MMM');
  RoomType _room = RoomType.all.first;
  DateTimeRange? _range;
  int _guests = 2;
  bool _saving = false;

  int get _nights => _range?.duration.inDays ?? 0;
  int get _rate => widget.hotel.priceFor(_room);
  int get _roomTotal => _nights * _rate;
  int get _fee => (_roomTotal * Booking.serviceFeeRate).round();

  Future<void> _pickDates() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDateRange: _range,
      helpText: 'Select your stay',
      saveText: 'Done',
    );
    if (picked != null) setState(() => _range = picked);
  }

  void _selectRoom(RoomType room) => setState(() {
        _room = room;
        if (_guests > room.maxGuests) _guests = room.maxGuests;
      });

  Future<void> _confirm() async {
    final range = _range!;
    setState(() => _saving = true);
    final bookings = context.read<BookingsCubit>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await bookings.book(
      hotel: widget.hotel,
      room: _room,
      checkIn: range.start,
      checkOut: range.end,
      guests: _guests,
    );
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Booking confirmed'),
        content: Text(
          '${widget.hotel.name}\n${_format.format(range.start)} – '
          '${_format.format(range.end)}',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Great'),
          ),
        ],
      ),
    );
    navigator.popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      const SnackBar(content: Text('You can find it in the Bookings tab')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Book your stay')),
      body: ListView(
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
                      Text(widget.hotel.name, style: theme.textTheme.titleMedium),
                      Text(widget.hotel.city, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Room type', style: theme.textTheme.titleMedium),
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
          Text('Dates', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _pickDates,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(child: _DateBox(label: 'Check-in', date: _range?.start, format: _format)),
                    Icon(Icons.arrow_forward, color: theme.colorScheme.outline),
                    Expanded(child: _DateBox(label: 'Check-out', date: _range?.end, format: _format)),
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
                    Text('Guests', style: theme.textTheme.titleMedium),
                    Text('Up to ${_room.maxGuests} in a ${_room.name}',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton.outlined(
                tooltip: 'Fewer guests',
                onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 40,
                child: Text('$_guests',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge),
              ),
              IconButton.outlined(
                tooltip: 'More guests',
                onPressed: _guests < _room.maxGuests
                    ? () => setState(() => _guests++)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _PriceRow('\$$_rate × $_nights night${_nights == 1 ? '' : 's'}',
                      '\$$_roomTotal'),
                  const SizedBox(height: 10),
                  _PriceRow('Service fee (10%)', '\$$_fee'),
                  const Divider(height: 28),
                  _PriceRow('Total', '\$${_roomTotal + _fee}', bold: true),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(
            onPressed: _nights > 0 && !_saving ? _confirm : null,
            child: Text(_nights > 0
                ? 'Confirm and book  •  \$${_roomTotal + _fee}'
                : 'Select dates to continue'),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name, style: theme.textTheme.titleMedium),
                    Text(room.description, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Text('\$$price', style: theme.textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.label, required this.date, required this.format});

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
          date == null ? 'Add date' : format.format(date!),
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
    final style = bold ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium;
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}

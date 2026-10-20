import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities.dart';
import '../cubit/bookings_cubit.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.hotel});

  final Hotel hotel;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTimeRange? _range;
  int _guests = 1;

  final _format = DateFormat('d MMM yyyy');

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _range,
    );
    if (picked != null) setState(() => _range = picked);
  }

  Future<void> _confirm() async {
    final range = _range!;
    final bookings = context.read<BookingsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await bookings.book(
      hotel: widget.hotel,
      checkIn: range.start,
      checkOut: range.end,
      guests: _guests,
    );
    messenger.showSnackBar(const SnackBar(content: Text('Booking confirmed')));
    navigator.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final nights = _range?.duration.inDays ?? 0;
    final total = nights * widget.hotel.pricePerNight;
    return Scaffold(
      appBar: AppBar(title: const Text('Your stay')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.hotel.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.calendar_month),
            title: Text(_range == null
                ? 'Select dates'
                : '${_format.format(_range!.start)} – ${_format.format(_range!.end)}'),
            onTap: _pickDates,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Guests'),
              const Spacer(),
              IconButton(
                onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_guests'),
              IconButton(
                onPressed: _guests < 6 ? () => setState(() => _guests++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              Text('$nights night(s)'),
              const Spacer(),
              Text('Total: \$$total',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: nights > 0 ? _confirm : null,
            child: const Text('Confirm booking'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities.dart';
import '../cubit/bookings_cubit.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My bookings')),
      body: BlocBuilder<BookingsCubit, List<Booking>>(
        builder: (context, bookings) {
          if (bookings.isEmpty) {
            return const EmptyState(
              icon: Icons.luggage_outlined,
              title: 'No trips booked',
              message: 'When you book a hotel it will show up here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: bookings.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (_, i) => _BookingCard(booking: bookings[i]),
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final Booking booking;

  Future<void> _cancel(BuildContext context) async {
    final cubit = context.read<BookingsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text('Your stay at ${booking.hotelName} will be cancelled.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 44),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await cubit.cancel(booking.id);
    messenger.showSnackBar(
      SnackBar(content: Text('Booking at ${booking.hotelName} cancelled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final format = DateFormat('d MMM');
    final upcoming = booking.checkIn.isAfter(DateTime.now());
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 130,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImage(booking.image),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 12,
                  right: 16,
                  child: Text(
                    booking.hotelName,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Chip(
                    label: Text(upcoming ? 'Upcoming' : 'Confirmed'),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${format.format(booking.checkIn)} – '
                        '${format.format(booking.checkOut)}  •  '
                        '${booking.nights} night${booking.nights == 1 ? '' : 's'}',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking.roomName} room  •  ${booking.guests} '
                        'guest${booking.guests == 1 ? '' : 's'}  •  ${booking.city}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total \$${booking.total}',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Cancel booking',
                  onPressed: () => _cancel(context),
                  icon: Icon(Icons.delete_outline,
                      color: theme.colorScheme.error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

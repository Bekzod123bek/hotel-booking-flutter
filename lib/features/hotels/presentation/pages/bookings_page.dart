import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities.dart';
import '../cubit/bookings_cubit.dart';
import '../../../../core/l10n/l10n.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.myBookings)),
      body: BlocBuilder<BookingsCubit, List<Booking>>(
        builder: (context, bookings) {
          if (bookings.isEmpty) {
            return EmptyState(
              icon: Icons.luggage_outlined,
              title: context.l10n.noTripsTitle,
              message: context.l10n.noTripsMessage,
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
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cancelBookingQ),
        content: Text(l10n.cancelBody(booking.hotelName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.keep),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 44),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.cancelBooking),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await cubit.cancel(booking);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.bookingCancelled(booking.hotelName))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final format =
        DateFormat('d MMM', Localizations.localeOf(context).toString());
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
                    label: Text(upcoming ? l10n.upcoming : l10n.confirmed),
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
                        '${l10n.nightsCount(booking.nights)}',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.roomWithName(RoomType.byKey(booking.roomName).title(l10n))}'
                        '  •  ${l10n.guestsCount(booking.guests)}  •  ${booking.city}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.codeLabel(booking.code),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.totalAmount(booking.total),
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.cancelBooking,
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

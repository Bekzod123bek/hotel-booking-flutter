import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities.dart';
import '../cubit/bookings_cubit.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('d MMM');
    return Scaffold(
      appBar: AppBar(title: const Text('My bookings')),
      body: BlocBuilder<BookingsCubit, List<Booking>>(
        builder: (context, bookings) {
          if (bookings.isEmpty) {
            return const Center(child: Text('No bookings yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (_, i) {
              final b = bookings[i];
              return Card(
                child: ListTile(
                  title: Text(b.hotel.name),
                  subtitle: Text(
                    '${format.format(b.checkIn)} – ${format.format(b.checkOut)}'
                    '  •  ${b.guests} guest(s)  •  \$${b.total}',
                  ),
                  trailing: IconButton(
                    tooltip: 'Cancel booking',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => context.read<BookingsCubit>().cancel(b.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../domain/entities.dart';
import 'booking_page.dart';

class HotelDetailPage extends StatelessWidget {
  const HotelDetailPage({super.key, required this.hotel});

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hotel.name)),
      body: ListView(
        children: [
          Container(
            height: 200,
            color: Color(hotel.colorValue),
            child: const Icon(Icons.hotel, color: Colors.white, size: 72),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hotel.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text('${hotel.city}  •  ${hotel.rating} ★'),
                const SizedBox(height: 16),
                Text(hotel.description),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final a in hotel.amenities) Chip(label: Text(a)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => BookingPage(hotel: hotel)),
            ),
            child: Text('Book from \$${hotel.pricePerNight} / night'),
          ),
        ),
      ),
    );
  }
}

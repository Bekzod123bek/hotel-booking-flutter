import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../cubit/hotels_cubit.dart';
import 'hotel_detail_page.dart';

class HotelsPage extends StatelessWidget {
  const HotelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a hotel')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: 'Search by name or city',
              leading: const Icon(Icons.search),
              onChanged: (q) => context.read<HotelsCubit>().load(query: q),
            ),
          ),
          Expanded(
            child: BlocBuilder<HotelsCubit, HotelsState>(
              builder: (context, state) {
                if (state.loading && state.hotels.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.hotels.isEmpty) {
                  return const Center(child: Text('No hotels found'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: state.hotels.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => HotelCard(hotel: state.hotels[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  const HotelCard({super.key, required this.hotel});

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    final color = Color(hotel.colorValue);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => HotelDetailPage(hotel: hotel)),
        ),
        child: Row(
          children: [
            Container(
              width: 96,
              height: 96,
              color: color,
              child: const Icon(Icons.hotel, color: Colors.white, size: 36),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(hotel.city),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(' ${hotel.rating}'),
                        const Spacer(),
                        Text('\$${hotel.pricePerNight} / night',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

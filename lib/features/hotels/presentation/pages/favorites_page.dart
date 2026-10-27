import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/hotels_cubit.dart';
import '../widgets/hotel_widgets.dart';
import '../../../../core/l10n/l10n.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = context.watch<FavoritesCubit>().state;
    final hotels = context
        .watch<HotelsCubit>()
        .state
        .all
        .where((h) => ids.contains(h.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navFavorites)),
      body: hotels.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border,
              title: context.l10n.noFavoritesTitle,
              message: context.l10n.noFavoritesMessage,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: hotels.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) =>
                  HotelTile(hotel: hotels[i], heroTag: 'fav-${hotels[i].id}'),
            ),
    );
  }
}

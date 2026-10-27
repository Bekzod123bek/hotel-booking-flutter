import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_image.dart';
import '../../domain/entities.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/hotels_cubit.dart';
import '../pages/hotel_detail_page.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_tokens.dart';

IconData amenityIcon(String amenity) => switch (amenity) {
  'Wi-Fi' => Icons.wifi,
  'Breakfast' => Icons.free_breakfast_outlined,
  'Pool' => Icons.pool,
  'Spa' => Icons.spa_outlined,
  'Gym' => Icons.fitness_center,
  'Parking' => Icons.local_parking,
  'Restaurant' => Icons.restaurant,
  'Air conditioning' => Icons.ac_unit,
  _ => Icons.check_circle_outline,
};

/// "1.2 km away" once the user's position is known, otherwise `null`.
String? hotelDistance(BuildContext context, Hotel hotel) {
  final origin = context.select((HotelsCubit c) => c.state.origin);
  if (origin == null) return null;
  return distanceLabel(context.l10n, origin.distanceKmTo(hotel.position));
}

void openHotel(BuildContext context, Hotel hotel, String heroTag) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => HotelDetailPage(hotel: hotel, heroTag: heroTag),
    ),
  );
}

class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating, this.onImage = false});

  final double rating;
  final bool onImage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: onImage
            ? colors.scrim.withValues(alpha: 0.45)
            : colors.accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 16, color: colors.accent),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: onImage ? colors.onBrand : scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.hotel, this.size = 22});

  final Hotel hotel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final favorite = context.select(
      (FavoritesCubit c) => c.state.contains(hotel.id),
    );
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: favorite
            ? context.l10n.removeFromFavorites
            : context.l10n.addToFavorites,
        iconSize: size,
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final l10n = context.l10n;
          final added = await context.read<FavoritesCubit>().toggle(hotel.id);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  added
                      ? l10n.addedToFavorites(hotel.name)
                      : l10n.removedFromFavorites(hotel.name),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
        },
        icon: AnimatedSwitcher(
          duration: Motion.quick,
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(favorite),
            color: favorite
                ? AppColors.of(context).danger
                : AppColors.of(context).ink,
          ),
        ),
      ),
    );
  }
}

/// Large card with photo, used in lists.
class HotelCard extends StatelessWidget {
  const HotelCard({super.key, required this.hotel, required this.heroTag});

  final Hotel hotel;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openHotel(context, hotel, heroTag),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(tag: heroTag, child: AppImage(hotel.cover)),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: RatingBadge(rating: hotel.rating, onImage: true),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(hotel: hotel),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hotel.name, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                [
                                  hotel.city,
                                  hotelDistance(context, hotel) ??
                                      context.l10n.reviewsCount(
                                        hotel.reviewCount,
                                      ),
                                ].join('  •  '),
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PriceTag(price: hotel.pricePerNight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price, this.light = false});

  final int price;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = light ? Colors.white : theme.colorScheme.primary;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '\$$price',
            style: theme.textTheme.titleLarge?.copyWith(color: color),
          ),
          TextSpan(
            text: context.l10n.perNight,
            style: theme.textTheme.bodySmall?.copyWith(
              color: light
                  ? Colors.white70
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Wide card with a gradient over the photo, used in the featured carousel.
class FeaturedHotelCard extends StatelessWidget {
  const FeaturedHotelCard({
    super.key,
    required this.hotel,
    required this.heroTag,
  });

  final Hotel hotel;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => openHotel(context, hotel, heroTag),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(tag: heroTag, child: AppImage(hotel.cover)),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.4, 1],
                ),
              ),
            ),
            Positioned(top: 12, right: 12, child: FavoriteButton(hotel: hotel)),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBadge(rating: hotel.rating, onImage: true),
                        const SizedBox(height: 8),
                        Text(
                          hotel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          hotel.city,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PriceTag(price: hotel.pricePerNight, light: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact horizontal card, used for favorites.
class HotelTile extends StatelessWidget {
  const HotelTile({super.key, required this.hotel, required this.heroTag});

  final Hotel hotel;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openHotel(context, hotel, heroTag),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: Hero(tag: heroTag, child: AppImage(hotel.cover)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        hotel.city,
                        ?hotelDistance(context, hotel),
                      ].join('  •  '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        RatingBadge(rating: hotel.rating),
                        const Spacer(),
                        PriceTag(price: hotel.pricePerNight),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FavoriteButton(hotel: hotel, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

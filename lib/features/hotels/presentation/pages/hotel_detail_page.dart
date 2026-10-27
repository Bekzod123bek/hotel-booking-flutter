import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_image.dart';
import '../../domain/entities.dart';
import '../widgets/hotel_widgets.dart';
import 'booking_page.dart';
import '../../../../core/l10n/l10n.dart';
import '../widgets/hotel_map.dart';

class HotelDetailPage extends StatefulWidget {
  const HotelDetailPage({
    super.key,
    required this.hotel,
    required this.heroTag,
  });

  final Hotel hotel;
  final String heroTag;

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  final _gallery = PageController();
  int _photo = 0;
  bool _expanded = false;

  Hotel get hotel => widget.hotel;

  @override
  void dispose() {
    _gallery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton.filledTonal(
                tooltip: context.l10n.back,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FavoriteButton(hotel: hotel),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _gallery,
                    itemCount: hotel.images.length,
                    onPageChanged: (i) => setState(() => _photo = i),
                    itemBuilder: (_, i) {
                      final image = AppImage(hotel.images[i]);
                      return i == 0
                          ? Hero(tag: widget.heroTag, child: image)
                          : image;
                    },
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_photo + 1} / ${hotel.images.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < hotel.images.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _photo ? 20 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: i == _photo
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList.list(
              children: [
                Text(hotel.name, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 18, color: muted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hotel.address,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: muted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    RatingBadge(rating: hotel.rating),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.reviewsCount(hotel.reviewCount),
                      style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(context.l10n.about, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  child: Text(
                    hotel.description,
                    maxLines: _expanded ? null : 3,
                    overflow: _expanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => setState(() => _expanded = !_expanded),
                    child: Text(
                      _expanded ? context.l10n.showLess : context.l10n.readMore,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(context.l10n.amenities, style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final a in hotel.amenities) _Amenity(name: a),
                  ],
                ),
                const SizedBox(height: 28),
                Text(context.l10n.location, style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                HotelMap(hotel: hotel),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.reviews,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    const Icon(Icons.star_rounded, color: Color(0xFFFFB547)),
                    Text(
                      ' ${hotel.rating.toStringAsFixed(1)}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final r in hotel.reviews) ...[
                  _ReviewCard(review: r),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BookBar(hotel: hotel),
    );
  }
}

class _Amenity extends StatelessWidget {
  const _Amenity({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(amenityIcon(name), size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            amenityLabel(context.l10n, name),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  child: Text(review.author[0]),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.author, style: theme.textTheme.titleSmall),
                      Text(
                        DateFormat(
                          'd MMM yyyy',
                          Localizations.localeOf(context).toString(),
                        ).format(review.date),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                RatingBadge(rating: review.rating),
              ],
            ),
            const SizedBox(height: 10),
            Text(review.text, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _BookBar extends StatelessWidget {
  const _BookBar({required this.hotel});

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.from, style: theme.textTheme.bodySmall),
                  PriceTag(price: hotel.pricePerNight),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BookingPage(hotel: hotel),
                    ),
                  ),
                  child: Text(context.l10n.selectRoom),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

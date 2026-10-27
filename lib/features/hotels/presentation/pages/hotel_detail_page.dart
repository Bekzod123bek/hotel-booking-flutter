import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../domain/entities.dart';
import '../widgets/hotel_widgets.dart';
import 'booking_page.dart';
import '../../../../core/l10n/l10n.dart';
import '../widgets/hotel_map.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_tokens.dart';

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
              padding: const EdgeInsets.all(10),
              child: GlassIconButton(
                icon: Icons.arrow_back,
                tooltip: context.l10n.back,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FavoriteButton(hotel: hotel),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                child: Stack(
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
          ),
          SliverReadableWidth(
            maxWidth: 760,
            sliver: SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList.list(
              children: [
                if (hotel.images.length > 1) ...[
                  _Thumbnails(
                    images: hotel.images,
                    current: _photo,
                    onPick: (i) {
                      setState(() => _photo = i);
                      _gallery.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(width: 12),
                    PriceTag(price: hotel.pricePerNight),
                  ],
                ),
                const SizedBox(height: 8),
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
                    const SizedBox(width: 10),
                    RatingBadge(rating: hotel.rating),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.reviewsCount(hotel.reviewCount),
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
                const SizedBox(height: 22),
                Text(context.l10n.amenities, style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                _AmenityRow(amenities: hotel.amenities),
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
                const SizedBox(height: 20),
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
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.of(context).accent,
                    ),
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
          ),
        ],
      ),
      bottomNavigationBar: _BookBar(hotel: hotel),
    );
  }
}

/// Small previews under the photo; tapping one jumps the gallery to it.
class _Thumbnails extends StatelessWidget {
  const _Thumbnails({
    required this.images,
    required this.current,
    required this.onPick,
  });

  final List<String> images;
  final int current;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = i == current;
          return Semantics(
            button: true,
            selected: selected,
            label: '${i + 1}/${images.length}',
            child: GestureDetector(
              onTap: () => onPick(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 76,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? scheme.primary : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: AppImage(images[i]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Amenities as icon tiles, scrolling sideways when they do not fit.
class _AmenityRow extends StatelessWidget {
  const _AmenityRow({required this.amenities});

  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: amenities.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _AmenityTile(name: amenities[i]),
      ),
    );
  }
}

class _AmenityTile extends StatelessWidget {
  const _AmenityTile({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: 92,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(amenityIcon(name), size: 22, color: scheme.primary),
          const SizedBox(height: 8),
          Text(
            amenityLabel(context.l10n, name),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
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

  Future<void> _share(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.l10n.copied;
    await Clipboard.setData(
      ClipboardData(text: '${hotel.name}\n${hotel.address}'),
    );
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _share(context),
                  child: Text(
                    l10n.share,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GradientButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BookingPage(hotel: hotel),
                    ),
                  ),
                  child: Text(l10n.bookNow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

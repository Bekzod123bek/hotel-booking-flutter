import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_image.dart';
import '../../domain/entities.dart';
import '../widgets/hotel_widgets.dart';
import 'booking_page.dart';

class HotelDetailPage extends StatefulWidget {
  const HotelDetailPage({super.key, required this.hotel, required this.heroTag});

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
                tooltip: 'Back',
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
                          horizontal: 10, vertical: 5),
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
                              color: i == _photo ? Colors.white : Colors.white54,
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
                      child: Text(hotel.address,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: muted)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    RatingBadge(rating: hotel.rating),
                    const SizedBox(width: 8),
                    Text('${hotel.reviewCount} reviews',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: muted)),
                  ],
                ),
                const SizedBox(height: 24),
                Text('About', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  child: Text(
                    hotel.description,
                    maxLines: _expanded ? null : 3,
                    overflow:
                        _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => setState(() => _expanded = !_expanded),
                    child: Text(_expanded ? 'Show less' : 'Read more'),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Amenities', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final a in hotel.amenities) _Amenity(name: a),
                  ],
                ),
                const SizedBox(height: 28),
                Text('Location', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                _MapPlaceholder(address: hotel.address),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Text('Reviews', style: theme.textTheme.titleLarge),
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
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Stand-in for a real map, which would need a maps SDK and an API key.
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.tertiaryContainer],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(scheme.onPrimaryContainer.withValues(alpha: 0.08)),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 44, color: scheme.primary),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    address,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Text(
                  'Map preview',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
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
                        DateFormat('d MMM yyyy').format(review.date),
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
                  Text('From', style: theme.textTheme.bodySmall),
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
                  child: const Text('Select room'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

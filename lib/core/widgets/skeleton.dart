import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmering grey block used while content is loading.
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.width, this.height, this.radius = 0});

  /// Turned off in widget tests so that `pumpAndSettle` can finish.
  static bool animate = true;

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF20282B) : const Color(0xFFE4E9EA);
    final highlight = isDark ? const Color(0xFF2C3639) : const Color(0xFFF4F7F7);
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    if (!animate) return box;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: box,
    );
  }
}

/// Placeholder shaped like a hotel card.
class HotelCardSkeleton extends StatelessWidget {
  const HotelCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton(height: 190, radius: 20),
        SizedBox(height: 12),
        Skeleton(width: 180, height: 18, radius: 6),
        SizedBox(height: 8),
        Skeleton(width: 120, height: 14, radius: 6),
      ],
    );
  }
}

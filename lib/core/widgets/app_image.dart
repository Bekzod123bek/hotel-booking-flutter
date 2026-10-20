import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'skeleton.dart';

/// Network image with caching, a skeleton placeholder and an error fallback.
class AppImage extends StatelessWidget {
  const AppImage(this.url, {super.key, this.fit = BoxFit.cover});

  /// Turned off in widget tests, where real network calls are not possible.
  static bool networkEnabled = true;

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (!networkEnabled) return const _Fallback(icon: Icons.image_outlined);
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (_, _) => const Skeleton(),
      errorWidget: (_, _, _) =>
          const _Fallback(icon: Icons.broken_image_outlined),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(icon, color: scheme.outline, size: 32),
    );
  }
}

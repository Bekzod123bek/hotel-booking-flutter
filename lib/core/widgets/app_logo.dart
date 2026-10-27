import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// The app mark: a location pin with a hotel facade inside it.
///
/// Shown on the sign-in header and in the about dialog. The asset already
/// carries the brand gradient, so it needs no tinting.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72, this.label});

  final double size;

  /// Read out by screen readers; omit inside a labelled row.
  final String? label;

  @override
  Widget build(BuildContext context) {
    // Decoded at the size it is drawn at, not the asset's 256px.
    final pixels = (size * MediaQuery.devicePixelRatioOf(context)).round();
    final image = Image.asset(
      'assets/brand/logo_256.png',
      width: size,
      height: size,
      cacheWidth: pixels,
      cacheHeight: pixels,
      filterQuality: FilterQuality.medium,
      // A coloured rounded square keeps the slot filled if the asset is
      // missing, instead of showing a broken-image glyph.
      errorBuilder: (context, _, _) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: AppColors.of(context).brandGradient,
          borderRadius: BorderRadius.circular(size * 0.223),
        ),
        child: Icon(
          Icons.location_city,
          size: size * 0.5,
          color: AppColors.of(context).onBrand,
        ),
      ),
    );
    return label == null
        ? ExcludeSemantics(child: image)
        : Semantics(label: label, image: true, child: image);
  }
}

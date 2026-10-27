/// Design tokens in three layers, the way a design system is normally built:
///
/// * [_Palette] — primitive values. Raw colours, nothing about meaning.
/// * [AppColors] — semantic tokens. What a colour is *for*, per brightness.
/// * [Radii], [Spacing], [Motion], [Shadows] — the shape, rhythm and timing
///   scales the whole app measures itself against.
///
/// Widgets never write a raw `Color(0x...)`: they read a token, or the
/// `ColorScheme` that [AppTheme] builds from these tokens. That is what keeps
/// light and dark in step and makes a rebrand a one-file change.
library;

import 'package:flutter/material.dart';


/// Primitive palette. Private on purpose — only [AppColors] may name these.
abstract final class _Palette {
  // Brand: a sky-to-ocean ramp.
  /// Decorative only: too light to carry white text.
  static const cyan300 = Color(0xFF3ECFF5);

  /// Deep enough that white text on it clears 4.5:1 (see theme_test.dart).
  static const lagoon600 = Color(0xFF0C76A6);
  static const blue700 = Color(0xFF1D5FC4);

  // Accent: what the guest picks (dates, guests, rating).
  static const amber500 = Color(0xFFF7A325);

  // Status.
  static const green500 = Color(0xFF2BA463);
  static const red500 = Color(0xFFD64545);

  // Neutrals, warmed slightly towards the brand so greys never look muddy.
  static const ink900 = Color(0xFF0E2638);
  static const ink700 = Color(0xFF5B7383);
  static const ink100 = Color(0xFFD9E8F2);
  static const skyTop = Color(0xFFE4F4FE);
  static const skyBottom = Color(0xFFF4FAFE);
  static const white = Color(0xFFFFFFFF);

  static const night900 = Color(0xFF0A141C);
  static const night800 = Color(0xFF0C1C28);
  static const night700 = Color(0xFF101C26);
  static const night600 = Color(0xFF16222D);
  static const night500 = Color(0xFF203240);
  static const mist400 = Color(0xFF9FB3C0);
  static const mist100 = Color(0xFFE8F2F8);
}

/// Semantic colours for one brightness.
///
/// Read these through `AppColors.of(context)` rather than constructing one.
class AppColors {
  const AppColors._({
    required this.brightness,
    required this.primary,
    required this.primaryStart,
    required this.primaryEnd,
    required this.accent,
    required this.success,
    required this.danger,
    required this.surface,
    required this.card,
    required this.sheet,
    required this.ink,
    required this.inkMuted,
    required this.hairline,
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.glassTint,
    required this.glassBorder,
    required this.scrim,
    required this.onBrand,
  });

  static const light = AppColors._(
    brightness: Brightness.light,
    primary: _Palette.blue700,
    primaryStart: _Palette.lagoon600,
    primaryEnd: _Palette.blue700,
    accent: _Palette.amber500,
    success: _Palette.green500,
    danger: _Palette.red500,
    surface: _Palette.skyBottom,
    card: _Palette.white,
    sheet: _Palette.white,
    ink: _Palette.ink900,
    inkMuted: _Palette.ink700,
    hairline: _Palette.ink100,
    backgroundTop: _Palette.skyTop,
    backgroundBottom: _Palette.skyBottom,
    skeletonBase: Color(0xFFE2EDF5),
    skeletonHighlight: Color(0xFFF3F9FD),
    glassTint: Color(0x9EFFFFFF),
    glassBorder: Color(0xBFFFFFFF),
    scrim: Color(0x8C000000),
    onBrand: _Palette.white,
  );

  static const dark = AppColors._(
    brightness: Brightness.dark,
    primary: _Palette.cyan300,
    primaryStart: _Palette.lagoon600,
    primaryEnd: _Palette.blue700,
    accent: _Palette.amber500,
    success: _Palette.green500,
    danger: _Palette.red500,
    surface: _Palette.night900,
    card: _Palette.night600,
    sheet: _Palette.night700,
    ink: _Palette.mist100,
    inkMuted: _Palette.mist400,
    hairline: _Palette.night500,
    backgroundTop: _Palette.night800,
    backgroundBottom: _Palette.night900,
    skeletonBase: _Palette.night500,
    skeletonHighlight: Color(0xFF2A3F4F),
    glassTint: Color(0x8C0C1C28),
    glassBorder: Color(0x24FFFFFF),
    scrim: Color(0xA6000000),
    onBrand: _Palette.white,
  );

  final Brightness brightness;

  /// Brand colour for icons, links and selected states.
  final Color primary;

  /// Ends of the gradient used on primary buttons and brand surfaces.
  final Color primaryStart;
  final Color primaryEnd;

  /// What the guest chose: selected dates, counters, rating stars.
  final Color accent;
  final Color success;
  final Color danger;

  /// Page surface under the background gradient.
  final Color surface;

  /// Raised containers: cards, inputs, menus.
  final Color card;

  /// Bottom sheets and dialogs, a step away from [card] in dark mode.
  final Color sheet;

  final Color ink;
  final Color inkMuted;

  /// 1px separators and input outlines.
  final Color hairline;

  final Color backgroundTop;
  final Color backgroundBottom;

  final Color skeletonBase;
  final Color skeletonHighlight;

  /// Fill and border of frosted surfaces (the floating navigation).
  final Color glassTint;
  final Color glassBorder;

  /// Darkening laid over a photo so white text stays readable on it.
  final Color scrim;

  /// Text and icons on top of [primary] or the brand gradient.
  final Color onBrand;

  static AppColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  LinearGradient get brandGradient => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryStart, primaryEnd],
  );

  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundTop, backgroundBottom],
  );

  /// Fades a photo into darkness so overlaid text keeps its contrast.
  LinearGradient get photoScrim => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [const Color(0x00000000), scrim],
    stops: const [0.45, 1],
  );
}

/// Corner radii. Cards and sheets are generously rounded; controls are pills.
abstract final class Radii {
  static const sm = 14.0;
  static const md = 18.0;
  static const lg = 24.0;
  static const xl = 32.0;

  /// Anything round enough to read as a pill.
  static const pill = 999.0;
}

/// 4-point spacing scale.
abstract final class Spacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 28.0;
}

/// Durations, kept short so the app never feels slow.
abstract final class Motion {
  static const quick = Duration(milliseconds: 180);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
}

/// The two shadows the app uses: one to lift a surface, one to make the
/// primary button glow in its own colour.
abstract final class Shadows {
  static List<BoxShadow> lift(AppColors colors) => [
    BoxShadow(
      color: Colors.black.withValues(
        alpha: colors.brightness == Brightness.dark ? 0.45 : 0.14,
      ),
      blurRadius: 28,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> brand(AppColors colors) => [
    BoxShadow(
      color: colors.primaryEnd.withValues(alpha: 0.28),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}

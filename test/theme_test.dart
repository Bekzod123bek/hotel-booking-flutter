import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/theme/app_theme.dart';
import 'package:hotel_booking/core/theme/app_tokens.dart';

/// Relative luminance, per WCAG 2.1.
double _luminance(Color c) => c.computeLuminance();

double _contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  group('tokens', () {
    test('both themes define every semantic colour', () {
      for (final colors in [AppColors.light, AppColors.dark]) {
        expect(colors.primary.a, 1.0, reason: 'primary must be opaque');
        expect(colors.card.a, 1.0, reason: 'cards must be opaque');
        expect(colors.brandGradient.colors, hasLength(2));
        expect(colors.backgroundGradient.colors, hasLength(2));
      }
    });

    test('body text meets the 4.5:1 contrast floor on its surface', () {
      for (final colors in [AppColors.light, AppColors.dark]) {
        expect(
          _contrast(colors.ink, colors.card),
          greaterThanOrEqualTo(4.5),
          reason: '${colors.brightness} ink on card',
        );
        expect(
          _contrast(colors.ink, colors.surface),
          greaterThanOrEqualTo(4.5),
          reason: '${colors.brightness} ink on surface',
        );
      }
    });

    test('muted text still clears the 3:1 floor for large text', () {
      for (final colors in [AppColors.light, AppColors.dark]) {
        expect(
          _contrast(colors.inkMuted, colors.card),
          greaterThanOrEqualTo(3.0),
          reason: '${colors.brightness} muted ink',
        );
      }
    });

    // Button labels are 16px bold, which WCAG still counts as normal text,
    // so both ends of the gradient must clear 4.5:1 against white.
    test('text on the brand gradient is readable at both ends', () {
      for (final colors in [AppColors.light, AppColors.dark]) {
        for (final end in [colors.primaryStart, colors.primaryEnd]) {
          expect(
            _contrast(colors.onBrand, end),
            greaterThanOrEqualTo(4.5),
            reason: '${colors.brightness} on $end',
          );
        }
      }
    });

    test('light and dark are actually different', () {
      expect(AppColors.light.surface, isNot(AppColors.dark.surface));
      expect(AppColors.light.card, isNot(AppColors.dark.card));
      expect(AppColors.light.brightness, Brightness.light);
      expect(AppColors.dark.brightness, Brightness.dark);
    });
  });

  group('theme', () {
    test('is built from the tokens', () {
      final light = AppTheme.light();
      expect(light.colorScheme.primary, AppColors.light.primary);
      expect(light.colorScheme.onSurface, AppColors.light.ink);
      expect(light.cardTheme.color, AppColors.light.card);
      // The gradient is painted by AppBackground, so the scaffold is clear.
      expect(light.scaffoldBackgroundColor, Colors.transparent);

      final dark = AppTheme.dark();
      expect(dark.colorScheme.primary, AppColors.dark.primary);
      expect(dark.brightness, Brightness.dark);
    });

    test('buttons are tall enough to tap comfortably', () {
      final style = AppTheme.light().filledButtonTheme.style!;
      final size = style.minimumSize!.resolve({})!;
      expect(size.height, greaterThanOrEqualTo(48));
    });
  });
}

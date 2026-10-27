import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/widgets/app_image.dart';
import 'package:hotel_booking/core/widgets/glass_nav.dart';
import 'package:hotel_booking/core/widgets/skeleton.dart';
import 'package:hotel_booking/features/hotels/presentation/pages/hotels_map_page.dart';
import 'package:hotel_booking/features/hotels/presentation/widgets/hotel_map.dart';
import 'package:hotel_booking/injection.dart';
import 'package:hotel_booking/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sets the window to [size] for one test.
Future<void> _openApp(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({
    'onboarding_done': true,
    'logged_in': true,
    'user_name': 'Test User',
    'user_email': 'test@example.com',
  });
  await setupDependencies(fast: true);
  await tester.pumpWidget(const HotelBookingApp());
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    AppImage.networkEnabled = false;
    Skeleton.animate = false;
    HotelMap.networkEnabled = false;
    HotelsMapPage.networkEnabled = false;
  });

  testWidgets('a phone keeps the floating bar at the bottom', (tester) async {
    await _openApp(tester, const Size(390, 844));
    expect(find.byType(GlassNavBar), findsOneWidget);
    expect(find.byType(GlassNavRail), findsNothing);
  });

  testWidgets('a tablet moves navigation to the side rail', (tester) async {
    await _openApp(tester, const Size(834, 1112));
    expect(find.byType(GlassNavRail), findsOneWidget);
    expect(find.byType(GlassNavBar), findsNothing);
  });

  testWidgets('a desktop window also uses the rail', (tester) async {
    await _openApp(tester, const Size(1440, 900));
    expect(find.byType(GlassNavRail), findsOneWidget);
  });

  testWidgets('every tab lays out at phone and desktop size', (tester) async {
    for (final size in [const Size(360, 780), const Size(1280, 800)]) {
      await _openApp(tester, size);
      for (final label in ['Favorites', 'Bookings', 'Profile', 'Explore']) {
        await tester.tap(find.text(label).first);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$label at $size');
      }
    }
  });
}

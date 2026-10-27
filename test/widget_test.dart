import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/theme/theme_cubit.dart';
import 'package:hotel_booking/core/widgets/gradient_button.dart';
import 'package:hotel_booking/core/widgets/app_image.dart';
import 'package:hotel_booking/core/widgets/skeleton.dart';
import 'package:hotel_booking/features/auth/data/local_auth_repository.dart';
import 'package:hotel_booking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:hotel_booking/features/hotels/data/local_user_data_repository.dart';
import 'package:hotel_booking/features/hotels/data/mock_hotel_repository.dart';
import 'package:hotel_booking/features/hotels/data/sample_hotels.dart';
import 'package:hotel_booking/features/hotels/domain/entities.dart';
import 'package:hotel_booking/features/hotels/domain/hotel_repository.dart';
import 'package:hotel_booking/features/hotels/presentation/cubit/favorites_cubit.dart';
import 'package:hotel_booking/features/hotels/presentation/cubit/hotels_cubit.dart';
import 'package:hotel_booking/injection.dart';
import 'package:hotel_booking/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_booking/features/hotels/presentation/widgets/hotel_map.dart';
import 'package:hotel_booking/features/hotels/presentation/pages/hotels_map_page.dart';

Future<SharedPreferences> _prefs([Map<String, Object> values = const {}]) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

class _NoLocation implements LocationService {
  @override
  Future<LocationResult> currentPosition() async =>
      const LocationResult.failed(LocationIssue.unavailable);

  @override
  Future<void> openSettings() async {}
}

void main() {
  setUpAll(() {
    AppImage.networkEnabled = false;
    Skeleton.animate = false;
    HotelMap.networkEnabled = false;
    HotelsMapPage.networkEnabled = false;
  });

  group('HotelFilter', () {
    test('filters by city, price, rating and amenities', () {
      final result = const HotelFilter(
        city: 'Tashkent',
        maxPrice: 130,
        minRating: 4.4,
        amenities: {'Pool'},
      ).apply(sampleHotels);
      expect(result.map((h) => h.name), ['Tashkent City View']);
    });

    test('search matches name or city, case insensitive', () {
      expect(
        const HotelFilter(query: 'BUKHARA').apply(sampleHotels).single.name,
        'Silk Road Inn',
      );
      expect(
        const HotelFilter(query: 'palace').apply(sampleHotels).single.city,
        'Samarkand',
      );
    });

    test('sorts by price and rating', () {
      final cheap =
          const HotelFilter(sort: HotelSort.priceLow).apply(sampleHotels);
      for (var i = 1; i < cheap.length; i++) {
        expect(cheap[i].pricePerNight,
            greaterThanOrEqualTo(cheap[i - 1].pricePerNight));
      }
      final top = const HotelFilter(sort: HotelSort.rating).apply(sampleHotels);
      expect(top.first.rating, 4.8);
    });

    test('activeCount ignores search and city', () {
      const filter = HotelFilter(
        query: 'x',
        city: 'Khiva',
        minRating: 4.5,
        sort: HotelSort.priceHigh,
      );
      expect(filter.activeCount, 2);
      expect(const HotelFilter().isDefault, isTrue);
    });
  });

  test('every hotel has a photo gallery and reviews', () {
    for (final h in sampleHotels) {
      expect(h.images.length, greaterThanOrEqualTo(3), reason: h.name);
      expect(h.reviews, isNotEmpty, reason: h.name);
    }
  });

  group('Cubits', () {
    test('HotelsCubit loads hotels and applies the city filter', () async {
      final cubit = HotelsCubit(
        MockHotelRepository(delay: Duration.zero),
        _NoLocation(),
      );
      await cubit.load();
      expect(cubit.state.all, hasLength(sampleHotels.length));
      expect(cubit.state.featured, isNotEmpty);

      cubit.selectCity('Khiva');
      expect(cubit.state.results.single.name, 'Khiva Fortress Lodge');

      cubit.resetFilters();
      expect(cubit.state.filter.city, 'Khiva');
      cubit.selectCity(null);
      expect(cubit.state.results, hasLength(sampleHotels.length));
    });

    test('FavoritesCubit persists favorites', () async {
      final prefs = await _prefs();
      final repo = LocalFavoritesRepository(prefs);

      final cubit = FavoritesCubit(repo);
      expect(await cubit.toggle('h1'), isTrue);
      expect(cubit.state, {'h1'});

      final reloaded = FavoritesCubit(repo);
      await reloaded.load();
      expect(reloaded.state, {'h1'});

      expect(await reloaded.toggle('h1'), isFalse);
      expect(prefs.getStringList('favorite_hotels'), isEmpty);
    });

    test('AuthCubit: onboarding -> sign in -> log out', () async {
      final prefs = await _prefs();
      final repo = LocalAuthRepository(prefs, delay: Duration.zero);
      final cubit = AuthCubit(repo);
      expect(cubit.state.status, AuthStatus.onboarding);

      await cubit.completeOnboarding();
      expect(cubit.state.status, AuthStatus.unauthenticated);

      await cubit.login('bekzod.abdurahimov@example.com', 'secret1');
      expect(cubit.state.status, AuthStatus.authenticated);
      expect(cubit.state.user?.name, 'Bekzod Abdurahimov');
      expect(cubit.state.user?.initials, 'BA');
      expect(prefs.getKeys().any((k) => k.contains('password')), isFalse);

      // A fresh cubit restores the session.
      expect(AuthCubit(repo).state.status, AuthStatus.authenticated);

      await cubit.logout();
      expect(AuthCubit(repo).state.status, AuthStatus.unauthenticated);
    });

    test('ThemeCubit remembers the choice', () async {
      final prefs = await _prefs();
      expect(ThemeCubit(prefs).state, ThemeMode.system);
      await ThemeCubit(prefs).setDark(true);
      expect(ThemeCubit(prefs).state, ThemeMode.dark);
    });
  });

  group('App', () {
    testWidgets('onboarding, sign up and home list', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.6;
      addTearDown(tester.view.reset);

      SharedPreferences.setMockInitialValues({});
      await setupDependencies(fast: true);
      await tester.pumpWidget(const HotelBookingApp());
      await tester.pumpAndSettle();

      expect(find.text('Discover places to stay'), findsOneWidget);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      // Empty form shows validation errors.
      await tester.tap(find.widgetWithText(GradientButton, 'Create account'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full name'), 'Bekzod Abdurahimov');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'bekzod@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'secret1');
      await tester.tap(find.widgetWithText(GradientButton, 'Create account'));
      await tester.pumpAndSettle();

      expect(find.text('Hello, Bekzod 👋'), findsOneWidget);
      expect(find.text('Featured stays'), findsOneWidget);
      expect(find.text('Popular hotels'), findsOneWidget);
    });

    testWidgets('opens a hotel and adds it to favorites', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.6;
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

      await tester.enterText(find.byType(TextField), 'khiva');
      await tester.pumpAndSettle();
      expect(find.text('1 stay found'), findsOneWidget);

      await tester.tap(find.text('Khiva Fortress Lodge'));
      await tester.pumpAndSettle();
      expect(find.text('Amenities'), findsOneWidget);
      expect(find.text('Book now'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Open in maps app'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Open in maps app'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Amenities'),
        -300,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.tap(find.byTooltip('Add to favorites').first);
      await tester.pumpAndSettle();
      expect(sl<SharedPreferences>().getStringList('favorite_hotels'), ['h4']);
    });
  });
}

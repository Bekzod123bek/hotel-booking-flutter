import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/core/layout/breakpoints.dart';
import 'package:hotel_booking/features/hotels/data/mock_hotel_repository.dart';
import 'package:hotel_booking/features/hotels/data/sample_hotels.dart';
import 'package:hotel_booking/features/hotels/domain/entities.dart';
import 'package:hotel_booking/features/hotels/domain/hotel_repository.dart';
import 'package:hotel_booking/features/hotels/presentation/cubit/hotels_cubit.dart';

class _FakeLocation implements LocationService {
  _FakeLocation(this.result);

  final LocationResult result;
  int settingsOpened = 0;

  @override
  Future<LocationResult> currentPosition() async => result;

  @override
  Future<void> openSettings() async => settingsOpened++;
}

const _tashkent = GeoPoint(41.3111, 69.2797);

HotelsCubit _cubit(LocationService location) =>
    HotelsCubit(MockHotelRepository(delay: Duration.zero), location);

void main() {
  group('GeoPoint', () {
    test('measures the distance between two cities', () {
      const samarkand = GeoPoint(39.6547, 66.9758);
      // Tashkent to Samarkand is about 270 km in a straight line.
      expect(_tashkent.distanceKmTo(samarkand), closeTo(270, 15));
      expect(_tashkent.distanceKmTo(_tashkent), 0);
    });

    test('is symmetric', () {
      const khiva = GeoPoint(41.3783, 60.3589);
      expect(
        _tashkent.distanceKmTo(khiva),
        closeTo(khiva.distanceKmTo(_tashkent), 0.001),
      );
    });
  });

  test('nearest sort orders hotels by distance from the user', () {
    final sorted = const HotelFilter(
      sort: HotelSort.nearest,
      origin: _tashkent,
    ).apply(sampleHotels);
    expect(sorted.first.city, anyOf('Tashkent', 'Tashkent region'));
    for (var i = 1; i < sorted.length; i++) {
      expect(
        _tashkent.distanceKmTo(sorted[i].position),
        greaterThanOrEqualTo(_tashkent.distanceKmTo(sorted[i - 1].position)),
      );
    }
  });

  test('nearest sort leaves the order alone when the position is unknown', () {
    final sorted = const HotelFilter(
      sort: HotelSort.nearest,
    ).apply(sampleHotels).map((h) => h.id);
    expect(sorted, sampleHotels.map((h) => h.id));
  });

  group('findNearby', () {
    test('stores the position and switches to the nearest sort', () async {
      final cubit = _cubit(
        _FakeLocation(const LocationResult.found(_tashkent)),
      );
      await cubit.load();
      await cubit.findNearby();

      expect(cubit.state.locating, isFalse);
      expect(cubit.state.locationIssue, isNull);
      expect(cubit.state.origin, _tashkent);
      expect(cubit.state.filter.sort, HotelSort.nearest);
      expect(
        cubit.state.results.first.city,
        anyOf('Tashkent', 'Tashkent region'),
      );
    });

    test(
      'reports why the location is missing and keeps the list usable',
      () async {
        final cubit = _cubit(
          _FakeLocation(const LocationResult.failed(LocationIssue.denied)),
        );
        await cubit.load();
        await cubit.findNearby();

        expect(cubit.state.locationIssue, LocationIssue.denied);
        expect(cubit.state.origin, isNull);
        expect(cubit.state.filter.sort, HotelSort.recommended);
        expect(cubit.state.results, hasLength(sampleHotels.length));

        cubit.dismissLocationIssue();
        expect(cubit.state.locationIssue, isNull);
      },
    );
  });

  group('WindowSize', () {
    test('follows the Material 3 breakpoints', () {
      expect(WindowSize.fromWidth(375), WindowSize.compact);
      expect(WindowSize.fromWidth(599), WindowSize.compact);
      expect(WindowSize.fromWidth(600), WindowSize.medium);
      expect(WindowSize.fromWidth(840), WindowSize.expanded);
      expect(WindowSize.fromWidth(1400), WindowSize.large);
    });

    test('only a phone keeps the bottom navigation bar', () {
      expect(WindowSize.compact.usesSideNavigation, isFalse);
      for (final size in [
        WindowSize.medium,
        WindowSize.expanded,
        WindowSize.large,
      ]) {
        expect(size.usesSideNavigation, isTrue, reason: size.name);
      }
    });

    test('adds columns as the window grows', () {
      expect(WindowSize.compact.hotelColumns, 1);
      expect(WindowSize.large.hotelColumns, greaterThan(1));
    });
  });
}

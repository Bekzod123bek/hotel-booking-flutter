import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities.dart';
import '../domain/hotel_repository.dart';
import 'sample_hotels.dart';

/// Hotels come from [sampleHotels]; no backend is used. Favorites and
/// bookings are stored on the device with [SharedPreferences].
class MockHotelRepository implements HotelRepository {
  MockHotelRepository(
    this._prefs, {
    this.delay = const Duration(milliseconds: 900),
  });

  static const _favoritesKey = 'favorite_hotels';
  static const _bookingsKey = 'bookings';

  final SharedPreferences _prefs;
  final Duration delay;

  @override
  Future<List<Hotel>> getHotels() async {
    await Future<void>.delayed(delay);
    return sampleHotels;
  }

  @override
  Future<Set<String>> getFavoriteIds() async =>
      (_prefs.getStringList(_favoritesKey) ?? const []).toSet();

  @override
  Future<void> saveFavoriteIds(Set<String> ids) =>
      _prefs.setStringList(_favoritesKey, ids.toList());

  @override
  Future<List<Booking>> getBookings() async {
    final raw = _prefs.getString(_bookingsKey);
    if (raw == null) return const [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Booking.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveBookings(List<Booking> bookings) => _prefs.setString(
        _bookingsKey,
        jsonEncode(bookings.map((b) => b.toJson()).toList()),
      );
}

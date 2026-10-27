import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities.dart';
import '../domain/hotel_repository.dart';

/// Favorites kept on the device with [SharedPreferences].
class LocalFavoritesRepository implements FavoritesRepository {
  LocalFavoritesRepository(this._prefs);

  static const _key = 'favorite_hotels';

  final SharedPreferences _prefs;

  @override
  Future<Set<String>> getFavoriteIds() async =>
      (_prefs.getStringList(_key) ?? const []).toSet();

  @override
  Future<void> saveFavoriteIds(Set<String> ids) =>
      _prefs.setStringList(_key, ids.toList());
}

/// Bookings kept on the device. There are no other guests in this mode, so
/// only the user's own bookings can make a room unavailable.
class LocalBookingRepository implements BookingRepository {
  LocalBookingRepository(this._prefs);

  static const _key = 'bookings';

  final SharedPreferences _prefs;

  @override
  Future<List<Booking>> getBookings() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return const [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Booking.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Booking> create(BookingRequest request, {required DateTime now}) async {
    final existing = await getBookings();
    final sameHotel = existing.where((b) => b.hotelId == request.hotel.id);

    if (sameHotel.any((b) => b.overlaps(request.checkIn, request.checkOut))) {
      throw const BookingFailure(BookingFailureReason.alreadyBooked);
    }

    final id = 'b${now.microsecondsSinceEpoch}';
    final booking = bookingFromRequest(request, id: id, now: now);
    await _save([...existing, booking]);
    return booking;
  }

  @override
  Future<void> cancel(Booking booking) async {
    final existing = await getBookings();
    await _save(existing.where((b) => b.id != booking.id).toList());
  }

  Future<void> _save(List<Booking> bookings) => _prefs.setString(
        _key,
        jsonEncode(bookings.map((b) => b.toJson()).toList()),
      );
}

/// Builds the saved [Booking] for a [request]. Shared by every repository.
Booking bookingFromRequest(
  BookingRequest request, {
  required String id,
  required DateTime now,
}) =>
    Booking(
      id: id,
      code: bookingCodeFor(id),
      hotelId: request.hotel.id,
      hotelName: request.hotel.name,
      city: request.hotel.city,
      image: request.hotel.cover,
      roomName: request.room.id,
      pricePerNight: request.hotel.priceFor(request.room),
      checkIn: request.checkIn,
      checkOut: request.checkOut,
      guests: request.guests,
      createdAt: now,
      guestName: request.guestName,
      guestPhone: request.guestPhone,
      payment: request.payment,
    );

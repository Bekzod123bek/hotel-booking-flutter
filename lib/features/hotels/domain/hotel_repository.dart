import 'entities.dart';

abstract class HotelRepository {
  Future<List<Hotel>> getHotels();
}

abstract class FavoritesRepository {
  Future<Set<String>> getFavoriteIds();
  Future<void> saveFavoriteIds(Set<String> ids);
}

abstract class BookingRepository {
  /// The signed-in user's bookings.
  Future<List<Booking>> getBookings();

  /// Reserves the room and returns the saved booking.
  ///
  /// Throws a [BookingFailure] when the room is sold out for one of the nights
  /// or the user already has a stay at the same hotel on these dates.
  Future<Booking> create(BookingRequest request, {required DateTime now});

  Future<void> cancel(Booking booking);
}

/// Takes the money for an online booking.
abstract class PaymentGateway {
  /// Completes when the payment succeeded; throws when it failed.
  Future<void> charge({required int amount, required String description});
}

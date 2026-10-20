import 'entities.dart';

abstract class HotelRepository {
  Future<List<Hotel>> getHotels();

  Future<Set<String>> getFavoriteIds();
  Future<void> saveFavoriteIds(Set<String> ids);

  Future<List<Booking>> getBookings();
  Future<void> saveBookings(List<Booking> bookings);
}

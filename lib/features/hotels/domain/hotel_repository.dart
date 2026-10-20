import 'entities.dart';

abstract class HotelRepository {
  Future<List<Hotel>> getHotels({String query = ''});
  Future<List<Booking>> getBookings();
  Future<Booking> book({
    required Hotel hotel,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
  });
  Future<void> cancel(String bookingId);
}

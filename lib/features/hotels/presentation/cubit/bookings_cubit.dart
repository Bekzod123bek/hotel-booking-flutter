import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/hotel_repository.dart';

/// Bookings, newest first.
class BookingsCubit extends Cubit<List<Booking>> {
  BookingsCubit(this._repository, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now,
        super(const []);

  final HotelRepository _repository;
  final DateTime Function() _clock;

  Future<void> load() async => emit(_sorted(await _repository.getBookings()));

  Future<Booking> book({
    required Hotel hotel,
    required RoomType room,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
  }) async {
    final now = _clock();
    final booking = Booking(
      id: 'b${now.microsecondsSinceEpoch}',
      hotelId: hotel.id,
      hotelName: hotel.name,
      city: hotel.city,
      image: hotel.cover,
      roomName: room.name,
      pricePerNight: hotel.priceFor(room),
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      createdAt: now,
    );
    final updated = _sorted([...state, booking]);
    emit(updated);
    await _repository.saveBookings(updated);
    return booking;
  }

  Future<void> cancel(String id) async {
    final updated = state.where((b) => b.id != id).toList();
    emit(updated);
    await _repository.saveBookings(updated);
  }

  static List<Booking> _sorted(List<Booking> bookings) =>
      [...bookings]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

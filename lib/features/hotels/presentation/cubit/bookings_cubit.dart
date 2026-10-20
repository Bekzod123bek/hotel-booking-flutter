import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/hotel_repository.dart';

class BookingsCubit extends Cubit<List<Booking>> {
  BookingsCubit(this._repository) : super(const []);

  final HotelRepository _repository;

  Future<void> load() async => emit(await _repository.getBookings());

  Future<Booking> book({
    required Hotel hotel,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
  }) async {
    final booking = await _repository.book(
      hotel: hotel,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
    );
    await load();
    return booking;
  }

  Future<void> cancel(String id) async {
    await _repository.cancel(id);
    await load();
  }
}

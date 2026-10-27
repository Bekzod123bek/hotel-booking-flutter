import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/hotel_repository.dart';

/// The user's bookings, newest first.
class BookingsCubit extends Cubit<List<Booking>> {
  BookingsCubit(
    this._repository,
    this._payments, {
    DateTime Function()? clock,
  })  : _clock = clock ?? DateTime.now,
        super(const []);

  final BookingRepository _repository;
  final PaymentGateway _payments;
  final DateTime Function() _clock;

  Future<void> load() async => emit(_sorted(await _repository.getBookings()));

  /// Forgets the bookings of the previous user (the saved ones stay).
  void clear() => emit(const []);

  /// Pays (for online bookings) and reserves the room.
  ///
  /// Throws a [BookingFailure] if the room cannot be booked. The room is
  /// reserved before the money is taken so nobody is charged for a sold-out
  /// room; if the payment then fails the reservation is released.
  Future<Booking> book(BookingRequest request) async {
    final booking = await _repository.create(request, now: _clock());
    if (request.payment == PaymentMethod.online) {
      try {
        await _payments.charge(
          amount: booking.total,
          description: '${booking.hotelName} ${booking.code}',
        );
      } catch (_) {
        await _repository.cancel(booking);
        throw const BookingFailure(BookingFailureReason.unknown);
      }
    }
    emit(_sorted([...state, booking]));
    return booking;
  }

  Future<void> cancel(Booking booking) async {
    await _repository.cancel(booking);
    emit(state.where((b) => b.id != booking.id).toList());
  }

  static List<Booking> _sorted(List<Booking> bookings) =>
      [...bookings]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

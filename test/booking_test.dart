import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/hotels/data/local_user_data_repository.dart';
import 'package:hotel_booking/features/hotels/data/sample_hotels.dart';
import 'package:hotel_booking/features/hotels/domain/entities.dart';
import 'package:hotel_booking/features/hotels/domain/hotel_repository.dart';
import 'package:hotel_booking/features/hotels/presentation/cubit/bookings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakePayments implements PaymentGateway {
  _FakePayments({this.fail = false});

  final bool fail;
  final charged = <int>[];

  @override
  Future<void> charge({
    required int amount,
    required String description,
  }) async {
    if (fail) throw Exception('declined');
    charged.add(amount);
  }
}

BookingRequest _request({
  required Hotel hotel,
  RoomType? room,
  DateTime? checkIn,
  DateTime? checkOut,
  PaymentMethod payment = PaymentMethod.atHotel,
}) => BookingRequest(
  hotel: hotel,
  room: room ?? RoomType.all.first,
  checkIn: checkIn ?? DateTime(2030, 1, 1),
  checkOut: checkOut ?? DateTime(2030, 1, 4),
  guests: 2,
  guestName: 'Test User',
  guestPhone: '+998901234567',
  payment: payment,
);

Future<LocalBookingRepository> _repo() async {
  SharedPreferences.setMockInitialValues({});
  return LocalBookingRepository(await SharedPreferences.getInstance());
}

void main() {
  final hotel = sampleHotels.first; // $85 per night

  test('BookingRequest lists every night but the check-out day', () {
    final nights = _request(hotel: hotel).nights;
    expect(nights, [
      DateTime(2030, 1, 1),
      DateTime(2030, 1, 2),
      DateTime(2030, 1, 3),
    ]);
  });

  test('books with room price, service fee, code and guest details', () async {
    final repo = await _repo();
    final payments = _FakePayments();
    final cubit = BookingsCubit(repo, payments, clock: () => DateTime(2030));

    final booking = await cubit.book(
      _request(hotel: hotel, room: RoomType.all[1]), // Deluxe x1.4
    );
    expect(booking.pricePerNight, 119);
    expect(booking.nights, 3);
    expect(booking.roomTotal, 357);
    expect(booking.serviceFee, 36);
    expect(booking.total, 393);
    expect(booking.roomName, 'deluxe');
    expect(booking.guestName, 'Test User');
    expect(booking.code, matches(RegExp(r'^HB-[A-Z2-9]{6}$')));
    expect(payments.charged, isEmpty, reason: 'pay at hotel charges nothing');

    expect((await repo.getBookings()).single, booking);

    await cubit.cancel(booking);
    expect(await repo.getBookings(), isEmpty);
    expect(cubit.state, isEmpty);
  });

  test(
    'refuses overlapping stays at the same hotel, allows back-to-back',
    () async {
      final cubit = BookingsCubit(await _repo(), _FakePayments());
      await cubit.book(_request(hotel: hotel));

      expect(
        () => cubit.book(
          _request(
            hotel: hotel,
            room: RoomType.all.last,
            checkIn: DateTime(2030, 1, 3),
            checkOut: DateTime(2030, 1, 5),
          ),
        ),
        throwsA(
          isA<BookingFailure>().having(
            (e) => e.reason,
            'reason',
            BookingFailureReason.alreadyBooked,
          ),
        ),
      );

      // Checking in on the day the previous guest leaves is fine, and so is a
      // different hotel on the same dates.
      await cubit.book(
        _request(
          hotel: hotel,
          checkIn: DateTime(2030, 1, 4),
          checkOut: DateTime(2030, 1, 6),
        ),
      );
      await cubit.book(_request(hotel: sampleHotels[1]));
      expect(cubit.state, hasLength(3));
    },
  );

  test(
    'online payment charges the total; a declined card leaves no booking',
    () async {
      final repo = await _repo();
      final payments = _FakePayments();
      final cubit = BookingsCubit(repo, payments);
      final booking = await cubit.book(
        _request(hotel: hotel, payment: PaymentMethod.online),
      );
      expect(payments.charged, [booking.total]);

      final declined = BookingsCubit(repo, _FakePayments(fail: true));
      await expectLater(
        declined.book(
          _request(hotel: sampleHotels[1], payment: PaymentMethod.online),
        ),
        throwsA(isA<BookingFailure>()),
      );
      expect(await repo.getBookings(), hasLength(1));
    },
  );

  test('old saved bookings without the new fields still load', () {
    final booking = Booking.fromJson({
      'id': 'b1',
      'hotelId': 'h1',
      'hotelName': 'Old',
      'city': 'Tashkent',
      'image': 'x',
      'roomName': 'Suite',
      'pricePerNight': 100,
      'checkIn': '2030-01-01T00:00:00.000',
      'checkOut': '2030-01-02T00:00:00.000',
      'guests': 1,
      'createdAt': '2029-12-01T00:00:00.000',
    });
    expect(booking.payment, PaymentMethod.atHotel);
    expect(booking.code, startsWith('HB-'));
    expect(RoomType.byKey(booking.roomName).id, 'suite');
  });

  test('booking codes are stable per id', () {
    expect(bookingCodeFor('abc'), bookingCodeFor('abc'));
    expect(bookingCodeFor('abc'), isNot(bookingCodeFor('abd')));
  });
}

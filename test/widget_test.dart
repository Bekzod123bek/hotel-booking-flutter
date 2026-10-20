import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/hotels/data/mock_hotel_repository.dart';
import 'package:hotel_booking/main.dart';
import 'package:hotel_booking/injection.dart';

void main() {
  test('booking total is nights * price per night', () async {
    final repo = MockHotelRepository();
    final hotel = (await repo.getHotels()).first;
    final booking = await repo.book(
      hotel: hotel,
      checkIn: DateTime(2030, 1, 1),
      checkOut: DateTime(2030, 1, 4),
      guests: 2,
    );
    expect(booking.nights, 3);
    expect(booking.total, 3 * hotel.pricePerNight);
  });

  test('search filters hotels by city', () async {
    final hotels = await MockHotelRepository().getHotels(query: 'bukhara');
    expect(hotels, hasLength(1));
    expect(hotels.single.city, 'Bukhara');
  });

  testWidgets('app shows the hotel list', (tester) async {
    await setupDependencies();
    await tester.pumpWidget(const HotelBookingApp());
    await tester.pumpAndSettle();
    expect(find.text('Registan Palace'), findsOneWidget);
  });
}

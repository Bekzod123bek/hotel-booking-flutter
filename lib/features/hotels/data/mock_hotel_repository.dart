import '../domain/entities.dart';
import '../domain/hotel_repository.dart';

/// In-memory repository with sample data. No backend is used.
class MockHotelRepository implements HotelRepository {
  static const _hotels = <Hotel>[
    Hotel(
      id: 'h1',
      name: 'Registan Palace',
      city: 'Samarkand',
      pricePerNight: 85,
      rating: 4.7,
      description: 'Boutique hotel a short walk from the Registan square.',
      amenities: ['Wi-Fi', 'Breakfast', 'Parking'],
      colorValue: 0xFF2E7D6B,
    ),
    Hotel(
      id: 'h2',
      name: 'Tashkent City View',
      city: 'Tashkent',
      pricePerNight: 120,
      rating: 4.5,
      description: 'Modern rooms in the city centre with a rooftop restaurant.',
      amenities: ['Wi-Fi', 'Pool', 'Gym', 'Breakfast'],
      colorValue: 0xFF3F51B5,
    ),
    Hotel(
      id: 'h3',
      name: 'Silk Road Inn',
      city: 'Bukhara',
      pricePerNight: 60,
      rating: 4.3,
      description: 'Traditional courtyard house in the old town.',
      amenities: ['Wi-Fi', 'Breakfast'],
      colorValue: 0xFFB5651D,
    ),
    Hotel(
      id: 'h4',
      name: 'Khiva Fortress Lodge',
      city: 'Khiva',
      pricePerNight: 55,
      rating: 4.4,
      description: 'Rooms inside the walls of Itchan Kala.',
      amenities: ['Wi-Fi', 'Terrace'],
      colorValue: 0xFF8E4585,
    ),
    Hotel(
      id: 'h5',
      name: 'Chorvoq Lake Resort',
      city: 'Tashkent',
      pricePerNight: 150,
      rating: 4.8,
      description: 'Lakeside resort with spa and mountain views.',
      amenities: ['Wi-Fi', 'Spa', 'Pool', 'Parking'],
      colorValue: 0xFF00838F,
    ),
  ];

  final List<Booking> _bookings = [];
  int _counter = 0;

  @override
  Future<List<Hotel>> getHotels({String query = ''}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _hotels;
    return _hotels
        .where((h) =>
            h.name.toLowerCase().contains(q) || h.city.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<List<Booking>> getBookings() async => List.unmodifiable(_bookings);

  @override
  Future<Booking> book({
    required Hotel hotel,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final booking = Booking(
      id: 'b${++_counter}',
      hotel: hotel,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
    );
    _bookings.add(booking);
    return booking;
  }

  @override
  Future<void> cancel(String bookingId) async {
    _bookings.removeWhere((b) => b.id == bookingId);
  }
}

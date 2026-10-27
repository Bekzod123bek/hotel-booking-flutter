import '../domain/entities.dart';
import '../domain/hotel_repository.dart';
import 'sample_hotels.dart';

/// Hotels come from [sampleHotels]; no backend is used.
class MockHotelRepository implements HotelRepository {
  MockHotelRepository({this.delay = const Duration(milliseconds: 900)});

  final Duration delay;

  @override
  Future<List<Hotel>> getHotels() async {
    await Future<void>.delayed(delay);
    return sampleHotels;
  }
}

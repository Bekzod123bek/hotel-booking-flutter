import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities.dart';
import '../../domain/hotel_repository.dart';
import '../sample_hotels.dart';
import 'hotel_dto.dart';

/// Hotels stored in the `hotels` collection. While the collection is empty the
/// bundled [sampleHotels] are shown, so a fresh Firebase project works at once.
class FirestoreHotelRepository implements HotelRepository {
  FirestoreHotelRepository(this._db);

  final FirebaseFirestore _db;

  @override
  Future<List<Hotel>> getHotels() async {
    final snapshot = await _db.collection('hotels').get();
    if (snapshot.docs.isEmpty) return sampleHotels;
    return [for (final d in snapshot.docs) hotelFromMap(d.id, d.data())]
      ..sort((a, b) => a.id.compareTo(b.id));
  }
}

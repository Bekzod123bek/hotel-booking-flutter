import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities.dart';
import '../../domain/hotel_repository.dart';
import '../local_user_data_repository.dart' show bookingFromRequest;

/// Favorites in `users/{uid}.favorites`.
class FirestoreFavoritesRepository implements FavoritesRepository {
  FirestoreFavoritesRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>>? get _doc {
    final uid = _auth.currentUser?.uid;
    return uid == null ? null : _db.collection('users').doc(uid);
  }

  @override
  Future<Set<String>> getFavoriteIds() async {
    final doc = _doc;
    if (doc == null) return const {};
    final data = (await doc.get()).data();
    return {...List<String>.from(data?['favorites'] as List? ?? const [])};
  }

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async {
    await _doc?.set({'favorites': ids.toList()}, SetOptions(merge: true));
  }
}

/// Bookings in `users/{uid}/bookings/{id}`.
///
/// Availability is tracked per night in `occupancy/{hotel}_{room}_{yyyyMMdd}`
/// (`booked` = rooms taken). Reserving and releasing happen in a transaction,
/// so two guests cannot take the last room at the same time.
class FirestoreBookingRepository implements BookingRepository {
  FirestoreBookingRepository(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>>? get _bookings {
    final uid = _auth.currentUser?.uid;
    return uid == null
        ? null
        : _db.collection('users').doc(uid).collection('bookings');
  }

  DocumentReference<Map<String, dynamic>> _night(
    String hotelId,
    String roomId,
    DateTime night,
  ) {
    final day = '${night.year}'
        '${night.month.toString().padLeft(2, '0')}'
        '${night.day.toString().padLeft(2, '0')}';
    return _db.collection('occupancy').doc('${hotelId}_${roomId}_$day');
  }

  @override
  Future<List<Booking>> getBookings() async {
    final col = _bookings;
    if (col == null) return const [];
    final snapshot = await col.get();
    return [for (final d in snapshot.docs) Booking.fromJson(d.data())];
  }

  @override
  Future<Booking> create(BookingRequest request, {required DateTime now}) async {
    final col = _bookings;
    if (col == null) throw const BookingFailure(BookingFailureReason.unknown);

    final mine = await col.where('hotelId', isEqualTo: request.hotel.id).get();
    final clash = mine.docs
        .map((d) => Booking.fromJson(d.data()))
        .any((b) => b.overlaps(request.checkIn, request.checkOut));
    if (clash) throw const BookingFailure(BookingFailureReason.alreadyBooked);

    final bookingRef = col.doc();
    final booking = bookingFromRequest(request, id: bookingRef.id, now: now);
    final nights = [
      for (final n in request.nights)
        _night(request.hotel.id, request.room.id, n),
    ];

    await _db.runTransaction((tx) async {
      final taken = <int>[];
      for (final ref in nights) {
        final data = (await tx.get(ref)).data();
        taken.add((data?['booked'] as num?)?.toInt() ?? 0);
      }
      if (taken.any((n) => n >= request.hotel.roomsPerType)) {
        throw const BookingFailure(BookingFailureReason.notAvailable);
      }
      for (var i = 0; i < nights.length; i++) {
        tx.set(nights[i], {'booked': taken[i] + 1});
      }
      tx.set(bookingRef, booking.toJson());
    });
    return booking;
  }

  @override
  Future<void> cancel(Booking booking) async {
    final col = _bookings;
    if (col == null) return;
    final nights = [
      for (final n in booking.nightDates)
        _night(booking.hotelId, RoomType.byKey(booking.roomName).id, n),
    ];
    await _db.runTransaction((tx) async {
      final taken = <int>[];
      for (final ref in nights) {
        final data = (await tx.get(ref)).data();
        taken.add((data?['booked'] as num?)?.toInt() ?? 0);
      }
      for (var i = 0; i < nights.length; i++) {
        tx.set(nights[i], {'booked': taken[i] > 0 ? taken[i] - 1 : 0});
      }
      tx.delete(col.doc(booking.id));
    });
  }
}

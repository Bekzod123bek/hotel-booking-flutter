import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/features/auth/data/firebase_auth_repository.dart';
import 'package:hotel_booking/features/auth/domain/auth_repository.dart';
import 'package:hotel_booking/features/hotels/data/firebase/hotel_dto.dart';
import 'package:hotel_booking/features/hotels/data/sample_hotels.dart';
import 'package:hotel_booking/features/hotels/domain/entities.dart';

void main() {
  test('every sample hotel survives a trip through Firestore data', () {
    for (final hotel in sampleHotels) {
      final back = hotelFromMap(hotel.id, hotelToMap(hotel));
      expect(back, hotel);
      expect(back.name, hotel.name);
      expect(back.latitude, hotel.latitude);
      expect(back.amenities, hotel.amenities);
      expect(back.images, hotel.images);
      expect(back.featured, hotel.featured);
      expect(back.reviews, hotel.reviews);
    }
  });

  test('every hotel has a position inside Uzbekistan', () {
    for (final h in sampleHotels) {
      expect(h.latitude, inInclusiveRange(37, 46), reason: h.name);
      expect(h.longitude, inInclusiveRange(55, 74), reason: h.name);
    }
  });

  test('Firebase error codes map to translatable reasons', () {
    expect(mapAuthCode('invalid-credential'), AuthError.invalidCredentials);
    expect(mapAuthCode('wrong-password'), AuthError.invalidCredentials);
    expect(mapAuthCode('email-already-in-use'), AuthError.emailInUse);
    expect(mapAuthCode('weak-password'), AuthError.weakPassword);
    expect(mapAuthCode('network-request-failed'), AuthError.network);
    expect(mapAuthCode('too-many-requests'), AuthError.tooManyRequests);
    expect(mapAuthCode('something-new'), AuthError.unknown);
  });

  test('nights are counted by calendar day', () {
    final nights = nightsBetween(DateTime(2030, 3, 30), DateTime(2030, 4, 2));
    expect(nights, [
      DateTime(2030, 3, 30),
      DateTime(2030, 3, 31),
      DateTime(2030, 4, 1),
    ]);
    expect(nightsBetween(DateTime(2030, 1, 1), DateTime(2030, 1, 1)), isEmpty);
  });
}

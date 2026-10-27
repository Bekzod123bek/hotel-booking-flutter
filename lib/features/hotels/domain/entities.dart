import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// A point on the map.
class GeoPoint extends Equatable {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  /// Great-circle distance to [other] in kilometres (haversine formula).
  double distanceKmTo(GeoPoint other) {
    const earthRadiusKm = 6371.0;
    double rad(double deg) => deg * math.pi / 180;
    final dLat = rad(other.latitude - latitude);
    final dLng = rad(other.longitude - longitude);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(latitude)) *
            math.cos(rad(other.latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * earthRadiusKm * math.asin(math.min(1, math.sqrt(a)));
  }

  @override
  List<Object?> get props => [latitude, longitude];
}

class Review extends Equatable {
  const Review({
    required this.author,
    required this.rating,
    required this.text,
    required this.date,
  });

  final String author;
  final double rating;
  final String text;
  final DateTime date;

  @override
  List<Object?> get props => [author, rating, text, date];
}

class RoomType extends Equatable {
  const RoomType({
    required this.id,
    required this.name,
    required this.description,
    required this.priceFactor,
    required this.maxGuests,
  });

  /// Stable key, used for translations and stored in bookings.
  final String id;
  final String name;
  final String description;

  /// Multiplier applied to the hotel base price per night.
  final double priceFactor;
  final int maxGuests;

  static const all = [
    RoomType(
      id: 'standard',
      name: 'Standard',
      description: 'Queen bed, city view',
      priceFactor: 1,
      maxGuests: 2,
    ),
    RoomType(
      id: 'deluxe',
      name: 'Deluxe',
      description: 'King bed, balcony, breakfast',
      priceFactor: 1.4,
      maxGuests: 3,
    ),
    RoomType(
      id: 'suite',
      name: 'Suite',
      description: 'Separate living room, best view',
      priceFactor: 2,
      maxGuests: 4,
    ),
  ];

  /// Finds a room type by [id] or by its English name (older saved bookings
  /// stored the name).
  static RoomType byKey(String key) {
    final k = key.toLowerCase();
    return all.firstWhere(
      (r) => r.id == k || r.name.toLowerCase() == k,
      orElse: () => all.first,
    );
  }

  @override
  List<Object?> get props => [id];
}

class Hotel extends Equatable {
  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.amenities,
    required this.images,
    required this.reviews,
    this.featured = false,
    this.roomsPerType = defaultRoomsPerType,
  });

  /// How many rooms of each type a hotel has unless it says otherwise.
  static const defaultRoomsPerType = 3;

  /// Longest stay that can be booked in one go.
  static const maxNights = 30;

  final String id;
  final String name;
  final String city;
  final String address;

  /// Approximate position; the hotels are fictional.
  final double latitude;
  final double longitude;
  final int pricePerNight;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> amenities;
  final List<String> images;
  final List<Review> reviews;
  final bool featured;

  /// Rooms of each [RoomType]; a night is sold out when all are booked.
  final int roomsPerType;

  String get cover => images.first;

  GeoPoint get position => GeoPoint(latitude, longitude);

  int priceFor(RoomType room) => (pricePerNight * room.priceFactor).round();

  @override
  List<Object?> get props => [id];
}

enum HotelSort { recommended, nearest, priceLow, priceHigh, rating }

class HotelFilter extends Equatable {
  const HotelFilter({
    this.query = '',
    this.city,
    this.minPrice = 0,
    this.maxPrice = maxPriceLimit,
    this.minRating = 0,
    this.amenities = const {},
    this.sort = HotelSort.recommended,
    this.origin,
  });

  static const maxPriceLimit = 300;

  final String query;
  final String? city;
  final int minPrice;
  final int maxPrice;
  final double minRating;
  final Set<String> amenities;
  final HotelSort sort;

  /// Where the user is. Needed for [HotelSort.nearest].
  final GeoPoint? origin;

  /// Number of filters set in the filter sheet (search and city excluded).
  int get activeCount => [
    minPrice > 0 || maxPrice < maxPriceLimit,
    minRating > 0,
    amenities.isNotEmpty,
    sort != HotelSort.recommended,
  ].where((e) => e).length;

  bool get isDefault =>
      query.trim().isEmpty && city == null && activeCount == 0;

  List<Hotel> apply(List<Hotel> hotels) {
    final q = query.trim().toLowerCase();
    final result = hotels.where((h) {
      if (q.isNotEmpty &&
          !h.name.toLowerCase().contains(q) &&
          !h.city.toLowerCase().contains(q)) {
        return false;
      }
      if (city != null && h.city != city) return false;
      if (h.pricePerNight < minPrice || h.pricePerNight > maxPrice) {
        return false;
      }
      if (h.rating < minRating) return false;
      if (!amenities.every(h.amenities.contains)) return false;
      return true;
    }).toList();

    switch (sort) {
      case HotelSort.recommended:
        break;
      case HotelSort.nearest:
        final from = origin;
        if (from != null) {
          result.sort((a, b) => from
              .distanceKmTo(a.position)
              .compareTo(from.distanceKmTo(b.position)));
        }
      case HotelSort.priceLow:
        result.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
      case HotelSort.priceHigh:
        result.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
      case HotelSort.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return result;
  }

  HotelFilter copyWith({
    String? query,
    String? Function()? city,
    int? minPrice,
    int? maxPrice,
    double? minRating,
    Set<String>? amenities,
    HotelSort? sort,
    GeoPoint? origin,
  }) => HotelFilter(
    query: query ?? this.query,
    city: city != null ? city() : this.city,
    minPrice: minPrice ?? this.minPrice,
    maxPrice: maxPrice ?? this.maxPrice,
    minRating: minRating ?? this.minRating,
    amenities: amenities ?? this.amenities,
    sort: sort ?? this.sort,
    origin: origin ?? this.origin,
  );

  @override
  List<Object?> get props => [
    origin,
    query,
    city,
    minPrice,
    maxPrice,
    minRating,
    amenities,
    sort,
  ];
}

enum PaymentMethod { atHotel, online }

/// Everything the user chooses on the booking page.
class BookingRequest extends Equatable {
  const BookingRequest({
    required this.hotel,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.guestName,
    required this.guestPhone,
    required this.payment,
  });

  final Hotel hotel;
  final RoomType room;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final String guestName;
  final String guestPhone;
  final PaymentMethod payment;

  /// Each night from [checkIn] up to, but not including, [checkOut].
  List<DateTime> get nights => nightsBetween(checkIn, checkOut);

  @override
  List<Object?> get props => [
    hotel,
    room,
    checkIn,
    checkOut,
    guests,
    guestName,
    guestPhone,
    payment,
  ];
}

enum BookingFailureReason { notAvailable, alreadyBooked, unknown }

/// Thrown when a booking cannot be made.
class BookingFailure implements Exception {
  const BookingFailure(this.reason);

  final BookingFailureReason reason;

  @override
  String toString() => 'BookingFailure($reason)';
}

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.code,
    required this.hotelId,
    required this.hotelName,
    required this.city,
    required this.image,
    required this.roomName,
    required this.pricePerNight,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.createdAt,
    this.guestName = '',
    this.guestPhone = '',
    this.payment = PaymentMethod.atHotel,
  });

  /// Share of the room price added as a service fee.
  static const serviceFeeRate = 0.1;

  final String id;

  /// Short code the guest can quote at the hotel, for example `HB-7K2F9Q`.
  final String code;
  final String hotelId;
  final String hotelName;
  final String city;
  final String image;

  /// Id of the [RoomType] (older bookings hold the English name).
  final String roomName;
  final int pricePerNight;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final DateTime createdAt;
  final String guestName;
  final String guestPhone;
  final PaymentMethod payment;

  int get nights => nightDates.length;

  /// The dates of the nights spent at the hotel.
  List<DateTime> get nightDates => nightsBetween(checkIn, checkOut);
  int get roomTotal => nights * pricePerNight;
  int get serviceFee => (roomTotal * serviceFeeRate).round();
  int get total => roomTotal + serviceFee;

  Map<String, Object> toJson() => {
    'id': id,
    'code': code,
    'hotelId': hotelId,
    'hotelName': hotelName,
    'city': city,
    'image': image,
    'roomName': roomName,
    'pricePerNight': pricePerNight,
    'checkIn': checkIn.toIso8601String(),
    'checkOut': checkOut.toIso8601String(),
    'guests': guests,
    'createdAt': createdAt.toIso8601String(),
    'guestName': guestName,
    'guestPhone': guestPhone,
    'payment': payment.name,
  };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    code: json['code'] as String? ?? bookingCodeFor(json['id'] as String),
    hotelId: json['hotelId'] as String,
    hotelName: json['hotelName'] as String,
    city: json['city'] as String,
    image: json['image'] as String,
    roomName: json['roomName'] as String,
    pricePerNight: json['pricePerNight'] as int,
    checkIn: DateTime.parse(json['checkIn'] as String),
    checkOut: DateTime.parse(json['checkOut'] as String),
    guests: json['guests'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    guestName: json['guestName'] as String? ?? '',
    guestPhone: json['guestPhone'] as String? ?? '',
    payment: PaymentMethod.values.firstWhere(
      (p) => p.name == json['payment'],
      orElse: () => PaymentMethod.atHotel,
    ),
  );

  /// Whether the stay shares at least one night with [start]–[end].
  bool overlaps(DateTime start, DateTime end) =>
      checkIn.isBefore(end) && start.isBefore(checkOut);

  @override
  List<Object?> get props => [id];
}

/// Every date from [checkIn] up to, but not including, [checkOut].
List<DateTime> nightsBetween(DateTime checkIn, DateTime checkOut) {
  final nights = <DateTime>[];
  var day = DateTime(checkIn.year, checkIn.month, checkIn.day);
  final end = DateTime(checkOut.year, checkOut.month, checkOut.day);
  while (day.isBefore(end)) {
    nights.add(day);
    day = DateTime(day.year, day.month, day.day + 1);
  }
  return nights;
}

const _codeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

/// Builds a readable booking code such as `HB-7K2F9Q` from [seed].
String bookingCodeFor(String seed) {
  var h = 17;
  for (final c in seed.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  final out = StringBuffer('HB-');
  for (var i = 0; i < 6; i++) {
    out.write(_codeAlphabet[h % _codeAlphabet.length]);
    h = (h ~/ _codeAlphabet.length) + (i + 1) * 7919;
  }
  return out.toString();
}

import 'package:equatable/equatable.dart';

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
    required this.name,
    required this.description,
    required this.priceFactor,
    required this.maxGuests,
  });

  final String name;
  final String description;

  /// Multiplier applied to the hotel base price per night.
  final double priceFactor;
  final int maxGuests;

  static const all = [
    RoomType(
      name: 'Standard',
      description: 'Queen bed, city view',
      priceFactor: 1,
      maxGuests: 2,
    ),
    RoomType(
      name: 'Deluxe',
      description: 'King bed, balcony, breakfast',
      priceFactor: 1.4,
      maxGuests: 3,
    ),
    RoomType(
      name: 'Suite',
      description: 'Separate living room, best view',
      priceFactor: 2,
      maxGuests: 4,
    ),
  ];

  @override
  List<Object?> get props => [name];
}

class Hotel extends Equatable {
  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.amenities,
    required this.images,
    required this.reviews,
    this.featured = false,
  });

  final String id;
  final String name;
  final String city;
  final String address;
  final int pricePerNight;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> amenities;
  final List<String> images;
  final List<Review> reviews;
  final bool featured;

  String get cover => images.first;

  int priceFor(RoomType room) => (pricePerNight * room.priceFactor).round();

  @override
  List<Object?> get props => [id];
}

enum HotelSort { recommended, priceLow, priceHigh, rating }

extension HotelSortLabel on HotelSort {
  String get label => switch (this) {
        HotelSort.recommended => 'Recommended',
        HotelSort.priceLow => 'Price: low to high',
        HotelSort.priceHigh => 'Price: high to low',
        HotelSort.rating => 'Top rated',
      };
}

class HotelFilter extends Equatable {
  const HotelFilter({
    this.query = '',
    this.city,
    this.minPrice = 0,
    this.maxPrice = maxPriceLimit,
    this.minRating = 0,
    this.amenities = const {},
    this.sort = HotelSort.recommended,
  });

  static const maxPriceLimit = 300;

  final String query;
  final String? city;
  final int minPrice;
  final int maxPrice;
  final double minRating;
  final Set<String> amenities;
  final HotelSort sort;

  /// Number of filters set in the filter sheet (search and city excluded).
  int get activeCount => [
        minPrice > 0 || maxPrice < maxPriceLimit,
        minRating > 0,
        amenities.isNotEmpty,
        sort != HotelSort.recommended,
      ].where((e) => e).length;

  bool get isDefault => query.trim().isEmpty && city == null && activeCount == 0;

  List<Hotel> apply(List<Hotel> hotels) {
    final q = query.trim().toLowerCase();
    final result = hotels.where((h) {
      if (q.isNotEmpty &&
          !h.name.toLowerCase().contains(q) &&
          !h.city.toLowerCase().contains(q)) {
        return false;
      }
      if (city != null && h.city != city) return false;
      if (h.pricePerNight < minPrice || h.pricePerNight > maxPrice) return false;
      if (h.rating < minRating) return false;
      if (!amenities.every(h.amenities.contains)) return false;
      return true;
    }).toList();

    switch (sort) {
      case HotelSort.recommended:
        break;
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
  }) =>
      HotelFilter(
        query: query ?? this.query,
        city: city != null ? city() : this.city,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        minRating: minRating ?? this.minRating,
        amenities: amenities ?? this.amenities,
        sort: sort ?? this.sort,
      );

  @override
  List<Object?> get props =>
      [query, city, minPrice, maxPrice, minRating, amenities, sort];
}

class Booking extends Equatable {
  const Booking({
    required this.id,
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
  });

  /// Share of the room price added as a service fee.
  static const serviceFeeRate = 0.1;

  final String id;
  final String hotelId;
  final String hotelName;
  final String city;
  final String image;
  final String roomName;
  final int pricePerNight;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final DateTime createdAt;

  int get nights => checkOut.difference(checkIn).inDays;
  int get roomTotal => nights * pricePerNight;
  int get serviceFee => (roomTotal * serviceFeeRate).round();
  int get total => roomTotal + serviceFee;

  Map<String, Object> toJson() => {
        'id': id,
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
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
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
      );

  @override
  List<Object?> get props => [id];
}

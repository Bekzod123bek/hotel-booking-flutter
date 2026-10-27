import '../../domain/entities.dart';

/// Converts a [Hotel] to and from a Firestore document.
Map<String, Object?> hotelToMap(Hotel h) => {
      'name': h.name,
      'city': h.city,
      'address': h.address,
      'latitude': h.latitude,
      'longitude': h.longitude,
      'pricePerNight': h.pricePerNight,
      'rating': h.rating,
      'reviewCount': h.reviewCount,
      'description': h.description,
      'amenities': h.amenities,
      'images': h.images,
      'featured': h.featured,
      'roomsPerType': h.roomsPerType,
      'reviews': [
        for (final r in h.reviews)
          {
            'author': r.author,
            'rating': r.rating,
            'text': r.text,
            'date': r.date.toIso8601String(),
          },
      ],
    };

Hotel hotelFromMap(String id, Map<String, dynamic> m) => Hotel(
      id: id,
      name: m['name'] as String,
      city: m['city'] as String,
      address: m['address'] as String,
      latitude: (m['latitude'] as num).toDouble(),
      longitude: (m['longitude'] as num).toDouble(),
      pricePerNight: (m['pricePerNight'] as num).toInt(),
      rating: (m['rating'] as num).toDouble(),
      reviewCount: (m['reviewCount'] as num).toInt(),
      description: m['description'] as String,
      amenities: List<String>.from(m['amenities'] as List),
      images: List<String>.from(m['images'] as List),
      featured: m['featured'] as bool? ?? false,
      roomsPerType:
          (m['roomsPerType'] as num?)?.toInt() ?? Hotel.defaultRoomsPerType,
      reviews: [
        for (final r in (m['reviews'] as List? ?? const []))
          Review(
            author: (r as Map)['author'] as String,
            rating: (r['rating'] as num).toDouble(),
            text: r['text'] as String,
            date: DateTime.parse(r['date'] as String),
          ),
      ],
    );

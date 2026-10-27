import '../domain/entities.dart';

/// Sample data for the demo. Hotel names are fictional and the photos are
/// illustrative Unsplash images, not pictures of these exact places.
String _photo(String id) => 'https://images.unsplash.com/photo-$id?w=900&q=80';

List<Review> _reviews(List<(String, double, String)> items) => [
      for (final (i, item) in items.indexed)
        Review(
          author: item.$1,
          rating: item.$2,
          text: item.$3,
          date: DateTime(2026, 9, 28 - i * 9),
        ),
    ];

final sampleHotels = <Hotel>[
  Hotel(
    id: 'h1',
    name: 'Registan Palace',
    city: 'Samarkand',
    address: 'Registan Street 12, Samarkand',
    latitude: 39.6547,
    longitude: 66.9758,
    pricePerNight: 85,
    rating: 4.7,
    reviewCount: 412,
    featured: true,
    description:
        'Elegant boutique hotel a five-minute walk from Registan Square. '
        'Rooms mix traditional Uzbek details with modern comfort, and the '
        'terrace restaurant looks out over the old city.',
    amenities: ['Wi-Fi', 'Breakfast', 'Parking', 'Restaurant', 'Air conditioning'],
    images: [
      _photo('1625244724120-1fd1d34d00f6'),
      _photo('1559841644-08984562005a'),
      _photo('1582719478250-c89cae4dc85b'),
      _photo('1621293954908-907159247fc8'),
    ],
    reviews: _reviews([
      ('Dilnoza R.', 5, 'Amazing location and very friendly staff. Breakfast on the terrace was the highlight.'),
      ('Mark T.', 4.5, 'Beautiful lobby and comfortable rooms. A bit noisy in the evening.'),
      ('Aziz K.', 4.5, 'Great value for Samarkand. Would stay again.'),
    ]),
  ),
  Hotel(
    id: 'h2',
    name: 'Tashkent City View',
    city: 'Tashkent',
    address: 'Navoi Avenue 45, Tashkent',
    latitude: 41.3111,
    longitude: 69.2797,
    pricePerNight: 120,
    rating: 4.5,
    reviewCount: 638,
    featured: true,
    description:
        'Modern high-rise hotel in the business district with a rooftop pool, '
        'a fitness centre and views over Tashkent City Park.',
    amenities: ['Wi-Fi', 'Pool', 'Gym', 'Breakfast', 'Air conditioning'],
    images: [
      _photo('1517840901100-8179e982acb7'),
      _photo('1575429198097-0414ec08e8cd'),
      _photo('1576675784201-0e142b423952'),
      _photo('1595576508898-0ad5c879a061'),
    ],
    reviews: _reviews([
      ('Sardor M.', 4.5, 'The rooftop pool at sunset is fantastic.'),
      ('Anna L.', 4, 'Clean, modern and close to the metro.'),
      ('Javohir N.', 5, 'Perfect for a business trip, fast Wi-Fi.'),
    ]),
  ),
  Hotel(
    id: 'h3',
    name: 'Silk Road Inn',
    city: 'Bukhara',
    address: 'Lyabi-Hauz 3, Bukhara',
    latitude: 39.7746,
    longitude: 64.4222,
    pricePerNight: 60,
    rating: 4.3,
    reviewCount: 254,
    description:
        'Cosy guesthouse around a green courtyard in the heart of the old '
        'town. Hand-carved wooden ceilings and a home-made breakfast.',
    amenities: ['Wi-Fi', 'Breakfast', 'Air conditioning'],
    images: [
      _photo('1535827841776-24afc1e255ac'),
      _photo('1584132905271-512c958d674a'),
      _photo('1596306499317-8490232098fa'),
    ],
    reviews: _reviews([
      ('Laura P.', 4.5, 'Charming courtyard, felt like staying with family.'),
      ('Bekzod A.', 4, 'Simple rooms, but the location is unbeatable.'),
    ]),
  ),
  Hotel(
    id: 'h4',
    name: 'Khiva Fortress Lodge',
    city: 'Khiva',
    address: 'Itchan Kala, Khiva',
    latitude: 41.3783,
    longitude: 60.3589,
    pricePerNight: 55,
    rating: 4.4,
    reviewCount: 187,
    description:
        'Quiet lodge next to the walls of Itchan Kala. Evening lights over the '
        'minarets are visible right from the terrace.',
    amenities: ['Wi-Fi', 'Parking', 'Restaurant'],
    images: [
      _photo('1606402179428-a57976d71fa4'),
      _photo('1455587734955-081b22074882'),
      _photo('1559508551-44bff1de756b'),
    ],
    reviews: _reviews([
      ('Rustam Y.', 4.5, 'Peaceful place, perfect after a day of walking.'),
      ('Emma S.', 4, 'Lovely terrace, rooms are small but clean.'),
    ]),
  ),
  Hotel(
    id: 'h5',
    name: 'Chorvoq Lake Resort',
    city: 'Tashkent region',
    address: 'Chorvoq reservoir, Bostanliq district',
    latitude: 41.62,
    longitude: 69.97,
    pricePerNight: 150,
    rating: 4.8,
    reviewCount: 521,
    featured: true,
    description:
        'Lakeside resort in the mountains, an hour and a half from Tashkent. '
        'Infinity pool, private villas and a spa for a weekend escape.',
    amenities: ['Wi-Fi', 'Pool', 'Spa', 'Parking', 'Restaurant', 'Breakfast'],
    images: [
      _photo('1551918120-9739cb430c6d'),
      _photo('1580041065738-e72023775cdc'),
      _photo('1560448204-e02f11c3d0e2'),
      _photo('1529290130-4ca3753253ae'),
    ],
    reviews: _reviews([
      ('Madina U.', 5, 'The infinity pool with the mountain view is unreal.'),
      ('Oliver K.', 5, 'Best weekend trip from Tashkent.'),
      ('Shahzod T.', 4.5, 'Great spa, a bit pricey but worth it.'),
    ]),
  ),
  Hotel(
    id: 'h6',
    name: 'Zaamin Mountain Retreat',
    city: 'Jizzakh',
    address: 'Zaamin National Park, Jizzakh region',
    latitude: 39.93,
    longitude: 68.4,
    pricePerNight: 95,
    rating: 4.6,
    reviewCount: 143,
    description:
        'Modern villas among juniper forests in Zaamin. Fresh mountain air, '
        'hiking trails and a fireplace lounge.',
    amenities: ['Wi-Fi', 'Parking', 'Breakfast', 'Spa'],
    images: [
      _photo('1600585154340-be6161a56a0c'),
      _photo('1586105251261-72a756497a11'),
      _photo('1584132915807-fd1f5fbc078f'),
    ],
    reviews: _reviews([
      ('Nodira S.', 5, 'So quiet and green, we did not want to leave.'),
      ('Timur B.', 4, 'Road is long, but the place is worth it.'),
    ]),
  ),
  Hotel(
    id: 'h7',
    name: 'Fergana Garden Hotel',
    city: 'Fergana',
    address: 'Al-Fargoniy Street 8, Fergana',
    latitude: 40.3842,
    longitude: 71.7843,
    pricePerNight: 70,
    rating: 4.2,
    reviewCount: 98,
    description:
        'Family hotel with a large garden and an outdoor pool, close to the '
        'central park and the bazaar.',
    amenities: ['Wi-Fi', 'Pool', 'Breakfast', 'Parking', 'Air conditioning'],
    images: [
      _photo('1570213489059-0aac6626cade'),
      _photo('1445019980597-93fa8acb246c'),
      _photo('1594560913095-8cf34bab82ad'),
    ],
    reviews: _reviews([
      ('Gulnora H.', 4, 'Kids loved the pool, breakfast was rich.'),
      ('Ali R.', 4.5, 'Quiet garden, friendly owners.'),
    ]),
  ),
  Hotel(
    id: 'h8',
    name: 'Termez Sun Resort',
    city: 'Termez',
    address: 'Amu Darya embankment, Termez',
    latitude: 37.2242,
    longitude: 67.2783,
    pricePerNight: 110,
    rating: 4.5,
    reviewCount: 76,
    featured: true,
    description:
        'Sunny resort by the Amu Darya with palm-lined pools, sunset views and '
        'spacious rooms with balconies.',
    amenities: ['Wi-Fi', 'Pool', 'Gym', 'Restaurant', 'Air conditioning'],
    images: [
      _photo('1600011689032-8b628b8a8747'),
      _photo('1512918728675-ed5a9ecdebfd'),
      _photo('1618773928121-c32242e63f39'),
      _photo('1610641818989-c2051b5e2cfd'),
    ],
    reviews: _reviews([
      ('Firuza O.', 4.5, 'Sunsets by the pool are beautiful.'),
      ('Daniel W.', 4.5, 'Spacious room with a big balcony.'),
    ]),
  ),
];

/// All amenities that appear in [sampleHotels], used by the filter sheet.
const allAmenities = [
  'Wi-Fi',
  'Breakfast',
  'Pool',
  'Spa',
  'Gym',
  'Parking',
  'Restaurant',
  'Air conditioning',
];

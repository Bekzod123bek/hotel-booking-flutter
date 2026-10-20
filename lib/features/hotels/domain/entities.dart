import 'package:equatable/equatable.dart';

class Hotel extends Equatable {
  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.pricePerNight,
    required this.rating,
    required this.description,
    required this.amenities,
    required this.colorValue,
  });

  final String id;
  final String name;
  final String city;
  final int pricePerNight;
  final double rating;
  final String description;
  final List<String> amenities;
  final int colorValue;

  @override
  List<Object?> get props => [id];
}

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  final String id;
  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  int get nights => checkOut.difference(checkIn).inDays;
  int get total => nights * hotel.pricePerNight;

  @override
  List<Object?> get props => [id];
}

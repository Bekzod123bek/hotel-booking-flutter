import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/hotel_repository.dart';

class HotelsState extends Equatable {
  const HotelsState({this.hotels = const [], this.loading = true});

  final List<Hotel> hotels;
  final bool loading;

  @override
  List<Object?> get props => [hotels, loading];
}

class HotelsCubit extends Cubit<HotelsState> {
  HotelsCubit(this._repository) : super(const HotelsState());

  final HotelRepository _repository;

  Future<void> load({String query = ''}) async {
    emit(HotelsState(hotels: state.hotels, loading: true));
    final hotels = await _repository.getHotels(query: query);
    emit(HotelsState(hotels: hotels, loading: false));
  }
}

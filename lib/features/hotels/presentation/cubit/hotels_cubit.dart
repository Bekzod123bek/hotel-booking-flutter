import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/hotel_repository.dart';

class HotelsState extends Equatable {
  const HotelsState({
    this.all = const [],
    this.filter = const HotelFilter(),
    this.loading = true,
  });

  final List<Hotel> all;
  final HotelFilter filter;
  final bool loading;

  List<Hotel> get results => filter.apply(all);
  List<Hotel> get featured => all.where((h) => h.featured).toList();

  List<String> get cities => {for (final h in all) h.city}.toList();

  Hotel? byId(String id) {
    for (final h in all) {
      if (h.id == id) return h;
    }
    return null;
  }

  HotelsState copyWith({
    List<Hotel>? all,
    HotelFilter? filter,
    bool? loading,
  }) =>
      HotelsState(
        all: all ?? this.all,
        filter: filter ?? this.filter,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [all, filter, loading];
}

class HotelsCubit extends Cubit<HotelsState> {
  HotelsCubit(this._repository) : super(const HotelsState());

  final HotelRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final hotels = await _repository.getHotels();
    emit(state.copyWith(all: hotels, loading: false));
  }

  void search(String query) =>
      emit(state.copyWith(filter: state.filter.copyWith(query: query)));

  void selectCity(String? city) =>
      emit(state.copyWith(filter: state.filter.copyWith(city: () => city)));

  void setSort(HotelSort sort) =>
      emit(state.copyWith(filter: state.filter.copyWith(sort: sort)));

  void applyFilter(HotelFilter filter) => emit(state.copyWith(filter: filter));

  void resetFilters() => emit(state.copyWith(
        filter: HotelFilter(query: state.filter.query, city: state.filter.city),
      ));
}

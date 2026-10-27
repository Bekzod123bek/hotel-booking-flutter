import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/hotel_repository.dart';

class HotelsState extends Equatable {
  const HotelsState({
    this.all = const [],
    this.filter = const HotelFilter(),
    this.loading = true,
    this.failed = false,
    this.locating = false,
    this.locationIssue,
  });

  final List<Hotel> all;
  final HotelFilter filter;
  final bool loading;

  /// Whether the last attempt to load the hotels failed.
  final bool failed;

  /// Whether we are waiting for the phone's position.
  final bool locating;

  /// Why the position could not be read; `null` when there is no problem.
  final LocationIssue? locationIssue;

  /// Where the user is, once known.
  GeoPoint? get origin => filter.origin;

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
    bool? failed,
    bool? locating,
    LocationIssue? Function()? locationIssue,
  }) =>
      HotelsState(
        all: all ?? this.all,
        filter: filter ?? this.filter,
        loading: loading ?? this.loading,
        failed: failed ?? this.failed,
        locating: locating ?? this.locating,
        locationIssue:
            locationIssue != null ? locationIssue() : this.locationIssue,
      );

  @override
  List<Object?> get props =>
      [all, filter, loading, failed, locating, locationIssue];
}

class HotelsCubit extends Cubit<HotelsState> {
  HotelsCubit(this._repository, this._location) : super(const HotelsState());

  final HotelRepository _repository;
  final LocationService _location;

  Future<void> load() async {
    emit(state.copyWith(loading: true, failed: false));
    try {
      final hotels = await _repository.getHotels();
      emit(state.copyWith(all: hotels, loading: false));
    } catch (_) {
      emit(state.copyWith(loading: false, failed: true));
    }
  }

  /// Reads the user's position and sorts the hotels from the nearest.
  Future<void> findNearby() async {
    emit(state.copyWith(locating: true, locationIssue: () => null));
    final result = await _location.currentPosition();
    final position = result.position;
    if (position == null) {
      emit(state.copyWith(locating: false, locationIssue: () => result.issue));
      return;
    }
    emit(state.copyWith(
      locating: false,
      filter: state.filter.copyWith(origin: position, sort: HotelSort.nearest),
    ));
  }

  Future<void> openLocationSettings() => _location.openSettings();

  void dismissLocationIssue() =>
      emit(state.copyWith(locationIssue: () => null));

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

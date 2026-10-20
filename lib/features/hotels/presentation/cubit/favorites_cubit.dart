import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/hotel_repository.dart';

/// Ids of the hotels the user marked as favorite.
class FavoritesCubit extends Cubit<Set<String>> {
  FavoritesCubit(this._repository) : super(const {});

  final HotelRepository _repository;

  Future<void> load() async => emit(await _repository.getFavoriteIds());

  bool isFavorite(String id) => state.contains(id);

  /// Returns `true` when the hotel was added.
  Future<bool> toggle(String id) async {
    final ids = {...state};
    final added = ids.add(id);
    if (!added) ids.remove(id);
    emit(ids);
    await _repository.saveFavoriteIds(ids);
    return added;
  }
}

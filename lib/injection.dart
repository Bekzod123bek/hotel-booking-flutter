import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/theme_cubit.dart';
import 'features/auth/data/local_auth_repository.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/hotels/data/mock_hotel_repository.dart';
import 'features/hotels/domain/hotel_repository.dart';
import 'features/hotels/presentation/cubit/bookings_cubit.dart';
import 'features/hotels/presentation/cubit/favorites_cubit.dart';
import 'features/hotels/presentation/cubit/hotels_cubit.dart';

final sl = GetIt.instance;

/// [fast] removes the artificial loading delays (used in tests).
Future<void> setupDependencies({bool fast = false}) async {
  await sl.reset();
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerSingleton(prefs)
    ..registerLazySingleton<HotelRepository>(
      () => MockHotelRepository(
        sl(),
        delay: fast ? Duration.zero : const Duration(milliseconds: 900),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => LocalAuthRepository(
        sl(),
        delay: fast ? Duration.zero : const Duration(milliseconds: 700),
      ),
    )
    ..registerFactory(() => ThemeCubit(sl()))
    ..registerFactory(() => AuthCubit(sl()))
    ..registerFactory(() => HotelsCubit(sl())..load())
    ..registerFactory(() => FavoritesCubit(sl())..load())
    ..registerFactory(() => BookingsCubit(sl())..load());
}

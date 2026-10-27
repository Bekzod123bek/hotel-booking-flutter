import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/l10n/locale_cubit.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/data/firebase_auth_repository.dart';
import 'features/auth/data/local_auth_repository.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/hotels/data/demo_payment_gateway.dart';
import 'features/hotels/data/firebase/firestore_hotel_repository.dart';
import 'features/hotels/data/geolocator_location_service.dart';
import 'features/hotels/data/firebase/firestore_user_data_repository.dart';
import 'features/hotels/data/local_user_data_repository.dart';
import 'features/hotels/data/mock_hotel_repository.dart';
import 'features/hotels/domain/hotel_repository.dart';
import 'features/hotels/presentation/cubit/bookings_cubit.dart';
import 'features/hotels/presentation/cubit/favorites_cubit.dart';
import 'features/hotels/presentation/cubit/hotels_cubit.dart';

final sl = GetIt.instance;

/// [firebase] stores accounts, favorites and bookings in Firebase; without it
/// everything stays on the device (demo mode). Firebase must be initialized
/// before this is called with `firebase: true`.
///
/// [fast] removes the artificial loading delays (used in tests).
Future<void> setupDependencies({
  bool fast = false,
  bool firebase = false,
}) async {
  await sl.reset();
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton(prefs);
  if (firebase) {
    sl
      ..registerLazySingleton(() => FirebaseAuth.instance)
      ..registerLazySingleton(() => FirebaseFirestore.instance)
      ..registerLazySingleton<HotelRepository>(
        () => FirestoreHotelRepository(sl()),
      )
      ..registerLazySingleton<FavoritesRepository>(
        () => FirestoreFavoritesRepository(sl(), sl()),
      )
      ..registerLazySingleton<BookingRepository>(
        () => FirestoreBookingRepository(sl(), sl()),
      )
      ..registerLazySingleton<AuthRepository>(
        () => FirebaseAuthRepository(sl(), sl(), sl()),
      );
  } else {
    sl
      ..registerLazySingleton<HotelRepository>(
        () => MockHotelRepository(
          delay: fast ? Duration.zero : const Duration(milliseconds: 900),
        ),
      )
      ..registerLazySingleton<FavoritesRepository>(
        () => LocalFavoritesRepository(sl()),
      )
      ..registerLazySingleton<BookingRepository>(
        () => LocalBookingRepository(sl()),
      )
      ..registerLazySingleton<AuthRepository>(
        () => LocalAuthRepository(
          sl(),
          delay: fast ? Duration.zero : const Duration(milliseconds: 700),
        ),
      );
  }
  sl
    ..registerLazySingleton<LocationService>(
      () => const GeolocatorLocationService(),
    )
    ..registerLazySingleton<PaymentGateway>(
      () => DemoPaymentGateway(
        delay: fast ? Duration.zero : const Duration(milliseconds: 1500),
      ),
    )
    ..registerFactory(() => ThemeCubit(sl()))
    ..registerFactory(() => LocaleCubit(sl()))
    ..registerFactory(() => AuthCubit(sl()))
    ..registerFactory(() => HotelsCubit(sl(), sl())..load())
    ..registerFactory(() => FavoritesCubit(sl())..load())
    ..registerFactory(() => BookingsCubit(sl(), sl())..load());
}

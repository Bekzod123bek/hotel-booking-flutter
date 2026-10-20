import 'package:get_it/get_it.dart';

import 'features/hotels/data/mock_hotel_repository.dart';
import 'features/hotels/domain/hotel_repository.dart';
import 'features/hotels/presentation/cubit/bookings_cubit.dart';
import 'features/hotels/presentation/cubit/hotels_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await sl.reset();
  sl
    ..registerLazySingleton<HotelRepository>(MockHotelRepository.new)
    ..registerFactory(() => HotelsCubit(sl())..load())
    ..registerLazySingleton(() => BookingsCubit(sl()));
}

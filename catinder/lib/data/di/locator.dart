import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/storage/cat_storage.dart';
import '../../domain/cubits/liked_cats_cubit.dart';

final getIt = GetIt.instance;

void setupLocator(SharedPreferences prefs) {
  getIt.registerLazySingleton<CatStorage>(() => CatStorage(prefs));
  getIt.registerLazySingleton<LikedCatsCubit>(
    () => LikedCatsCubit(getIt<CatStorage>()),
  );
}

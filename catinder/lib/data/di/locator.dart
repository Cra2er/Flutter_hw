import 'package:get_it/get_it.dart';

import '../../domain/cubits/liked_cats_cubit.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => LikedCatsCubit());
}

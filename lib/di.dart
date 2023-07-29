import 'package:mvvm_cubit/data/api/auth/auth_api.dart';
import 'package:mvvm_cubit/data/api/main/main_api.dart';
import 'package:mvvm_cubit/repository/auth/auth_repository.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  //Dio
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));

  // Register Main Components
  getIt.registerLazySingleton<MainApi>(
      () => MainApi(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<MainRepository>(
    () => MainRepository(mainApi: getIt<MainApi>()),
  );
  getIt.registerFactory(
      () => MainCubit(mainRepository: getIt<MainRepository>()));

  // Register Auth Components
  getIt.registerLazySingleton<AuthApi>(
      () => AuthApi(client: getIt<DioClient>()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(api: getIt<AuthApi>()),
  );
  getIt.registerFactory(() => AuthCubit(repository: getIt<AuthRepository>()));
}

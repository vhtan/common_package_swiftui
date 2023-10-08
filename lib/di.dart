import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvvm_cubit/data/api/add_trip/add_trip.dart';
import 'package:mvvm_cubit/data/api/auth/auth_api.dart';
import 'package:mvvm_cubit/data/api/main/main_api.dart';
import 'package:mvvm_cubit/repository/add_trip/add_trip_repository.dart';
import 'package:mvvm_cubit/repository/auth/auth_repository.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_cubit.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/check_point/check_point_cubit.dart';
import 'package:mvvm_cubit/viewmodel/container/container_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_sos_cubit.dart';

final di = GetIt.instance;

Future<void> init() async {
  //Dio
  di.registerFactory<Dio>(
    () => Dio(),
  );
  di.registerFactory<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  di.registerFactory<DioClient>(
    () => DioClient(
      di(),
    ),
  );

  // Register Main Components
  di.registerLazySingleton<MainApi>(
    () => MainApi(client: di()),
  );
  di.registerLazySingleton<MainRepository>(
    () => MainRepository(api: di()),
  );
  di.registerFactory(
    () => MainCubit(repository: di()),
  );

  // Register Auth Components
  di.registerLazySingleton<AuthApi>(
    () => AuthApi(client: di()),
  );
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepository(api: di()),
  );
  di.registerFactory(
    () => AuthCubit(repository: di()),
  );
  di.registerFactory(
    () => ReportSOSCubit(),
  );
  di.registerFactory(
    () => CheckPointCubit(),
  );

  di.registerFactory(
    () => ContainerCubit(repository: di()),
  );
  di.registerFactory(
    () => AddTripCubit(repository: di()),
  );

// Register Add trip Components
  di.registerLazySingleton<AddTripApi>(
    () => AddTripApi(client: di()),
  );
  di.registerLazySingleton<AddTripRepository>(
    () => AddTripRepository(api: di()),
  );
}

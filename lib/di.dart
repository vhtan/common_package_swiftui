import 'package:mvvm_cubit/data/api/add_trip/add_trip_api.dart';
import 'package:mvvm_cubit/data/api/auth/auth_api.dart';
import 'package:mvvm_cubit/data/api/check_point/check_point_api.dart';
import 'package:mvvm_cubit/data/api/main/main_api.dart';
import 'package:mvvm_cubit/data/api/sos/sos_api.dart';
import 'package:mvvm_cubit/manager/hive_storage_manager.dart';
import 'package:mvvm_cubit/manager/secure_storage_manager.dart';
import 'package:mvvm_cubit/repository/add_trip/add_trip_repository.dart';
import 'package:mvvm_cubit/repository/auth/auth_repository.dart';
import 'package:mvvm_cubit/repository/check_point/check_point_repository.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/repository/sos/sos_repository.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_cubit.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/check_point/check_point_cubit.dart';
import 'package:mvvm_cubit/viewmodel/container/container_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/warning_list/manager_role_warning_list_cubit.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_sos_cubit.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_sos_robber_cubit.dart';

final di = GetIt.instance;

Future<void> init() async {
  //Dio
  di.registerFactory<Dio>(
    () => Dio(),
  );

  di.registerFactory<DioClient>(
    () => DioClient(
      di(),
    ),
  );

  di.registerFactory<SecureStorageManager>(
    () => SecureStorageManager(),
  );

  di.registerFactory<HiveStorageManager>(
    () => const HiveStorageManager(),
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
    () => AuthCubit(
      repository: di(),
      secureStorageManager: di(),
      hiveStorageManager: di(),
    ),
  );
  di.registerFactory(
    () => ReportSOSCubit(
      repository: di(),
      addTripRepository: di(),
    ),
  );
  di.registerFactory(
    () => ReportSOSRobberCubit(repository: di(), addTripRepository: di()),
  );
  di.registerFactory(
    () => CheckPointCubit(repository: di()),
  );

  di.registerFactory(
    () => ContainerCubit(
      repository: di(),
      sosRepository: di(),
    ),
  );
  di.registerFactory(
    () => AddTripCubit(repository: di()),
  );
  di.registerFactory(
    () => ManagerRoleWarningListCubit(
      repository: di(),
      authRepository: di(),
      secureStorageManager: di(),
    ),
  );

// Register Add trip Components
  di.registerLazySingleton<AddTripApi>(
    () => AddTripApi(client: di()),
  );
  di.registerLazySingleton<AddTripRepository>(
    () => AddTripRepository(api: di()),
  );
// Register check point Components
  di.registerLazySingleton<CheckPointApi>(
    () => CheckPointApi(client: di()),
  );
  di.registerLazySingleton<CheckPointRepository>(
    () => CheckPointRepository(api: di()),
  );
  // register sos components
  di.registerLazySingleton<SosApi>(
    () => SosApi(client: di()),
  );
  di.registerLazySingleton<SosRepository>(
    () => SosRepository(api: di()),
  );
}

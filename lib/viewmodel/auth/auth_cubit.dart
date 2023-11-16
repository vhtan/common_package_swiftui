import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';
import 'package:mvvm_cubit/manager/hive_storage_manager.dart';
import 'package:mvvm_cubit/manager/secure_storage_manager.dart';
import 'package:mvvm_cubit/repository/auth/auth_repository.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_state.dart';

class AuthCubit extends Cubit<GenericCubitState<AuthState>> {
  final AuthRepository repository;
  final SecureStorageManager secureStorageManager;
  final HiveStorageManager hiveStorageManager;

  AuthCubit({
    required this.repository,
    required this.secureStorageManager,
    required this.hiveStorageManager,
  }) : super(GenericCubitState.loading());

  Future<void> login(LoginRequest request) async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      ApiConfig.header['Authorization'] = null;
      final loginResponse = await repository.login(request);
      final token = loginResponse.session ?? '';
      final roleCode = loginResponse.role?.code ?? '';
      logger.d('loginResponse ${loginResponse.arrivalLimitRadius}');
      hiveStorageManager.saveLoginData(loginResponse);

      if (loginResponse.session != null) {
        secureStorageManager.saveToken(token, roleCode);
        ApiConfig.header['Authorization'] = loginResponse.session;
        emit(
          GenericCubitState.success(
              LoginStateSuccess((loginResponse.role?.code == 'ATAI') == false)),
        );
      } else {
        emit(
          GenericCubitState.failure("Error"),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.message ?? 'Error'),
      );
    }
  }

  Future<void> logout() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      await repository.logout();
      emit(
        GenericCubitState.success(LogoutStateSuccess()),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(
          e.message ?? 'Error',
        ),
      );
    }
    secureStorageManager.deleteAll();
  }
}

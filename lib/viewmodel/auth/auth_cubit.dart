import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
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
      hiveStorageManager.saveLoginData(loginResponse);
      if (loginResponse.session != null) {
        secureStorageManager.saveToken(token);
        ApiConfig.header['Authorization'] = loginResponse.session;
        emit(
          GenericCubitState.success(
            LoginStateSuccess(isManager: loginResponse.manager ?? false),
          ),
        );
      } else {
        emit(
          GenericCubitState.failure("Error"),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
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
        GenericCubitState.failure(e.errorMessage),
      );
    }
    secureStorageManager.deleteAll();
  }
}

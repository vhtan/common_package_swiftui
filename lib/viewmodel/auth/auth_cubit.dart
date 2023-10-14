import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/repository/auth/auth_repository.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_state.dart';

class AuthCubit extends Cubit<GenericCubitState<AuthState>> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(GenericCubitState.loading());

  Future<void> login(LoginRequest request) async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      ApiConfig.header.remove('Authorization');
      final loginResponse = await repository.api.login(request);
      final token = loginResponse.session ?? '';
      final roleCode = loginResponse.role?.code ?? '';

      if (loginResponse.session != null) {
        _saveLoginData(token, roleCode);
        ApiConfig.header['Authorization'] = loginResponse.session;
        if (loginResponse.role?.code == 'ATAI') {
          emit(
            GenericCubitState.success(null),
          );
        } else {
          emit(
            GenericCubitState.success(
              AuthState(isManager: true),
            ),
          );
        }
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

  Future<void> _saveLoginData(String token, String roleCode) async {
    await di<FlutterSecureStorage>().write(
      key: StoreKey.loginToken,
      value: token,
    );
    await di<FlutterSecureStorage>().write(
      key: StoreKey.roleCode,
      value: roleCode,
    );
  }

  Future<void> logout() async {
    try {
      emit(
        GenericCubitState.loading(),
      );
      final response = await repository.logout();
      if (response != null) {
        emit(
          GenericCubitState.success(null),
        );
      } else {
        emit(
          GenericCubitState.failure('Error'),
        );
      }
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(
          e.message ?? 'Error',
        ),
      );
    }
    _clearLoginToken();
  }

  Future<void> _clearLoginToken() async {
    await di<FlutterSecureStorage>().delete(
      key: StoreKey.loginToken,
    );
    await di<FlutterSecureStorage>().delete(
      key: StoreKey.roleCode,
    );
  }

  void usernameChanged(String value) {
    final password = state.data?.password ?? '';
    emit(GenericCubitState(
        data: AuthState(username: value, password: password),
        error: null,
        status: Status.empty));
  }

  void passwordChanged(String value) {
    final username = state.data?.username ?? '';
    emit(GenericCubitState(
        data: AuthState(username: username, password: value),
        error: null,
        status: Status.empty));
  }
}

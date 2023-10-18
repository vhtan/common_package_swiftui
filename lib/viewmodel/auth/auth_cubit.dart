import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
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
      final loginResponse = await repository.login(request);
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
            GenericCubitState.success(LoginStateSuccess()),
          );
          emit(
            GenericCubitState.success(
              LoginStateSuccess(true),
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
          GenericCubitState.success(LogoutStateSuccess()),
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
    final dataInput = state.data as LoginStateInput?;
    final password = dataInput?.password ?? '';

    emit(
      GenericCubitState.success(
        LoginStateInput(
          username: value,
          password: password,
        ),
      ),
    );
  }

  void passwordChanged(String value) {
    final dataInput = state.data as LoginStateInput;
    final username = dataInput.username ?? '';
    emit(GenericCubitState(
        data: LoginStateInput(username: username, password: value),
        error: null,
        status: Status.empty));
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
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
      final response = await repository.api.login(request);
      if (response != null) {
        final user = LoginResponse.fromJson(response);
        if (user.session != null) {
          _saveLoginToken(user.session!);
        }
        emit(
          GenericCubitState.success(null),
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

  Future<void> _saveLoginToken(String token) async {
    await getIt<FlutterSecureStorage>().write(
      key: StoreKey.loginToken,
      value: token,
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
    await getIt<FlutterSecureStorage>().delete(
      key: StoreKey.loginToken,
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

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';
import 'package:mvvm_cubit/repository/auth/auth_repository.dart';

class AuthCubit extends Cubit<GenericCubitState<LoginResponse>> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(GenericCubitState.loading());

  Future<void> login(LoginRequest request) async {
    emit(GenericCubitState.loading());
    final response = await repository.api.login(request);
    if (response != null) {
      print("login response = $response");
      final user = LoginResponse.fromJson(response);
      print("login data = $user");
      emit(
          GenericCubitState.success(user.copyWith(username: request.username)));
    } else {
      emit(GenericCubitState.failure("Error"));
    }
  }

  void phoneChanged(String value) {
    final password = state.data?.password ?? '';
    emit(GenericCubitState(
        data: LoginResponse(username: value, password: password),
        error: null,
        status: Status.empty));
  }

  void passwordChanged(String value) {
    final phone = state.data?.username ?? '';
    emit(GenericCubitState(
        data: LoginResponse(username: phone, password: value),
        error: null,
        status: Status.empty));
  }
}

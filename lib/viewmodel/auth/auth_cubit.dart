import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/auth/user.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';
import 'package:mvvm_cubit/repository/auth/auth_repository.dart';

class AuthCubit extends Cubit<GenericCubitState<User>> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(GenericCubitState.loading());

  Future<void> getPosts(LoginRequest request) async {}

  void login(BuildContext context) {
    emit(const GenericCubitState(
        data: null, error: null, status: Status.success));
  }

  void phoneChanged(String value) {
    final password = state.data?.password ?? '';
    emit(GenericCubitState(
        data: User(phone: value, password: password),
        error: null,
        status: Status.empty));
  }

  void passwordChanged(String value) {
    final phone = state.data?.phone ?? '';
    emit(GenericCubitState(
        data: User(phone: phone, password: value),
        error: null,
        status: Status.empty));
  }
}

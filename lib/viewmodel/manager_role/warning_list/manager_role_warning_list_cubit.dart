import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/manager/secure_storage_manager.dart';
import 'package:mvvm_cubit/repository/auth/auth_repository.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/warning_list/manager_role_warning_list_state.dart';

class ManagerRoleWarningListCubit extends Cubit<GenericCubitState<dynamic>> {
  final MainRepository repository;
  final AuthRepository authRepository;
  final SecureStorageManager secureStorageManager;

  ManagerRoleWarningListCubit({
    required this.repository,
    required this.authRepository,
    required this.secureStorageManager,
  }) : super(GenericCubitState.loading());

  Future<void> getWarningList() async {
    try {
      final warnings = await repository.getWarningList();
      emit(
        GetWarningListSuccess(
          warnings: warnings,
          status: Status.success,
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  Future<void> getWarningListForFetching() async {
    try {
      final warnings = await repository.getWarningList();
      emit(
        GetWarningListSuccess(
          warnings: warnings,
          status: Status.success,
        ),
      );
    } on DioException catch (e) {
      logger.e(e.errorMessage);
    }
  }

  Future<void> getTempFormListNeedToHandle(int page) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final listResponse = await repository.getTempFormHistories(page);
      emit(
        GetTempFormWarningListState(
          listResponse: listResponse,
          status: Status.success,
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      secureStorageManager.deleteAll();
      emit(
        const DidLogoutWarningListSuccess(status: Status.success),
      );
    } on DioException catch (e) {
      logger.e(e.message);
      secureStorageManager.deleteAll();
      emit(
        const DidLogoutWarningListSuccess(status: Status.success),
      );
    }
  }
}

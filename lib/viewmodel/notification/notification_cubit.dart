// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/notification/notification_state.dart';

class NotificationCubit extends Cubit<GenericCubitState<dynamic>> {
  final MainRepository repository;

  NotificationCubit({required this.repository})
      : super(GenericCubitState.loading());

  Future<void> getNotificationList() async {
    emit(
      GenericCubitState.loading(),
    );
    final response = await repository.getNotificationList(false);
    try {
      emit(
        GetNotificationListSuccess(
          status: Status.success,
          list: response,
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }

  void readNotification(String id) async {
    await repository.readNotification(id);
    try {
      // emit(
      //   const DidReadNotification(
      //     status: Status.success,
      //   ),
      // );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}

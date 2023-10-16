// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/notification/notification_state.dart';

class NotificationCubit extends Cubit<GenericCubitState<dynamic>> {
  final MainRepository repository;

  NotificationCubit({required this.repository})
      : super(GenericCubitState.loading());

  void getNotificationList() async {
    final response = await repository.getNotificationList();
    try {
      emit(
        GetNotificationListSuccess(
          status: Status.success,
          list: response,
        ),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }
}

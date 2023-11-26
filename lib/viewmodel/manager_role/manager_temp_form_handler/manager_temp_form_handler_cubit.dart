import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/request/temp_form_process/temp_form_process_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class ManagerTempFormHandlerCubit extends Cubit<GenericCubitState<dynamic>> {
  final MainRepository repository;

  ManagerTempFormHandlerCubit({required this.repository})
      : super(GenericCubitState.loading());

  void tempFormProcess(TempFormProcessRequest request) async {
    await repository.tempFormProcess(request);
    try {
      emit(
        const DidProcessTempFormSuccess(status: Status.success),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}

class ManagerTempFormHandlerState extends GenericCubitState<dynamic> {
  const ManagerTempFormHandlerState({required super.status});
}

class DidProcessTempFormSuccess extends ManagerTempFormHandlerState {
  const DidProcessTempFormSuccess({required super.status});
}

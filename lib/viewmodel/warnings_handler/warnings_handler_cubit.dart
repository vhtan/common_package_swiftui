// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/request/warning_process/warning_process_request.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_warnings_handler/manager_warnings_handler_state.dart';

class WarningsHandlerCubit extends Cubit<GenericCubitState<dynamic>> {
  final MainRepository repository;

  WarningsHandlerCubit({required this.repository})
      : super(GenericCubitState.loading());

  void getWarningDetails(String id) async {
    try {
      final warningDetails = await repository.getWarningDetails(id);
      emit(
        GetWarningDetailsSuccess(
          warningDetails: warningDetails,
          status: Status.success,
        ),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }

  void warningProcess(WarningProcessRequest request) async {
    await repository.warningProcess(request);

    try {
      emit(
        const ProcessWarningSuccess(status: Status.success),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }
}

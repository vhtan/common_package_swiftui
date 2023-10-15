// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/api/sos/sos_submit_request.dart';
import 'package:mvvm_cubit/data/model/sos/sos_response.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';
import 'package:mvvm_cubit/repository/sos/sos_repository.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/manager_warnings_handler/manager_warnings_handler_state.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_state.dart';

class ManagerWarningsHandlerCubit extends Cubit<GenericCubitState<dynamic>> {
  final MainRepository repository;

  ManagerWarningsHandlerCubit({required this.repository})
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

  void submitSOS(SOSSubmitRequest request) async {
    // await repository.submitSOS(request);
    // try {
    //   emit(
    //     GenericCubitState.success(null),
    //   );
    // } catch (ex) {
    //   emit(
    //     GenericCubitState.failure(ex.toString()),
    //   );
    // }
  }
}

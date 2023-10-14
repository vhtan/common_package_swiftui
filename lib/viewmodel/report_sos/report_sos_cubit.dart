// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/data/api/sos/sos_submit_request.dart';
import 'package:mvvm_cubit/data/model/sos/child_sos_response.dart';
import 'package:mvvm_cubit/data/model/sos/sos_response.dart';
import 'package:mvvm_cubit/repository/sos/sos_repository.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_state.dart';

class ReportSOSCubit extends Cubit<GenericCubitState<ReportSOSData>> {
  final SosRepository repository;

  ReportSOSCubit({required this.repository})
      : super(GenericCubitState.loading());

  void didCapturePhoto(File? file) async {
    if (file == null) {
      emit(
        GenericCubitState.success(ReportSOSData()),
      );
      return;
    }
    final response = await repository.uploadImage(file.path);
    try {
      emit(
        UploadImageSuccess(status: Status.success, uploadUrl: response, file: file),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }

  void getReasons() async {
    final response = await repository.getReasons();
    final reasons = SOSResponse.fromJson({'detail': response.detail}).detail;
    try {
      emit(
        GetReasonsSuccess(status: Status.success, reasons: reasons??[]),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }

  void submitSOS(SOSSubmitRequest request) async {
    await repository.submitSOS(request);
    try {
      emit(
        GenericCubitState.success(ReportSOSData()),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }
}

class ReportSOSData {
  String? reason;
}

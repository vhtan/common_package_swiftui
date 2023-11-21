// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_error.dart';
import 'package:mvvm_cubit/data/api/sos/sos_submit_request.dart';
import 'package:mvvm_cubit/data/model/sos/sos_response.dart';
import 'package:mvvm_cubit/repository/sos/sos_repository.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_state.dart';

class ReportSOSCubit extends Cubit<GenericCubitState<dynamic>> {
  final SosRepository repository;

  ReportSOSCubit({required this.repository})
      : super(GenericCubitState.loading());

  void didCapturePhoto(File? file) async {
    if (file == null) {
      emit(
        GenericCubitState.loading(),
      );
      return;
    }
    final response = await repository.uploadImage(file.path);
    try {
      emit(
        GenericCubitState.success(
          UploadImageSuccess(imageResponse: response, file: file),
        ),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }

  void getReasons() async {
    emit(
      GenericCubitState.loading(),
    );
    final response = await repository.getReasons();
    final reasons = SOSResponse.fromJson({'detail': response.detail}).detail;
    try {
      emit(
        GenericCubitState.success(
          GetReasonsSuccess(reasons: reasons ?? []),
        ),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }

  void submitSOS(SOSSubmitRequest request) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final apiResponse = await repository.submitSOS(request);
      logger.d('=== |||||| apiResponse $apiResponse');
      if (apiResponse.code == ErrorCode.SUCCESS) {
        emit(
          GenericCubitState.success(
            const DidSubmitReasonSuccess(),
          ),
        );
      } else {
        emit(
          GenericCubitState.failure(
              'Báo cáo sự cố thất bại. Vui lòng thử lại sau.'),
        );
      }
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }
}

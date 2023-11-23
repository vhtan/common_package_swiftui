import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_error.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
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
    try {
      final response = await repository.uploadImage(file.path);
      emit(
        GenericCubitState.success(
          UploadImageSuccess(imageResponse: response, file: file),
        ),
      );
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
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
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
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
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/repository/sos/sos_repository.dart';

class ReportSOSCubit extends Cubit<GenericCubitState<ReportSOSData>> {
  final SosRepository repository;

  ReportSOSCubit({required this.repository})
      : super(GenericCubitState.loading());

  void didCapturePhoto(File? file, String reason) {
    if (file == null) {
      emit(
        GenericCubitState.success(ReportSOSData(file: null, reason: reason)),
      );
      return;
    }
    final response = repository.uploadImage(file.path);
    try {
      emit(
        GenericCubitState.success(ReportSOSData(file: file, reason: reason)),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }
}

class ReportSOSData {
  final File? file;
  final String? reason;
  const ReportSOSData({required this.file, required this.reason});
}

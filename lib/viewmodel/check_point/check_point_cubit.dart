import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/repository/check_point/check_point_repository.dart';

class CheckPointCubit extends Cubit<GenericCubitState<CheckPointData>> {
  final CheckPointRepository repository;

  CheckPointCubit({required this.repository})
      : super(GenericCubitState.loading());

  void didCapturePhoto(File? file) {
    if (file == null) {
      emit(
        GenericCubitState.success(const CheckPointData(file: null)),
      );
      return;
    }
    final response = repository.uploadImage(file.path);
    try {
      emit(
        GenericCubitState.success(CheckPointData(file: file)),
      );
    } catch (ex) {
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }
}

class CheckPointData {
  final File? file;
  const CheckPointData({required this.file});
}

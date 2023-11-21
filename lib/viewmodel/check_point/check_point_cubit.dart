import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/repository/check_point/check_point_repository.dart';

class CheckPointCubit extends Cubit<GenericCubitState<CheckPointData>> {
  final CheckPointRepository repository;

  CheckPointCubit({required this.repository})
      : super(GenericCubitState.loading());

  void didCapturePhoto(File? file) async {
    if (file == null) {
      emit(
        GenericCubitState.success(
          const CheckPointData(
            file: null,
            imagePath: null,
            imgName: null,
          ),
        ),
      );
      return;
    }

    try {
      final imageResponse = await repository.uploadImage(file.path);
      if (imageResponse != null) {
        emit(
          GenericCubitState.success(
            CheckPointData(
              file: file,
              imagePath: imageResponse.imageUrl,
              imgName: imageResponse.imageName,
            ),
          ),
        );
      }
    } catch (ex) {
      logger.i(ex);
      emit(
        GenericCubitState.failure(ex.toString()),
      );
    }
  }
}

class CheckPointData {
  final File? file;
  final String? imagePath;
  final String? imgName;
  const CheckPointData({
    required this.file,
    required this.imagePath,
    required this.imgName,
  });
}

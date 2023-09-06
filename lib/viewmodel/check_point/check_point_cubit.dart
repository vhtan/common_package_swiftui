import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

class CheckPointCubit extends Cubit<CheckPointData> {
  CheckPointCubit() : super(const CheckPointData(file: null));

  void didCapturePhoto(File? file) {
    emit(CheckPointData(file: file));
  }
}

class CheckPointData {
  final File? file;
  const CheckPointData({required this.file});
}

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

class ReportSOSCubit extends Cubit<ReportSOSData> {
  ReportSOSCubit() : super(const ReportSOSData(file: null, reason: null));

  void didCapturePhoto(File? file) {
    emit(ReportSOSData(file: file, reason: null));
  }
}

class ReportSOSData {
  final File? file;
  final String? reason;
  const ReportSOSData({required this.file, required this.reason});
}

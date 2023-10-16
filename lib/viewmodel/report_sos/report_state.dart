// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:io';

import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/sos/child_sos_response.dart';

class ReportState extends GenericCubitState<dynamic> {
  const ReportState({required super.status});
}

class UploadImageSuccess extends ReportState {
  String uploadUrl;
  File? file;
  UploadImageSuccess(
      {required this.uploadUrl, required super.status, required this.file});
}

class GetReasonsSuccess extends ReportState {
  List<ChildSOSResponse> reasons;
  GetReasonsSuccess({required this.reasons, required super.status});
}

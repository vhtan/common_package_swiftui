// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:io';

import 'package:mvvm_cubit/data/model/sos/child_sos_response.dart';

class ReportState {
  const ReportState();
}

class UploadImageSuccess extends ReportState {
  String uploadUrl;
  File? file;
  UploadImageSuccess({required this.uploadUrl, required this.file});
}

class GetReasonsSuccess extends ReportState {
  List<ChildSOSResponse> reasons;
  GetReasonsSuccess({required this.reasons});
}

class DidSubmitReasonSuccess extends ReportState {
  const DidSubmitReasonSuccess();
}

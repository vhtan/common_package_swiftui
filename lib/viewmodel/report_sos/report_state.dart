// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:io';

import 'package:mvvm_cubit/data/api/upload_image/upload_image_ext.dart';
import 'package:mvvm_cubit/data/model/sos/child_sos_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';

class ReportState {
  const ReportState();
}

class UploadImageSuccess extends ReportState {
  ImageResponse imageResponse;
  File? file;
  UploadImageSuccess({
    required this.imageResponse,
    required this.file,
  });
}

class GetReasonsSuccess extends ReportState {
  List<ChildSOSResponse> reasons;
  GetReasonsSuccess({required this.reasons});
}

class DidSubmitReasonSuccess extends ReportState {
  String sosId;
  DidSubmitReasonSuccess({
    required this.sosId,
  });
}

class GetVehicleListSuccess extends ReportState {
  List<VehicleResponse> vehicleList;
  GetVehicleListSuccess({
    required this.vehicleList,
  });
}

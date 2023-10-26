// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/main/destination/destination_response.dart';
import 'package:mvvm_cubit/data/model/main/routing_job/routing_job_response.dart';

part 'stop_point_response.g.dart';
part 'stop_point_response.freezed.dart';

@freezed
abstract class StopPointResponse with _$StopPointResponse {
  const factory StopPointResponse({
    required String id,
    String? detailId,
    String? createBy,
    String? stopPointType,
    String? stopPointAction,
    StopPointStatus? status,
    String? imagePath,
    int? jobRequestId,
    DestinationResponse? destination,
    RoutingJobResponse? routingJob,
  }) = _StopPointResponse;

  factory StopPointResponse.fromJson(Map<String, dynamic> json) =>
      _$StopPointResponseFromJson(json);
}

enum StopPointStatus {
  ACT,
  PRO,
  INA,
  CLS,
}

extension StopPointStatusCheckIn on StopPointStatus {
  bool canCheckIn() {
    return this == StopPointStatus.ACT || this == StopPointStatus.PRO;
  }
}

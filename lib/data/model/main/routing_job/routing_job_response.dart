import 'package:freezed_annotation/freezed_annotation.dart';

part 'routing_job_response.g.dart';
part 'routing_job_response.freezed.dart';

@freezed
abstract class RoutingJobResponse with _$RoutingJobResponse {
  const factory RoutingJobResponse({
    String? id,
    int? jobRequestId,
    String? objectType,
    String? model,
    String? placeReceive,
    String? priorityLevel,
    String? approvalName,
    String? destResName,
  }) = _RoutingJobResponse;

  factory RoutingJobResponse.fromJson(Map<String, dynamic> json) =>
      _$RoutingJobResponseFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/main/destination/destination_response.dart';

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
    String? status,
    DestinationResponse? destination,
  }) = _StopPointResponse;

  factory StopPointResponse.fromJson(Map<String, dynamic> json) =>
      _$StopPointResponseFromJson(json);
}

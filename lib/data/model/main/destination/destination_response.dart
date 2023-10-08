import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination_response.g.dart';
part 'destination_response.freezed.dart';

@freezed
abstract class StopPointResponse with _$StopPointResponse {
  const factory StopPointResponse({
    String? id,
    String? detailId,
    String? createBy,
    String? stopPointType,
    String? stopPointAction,
    String? status,
  }) = _StopPointResponse;

  factory StopPointResponse.fromJson(Map<String, dynamic> json) =>
      _$StopPointResponseFromJson(json);
}

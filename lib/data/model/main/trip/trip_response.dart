import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/main/stop_point_response/stop_point_response.dart';

part 'trip_response.g.dart';
part 'trip_response.freezed.dart';

@freezed
abstract class TripResponse with _$TripResponse {
  const factory TripResponse({
    String? transportType,
    String? createBy,
    String? routeStatus,
    List<StopPointResponse>? routingDetails,
  }) = _TripResponse;

  factory TripResponse.fromJson(Map<String, dynamic> json) =>
      _$TripResponseFromJson(json);
}

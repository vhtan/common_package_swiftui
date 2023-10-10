import 'package:freezed_annotation/freezed_annotation.dart';
part 'vehicle_response.g.dart';
part 'vehicle_response.freezed.dart';

@freezed
abstract class VehicleResponse with _$VehicleResponse {
  const factory VehicleResponse({
    String? id,
    String? plateNumber,
    String? description,
  }) = _VehicleResponse;
  factory VehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$VehicleResponseFromJson(json);
}

List<VehicleResponse> parseVehicleResponseList(List<dynamic> parsedList) {
  return parsedList
      .map((json) => VehicleResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}

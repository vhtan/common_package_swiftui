import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

part 'destination_response.g.dart';
part 'destination_response.freezed.dart';

@freezed
abstract class DestinationResponse with _$DestinationResponse {
  const factory DestinationResponse({
    String? id,
    String? address,
    double? latitude,
    double? longitude,
  }) = _StopPointResponse;

  factory DestinationResponse.fromJson(Map<String, dynamic> json) =>
      _$DestinationResponseFromJson(json);

  LocationData? locationData() {
    return LocationData.fromMap({'longitude': longitude, 'latitude': latitude});
  }
}

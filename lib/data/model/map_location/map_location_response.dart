import 'package:freezed_annotation/freezed_annotation.dart';
part 'map_location_response.g.dart';
part 'map_location_response.freezed.dart';

@freezed
abstract class MapLocationResponse with _$MapLocationResponse {
  const factory MapLocationResponse({
    String? display,
    double? lat,
    double? lng,
  }) = _MapLocationResponse;

  factory MapLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$MapLocationResponseFromJson(json);
}

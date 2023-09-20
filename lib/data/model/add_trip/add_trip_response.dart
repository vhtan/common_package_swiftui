import 'package:freezed_annotation/freezed_annotation.dart';
part 'add_trip_response.g.dart';
part 'add_trip_response.freezed.dart';

@freezed
abstract class AddTripResponse with _$AddTripResponse {
  const factory AddTripResponse({
    String? title,
  }) = _AddTripResponse;

  factory AddTripResponse.fromJson(Map<String, dynamic> json) =>
      _$AddTripResponseFromJson(json);
}

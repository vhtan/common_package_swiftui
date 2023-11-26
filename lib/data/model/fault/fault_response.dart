import 'package:freezed_annotation/freezed_annotation.dart';
part 'fault_response.g.dart';
part 'fault_response.freezed.dart';

@freezed
abstract class FaultResponse with _$FaultResponse {
  const factory FaultResponse({
    String? id,
    int? dateCreated,
    String? title,
    String? body,
    String? processStatus,
  }) = _FaultResponse;
  factory FaultResponse.fromJson(Map<String, dynamic> json) =>
      _$FaultResponseFromJson(json);
}

List<FaultResponse> parseFaultResponseList(List<dynamic> parsedList) {
  return parsedList
      .map((json) => FaultResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}

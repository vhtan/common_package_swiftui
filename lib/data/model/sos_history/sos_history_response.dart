import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/sos/child_sos_response.dart';
part 'sos_history_response.g.dart';
part 'sos_history_response.freezed.dart';

@freezed
abstract class SOSHistoryResponse with _$SOSHistoryResponse {
  const factory SOSHistoryResponse({
    String? id,
    int? dateCreated,
    int? type,
    String? note,
    ChildSOSResponse? reason,
  }) = _SOSHistoryResponse;

  factory SOSHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$SOSHistoryResponseFromJson(json);
}

List<SOSHistoryResponse> parseSOSHistoryResponseList(List<dynamic> parsedList) {
  return parsedList
      .map((json) => SOSHistoryResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}

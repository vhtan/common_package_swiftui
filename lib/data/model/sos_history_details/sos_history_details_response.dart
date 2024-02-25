import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/sos/child_sos_response.dart';
part 'sos_history_details_response.g.dart';
part 'sos_history_details_response.freezed.dart';

@freezed
abstract class SOSHistoryDetailsResponse with _$SOSHistoryDetailsResponse {
  const factory SOSHistoryDetailsResponse({
    String? id,
    int? dateCreated,
    int? type,
    int? status,
    String? note,
    ChildSOSResponse? reason,
    String? image,
  }) = _SOSHistoryDetailsResponse;

  factory SOSHistoryDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$SOSHistoryDetailsResponseFromJson(json);
}

// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
part 'sos_history_response.g.dart';
part 'sos_history_response.freezed.dart';

@freezed
abstract class SOSHistoryResponse with _$SOSHistoryResponse {
  const factory SOSHistoryResponse({
    String? id,
  }) = _SOSHistoryResponse;

  factory SOSHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$SOSHistoryResponseFromJson(json);
}

List<SOSHistoryResponse> parseSOSHistoryResponseList(List<dynamic> parsedList) {
  return parsedList
      .map((json) => SOSHistoryResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}

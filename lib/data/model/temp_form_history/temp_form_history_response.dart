// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
part 'temp_form_history_response.g.dart';
part 'temp_form_history_response.freezed.dart';

@freezed
abstract class TempFormHistoryResponse with _$TempFormHistoryResponse {
  const factory TempFormHistoryResponse({
    String? id,
    int? dateCreated,
    PurposeResponse? purpose,
    UserRoleResponse? driver,
    UserRoleResponse? bodyguard,
    VehicleResponse? vehicle,
    AddressResponse? address,
    TempFormStatus? status,
    String? note,
    String? code,
    List<BalanceDetailsResponse>? balanceDetails,
    String? image,
  }) = _TempFormHistoryResponse;

  factory TempFormHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$TempFormHistoryResponseFromJson(json);
}

List<TempFormHistoryResponse> parseTempFormHistoryResponseList(
    List<dynamic> parsedList) {
  return parsedList
      .map((json) =>
          TempFormHistoryResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}

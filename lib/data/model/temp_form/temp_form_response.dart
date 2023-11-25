// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
part 'temp_form_response.g.dart';
part 'temp_form_response.freezed.dart';

@freezed
abstract class TempFormResponse with _$TempFormResponse {
  const factory TempFormResponse({
    int? routeId,
    PurposeResponse? purpose,
    UserRoleResponse? driver,
    UserRoleResponse? bodyguard,
    VehicleResponse? vehicle,
    AddressResponse? address,
    TempFormStatus? status,
    double? quantity,
    String? currency,
    String? note,
    String? code,
  }) = _TempFormResponse;

  factory TempFormResponse.fromJson(Map<String, dynamic> json) =>
      _$TempFormResponseFromJson(json);
}

@freezed
abstract class AddressResponse with _$AddressResponse {
  const factory AddressResponse({
    String? address,
    double? lat,
    double? lng,
  }) = _AddressResponse;
  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseFromJson(json);
}

enum TempFormStatus {
  NEW,
  APPROVED,
  CLOSED,
  REJECTED,
  CANCELED,
}

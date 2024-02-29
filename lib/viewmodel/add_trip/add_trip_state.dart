import 'dart:io';

import 'package:mvvm_cubit/data/api/upload_image/upload_image_ext.dart';
import 'package:mvvm_cubit/data/model/map_location/map_location_response.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';

class AddTripState {}

class GetPurposesState extends AddTripState {
  final List<PurposeResponse> purposes;

  GetPurposesState({required this.purposes});
}

class GetDriversState extends AddTripState {
  final List<UserRoleResponse> drivers;

  GetDriversState({required this.drivers});
}

class GetGuardsState extends AddTripState {
  final List<UserRoleResponse> guards;

  GetGuardsState({required this.guards});
}

class GetVehiclesState extends AddTripState {
  final List<VehicleResponse> vehicles;

  GetVehiclesState({required this.vehicles});
}

class GetCurrenciesState extends AddTripState {
  final List<String> currencies;

  GetCurrenciesState({required this.currencies});
}

class GetTempFormState extends AddTripState {
  final String? form;

  GetTempFormState({required this.form});
}

class GetMapLocationSate extends AddTripState {
  final MapLocationResponse? location;

  GetMapLocationSate({required this.location});
}

class DidAddTripState extends AddTripState {
  DidAddTripState();
}

class UploadImageAddTripSuccess extends AddTripState {
  ImageResponse? imageResponse;
  File? file;
  UploadImageAddTripSuccess({
    required this.imageResponse,
    required this.file,
  });
}

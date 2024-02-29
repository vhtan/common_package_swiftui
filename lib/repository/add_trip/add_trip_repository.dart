import 'package:mvvm_cubit/common/network/api_response/api_response.dart';
import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/add_trip/add_trip_api.dart';
import 'package:mvvm_cubit/data/api/upload_image/upload_image_ext.dart';
import 'package:mvvm_cubit/data/model/map_location/map_location_response.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';
import 'package:mvvm_cubit/data/request/add_trip/user_type.dart';

class AddTripRepository with RepositoryHelper<dynamic> {
  final AddTripApi _api;

  const AddTripRepository({required AddTripApi api}) : _api = api;

  Future<ApiResponse> createTrip(AddTripRequest request) async {
    return _api.createTrip(request);
  }

  Future<dynamic> updateTrip(AddTripRequest request) async {
    return _api.udpateTrip(request);
  }

  Future<List<PurposeResponse>> taskPurposeList() async {
    return _api.taskPurposeList();
  }

  Future<List<VehicleResponse>> vehicleList() async {
    return _api.vehicleList();
  }

  Future<List<UserRoleResponse>> driverList() async {
    return _api.userSearchList(
      [RoleType.driver],
    );
  }

  Future<List<UserRoleResponse>> guardList() async {
    return _api.userSearchList(
      [RoleType.guard],
    );
  }

  Future<MapLocationResponse> getMapLocation(String refId) async {
    return _api.getMapLocation(refId);
  }

  Future<List<String>> getCurrencyList() async {
    return _api.getCurrencyList();
  }

  Future<ImageResponse?> uploadImage(String path) async {
    return await _api.uploadImage(
      _api.client,
      path,
      _api,
    );
  }
}

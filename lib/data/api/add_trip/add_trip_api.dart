import 'dart:convert';

import 'package:http/http.dart';
import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/add_trip/add_trip_response.dart';
import 'package:mvvm_cubit/data/model/map_location/map_location_response.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';
import 'package:mvvm_cubit/data/request/add_trip/user_type.dart';

class AddTripApi with ApiHelper<AddTripResponse> {
  final DioClient client;

  AddTripApi({required this.client});

  Future<String> createTrip(AddTripRequest request) async {
    final apiResponse = await makePostRequest(
      client.dio.post(
        ApiConfig.createTrip,
        data: request,
      ),
    );
    return apiResponse.detail;
  }

  Future<List<PurposeResponse>> taskPurposeList() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(ApiConfig.taskPurposeList),
    );

    return parsePurposeResponseList(apiResponse.detail);
  }

  Future<List<VehicleResponse>> vehicleList() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(ApiConfig.vehicleList),
    );

    return parseVehicleResponseList(apiResponse.detail);
  }

  Future<List<UserRoleResponse>> userSearchList(List<RoleType> roles) async {
    final queryParameters = {
      'roles': roles.map((e) => e.roleTypeToString()).join(','),
    };
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.userSearchList,
        queryParameters: queryParameters,
      ),
    );

    return userRoleResponseList(apiResponse.detail);
  }

  Future<List<String>> getCurrencyList() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.currencyList,
      ),
    );

    final data = apiResponse.detail['listCurrency'];
    return List<String>.from(data);
  }

  Future<MapLocationResponse> getMapLocation(String refId) async {
    Response response = await get(
      Uri.parse('${ApiConfig.vietMapGetLocation}$refId'),
    ).timeout(
      const Duration(seconds: 10),
    );
    if (response.statusCode != 200) {
      throw Exception("failed to get data from internet");
    }
    dynamic data = jsonDecode(response.body);
    return MapLocationResponse.fromJson(data);
  }
}

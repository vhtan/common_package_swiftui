import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/add_trip/add_trip_response.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';
import 'package:mvvm_cubit/data/request/add_trip/user_type.dart';

class AddTripApi with ApiHelper<AddTripResponse> {
  final DioClient client;

  AddTripApi({required this.client});

  Future<dynamic> createTrip(AddTripRequest request) async {
    return await makePostRequest(
      client.dio.post(
        ApiConfig.createTrip,
        data: request,
      ),
    );
  }

  Future<List<PurposeResponse>> taskPurposeList() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(ApiConfig.taskPurposeList),
    );
    final purposes = parsePurposeResponseList(apiResponse.detail);
    return purposes;
  }

  Future<List<VehicleResponse>> vehicleList() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(ApiConfig.vehicleList),
    );
    final list = parseVehicleResponseList(apiResponse.detail);
    logger.d('vehicleList $list');
    return list;
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
    final userRoles = userRoleResponseList(apiResponse.detail);
    return userRoles;
  }
}

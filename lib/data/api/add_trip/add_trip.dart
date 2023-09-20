import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/add_trip/add_trip_response.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';

class AddTripApi with ApiHelper<AddTripResponse> {
  final DioClient client;

  AddTripApi({required this.client});

  Future<dynamic> createTrip(AddTripRequest request) async {
    return await makePostRequest(
        client.dio.post(ApiConfig.createTrip, data: request));
  }
}

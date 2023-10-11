import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';

class MainApi with ApiHelper<Trip> {
  final DioClient client;

  MainApi({required this.client});

  Future<TripResponse> getTrip() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.getTrip,
      ),
    );
    return TripResponse.fromJson(apiResponse.detail);
  }

  Future<TempFormResponse> getTempFormDetails() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.tempFormDetails,
      ),
    );
    return TempFormResponse.fromJson(apiResponse.detail);
  }
}

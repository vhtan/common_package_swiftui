import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/warning/warning_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/data/request/check_in/check_in_request.dart';
import 'package:mvvm_cubit/data/request/push_token/push_token_request.dart';
import 'package:mvvm_cubit/data/request/warning_process/warning_process_request.dart';

class MainApi with ApiHelper<dynamic> {
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

  Future<List<WarningResponse>> getWarningList() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.warningList,
      ),
    );
    return parseWarningResponseList(apiResponse.detail);
  }

  Future<dynamic> submitArrived(CheckInRequest request) async {
    final apiResponse = await makePostRequest(
      client.dio.post(
        ApiConfig.arrivedStopPoint(request.id),
        data: request,
      ),
    );
    return TripResponse.fromJson(apiResponse.detail);
  }

  Future<dynamic> updatePushToken(PushTokenRequest request) async {
    return await makePostRequest(
      client.dio.post(
        ApiConfig.updatePushToken,
        data: request,
      ),
    );
  }

  Future<WarningDetailsResponse> getWarningDetails(String id) async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.warningDetails(id),
      ),
    );
    return WarningDetailsResponse.fromJson(apiResponse.detail);
  }

  Future<dynamic> warningProcess(WarningProcessRequest request) async {
    return await makePostRequest(
      client.dio.post(
        ApiConfig.warningProcess,
        data: request,
      ),
    );
  }
}

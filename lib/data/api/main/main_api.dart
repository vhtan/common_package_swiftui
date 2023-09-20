import 'dart:convert';

import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/data/request/auth/logout_request.dart';

class MainApi with ApiHelper<Trip> {
  final DioClient client;

  MainApi({required this.client});

  Future<dynamic> logout(LogoutRequest request) async {
    Map<String, String> queryParameters = {"username": request.username};
    return await get(
        client.dio.get(ApiConfig.logout, queryParameters: queryParameters));
  }

  Future<Trip> getTrip() async {
    Map<String, String> queryParameters = <String, String>{};

    // if (gender != null && gender != Gender.all) {
    //   queryParameters.addAll({'gender': gender.name});
    // }

    // if (status != null && status != DeliveryStatus.all) {
    //   queryParameters.addAll({'status': status.name});
    // }

    // return await makeGetRequest(
    //     client.dio.get(ApiConfig.getTrip, queryParameters: queryParameters),
    //     Trip.fromJson);
    return await get(
      client.dio.get(ApiConfig.getTrip, queryParameters: queryParameters),
    );
  }
}

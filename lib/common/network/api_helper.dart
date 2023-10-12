import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_error.dart';
import 'package:mvvm_cubit/common/network/api_response.dart';
import 'package:mvvm_cubit/common/network/dio_exception.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:dio/dio.dart';
import 'package:mvvm_cubit/main.dart';

abstract mixin class ApiHelper<T> {
  late final T data;

  Future<ApiResponse> _requestMethodTemplate(
      Future<Response<dynamic>> apiCallback) async {
    try {
      final Response response = await apiCallback;
      final apiResponse = ApiResponse.fromJson(response.data);
      logger.d('_requestMethodTemplate ${apiResponse.code}');
      if (response.statusCode.success) {
        if (apiResponse.code == ErrorCode.SUCCESS) {
          return apiResponse;
        }
        throw Error();
      } else {
        throw DioExceptions;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode.tokenExpired ?? false) {
        AuthManager.notifyTokenExpired();
      }
      rethrow;
    }
  }

  Future<ApiResponse> makeGetRequest(
      Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  Future<ApiResponse> makePostRequest(
      Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  Future<ApiResponse> makePutRequest(
      Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  Future<ApiResponse> makeDeleteRequest(
      Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  // Future<ApiResponse> _requestMethodTemplate1(
  //     Future<Response<dynamic>> apiCallback) async {
  //   final Response response = await apiCallback;
  //   if (response.statusCode.success) {
  //     final apiResponse = ApiResponse.fromJson(response.data);
  //     if (apiResponse.code == ErrorCode.SUCCESS) {
  //       return apiResponse;
  //     }
  //     throw Error();
  //   } else {
  //     throw DioExceptions;
  //   }
  // }

  // Future<ApiResponse> makeGet(Future<Response<dynamic>> apiCallback) async {
  //   return _requestMethodTemplate1(apiCallback);
  // }

  //Generic method template for getting data from Api
  // Future<List<T>> makeGetRequest(Future<Response<dynamic>> apiCallback,
  //     T Function(Map<String, dynamic> json) getJsonCallback) async {
  //   final Response response = await apiCallback;

  //   final List<T> items = List<T>.from(
  //     json
  //         .decode(json.encode(response.data))
  //         .map((item) => getJsonCallback(item)),
  //   );
  //   if (response.statusCode.success) {
  //     return items;
  //   } else {
  //     throw DioExceptions;
  //   }
  // }
}

import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_error.dart';
import 'package:mvvm_cubit/common/network/api_response/api_response.dart';
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
      logger.d('apiResponse $apiResponse');
      logger.d('apiResponsess ${response.statusCode.success}');
      if (response.statusCode.success) {
        logger.d('go here ${apiResponse.code}');
        return apiResponse;
        // if (apiResponse.code == ErrorCode.SUCCESS) {
        //   return apiResponse;
        // }
        // throw Error();
      } else {
        throw DioExceptions;
      }
    } on DioException catch (e) {
      logger.d('===statusCode ${e.response?.statusCode}');
      if (e.response?.statusCode.tokenExpired ?? false) {
        AuthManager.instance.notifyTokenExpired();
        throw DioExceptions;
      } else {
        rethrow;
      }
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
}

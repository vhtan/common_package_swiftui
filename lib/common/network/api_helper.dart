import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_error.dart';
import 'package:mvvm_cubit/common/network/api_response.dart';
import 'package:mvvm_cubit/common/network/dio_exception.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

abstract mixin class ApiHelper<T> {
  late final T data;

  Future<dynamic> _requestMethodTemplate(
      Future<Response<dynamic>> apiCallback) async {
    logger.d('_requestMethodTemplate1');
    final Response response = await apiCallback;
    logger.d('_requestMethodTemplate2');
    if (response.statusCode.success) {
      final apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.code == ErrorCode.SUCCESS) {
        return apiResponse.detail;
      }
      throw Error();
    } else {
      throw DioExceptions;
    }
  }

  //Generic method template for create item on server
  Future<dynamic> makePostRequest(Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  Future<dynamic> get(Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  //Generic method template for update item on server
  Future<dynamic> makePutRequest(Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  //Generic method template for delete item from server
  Future<dynamic> makeDeleteRequest(
      Future<Response<dynamic>> apiCallback) async {
    return _requestMethodTemplate(apiCallback);
  }

  //Generic method template for getting data from Api
  Future<List<T>> makeGetRequest(Future<Response<dynamic>> apiCallback,
      T Function(Map<String, dynamic> json) getJsonCallback) async {
    final Response response = await apiCallback;

    final List<T> items = List<T>.from(
      json
          .decode(json.encode(response.data))
          .map((item) => getJsonCallback(item)),
    );
    if (response.statusCode.success) {
      return items;
    } else {
      throw DioExceptions;
    }
  }
}

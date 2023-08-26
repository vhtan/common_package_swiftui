import 'package:mvvm_cubit/common/network/dio_interceptor.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    if (ApiConfig.loginResponse != null) {
      // add session in case login success
      ApiConfig.header['Authorization'] = ApiConfig.loginResponse?.session;
    }
    dio
      ..options.baseUrl = ApiConfig.baseUrl
      ..options.headers = ApiConfig.header
      ..options.connectTimeout = ApiConfig.connectionTimeout
      ..options.receiveTimeout = ApiConfig.receiveTimeout
      ..options.responseType = ResponseType.json
      ..interceptors.add(DioInterceptor());
  }
}

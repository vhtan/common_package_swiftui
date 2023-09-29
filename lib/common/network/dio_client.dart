import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/dio_interceptor.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    getOSVersion().then((value) {
      logger.d(value);
      ApiConfig.header['os-version'] = value;
    });
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

  Future<String> getOSVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.systemVersion;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.release;
      }
    } catch (e) {
      logger.d('Error getting device info: $e');
    }
    return 'unsupport';
  }
}

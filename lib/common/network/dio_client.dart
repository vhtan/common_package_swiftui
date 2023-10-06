import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/dio_interceptor.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  DioClient(this.dio, this.secureStorage) {
    updateHeaders();

    dio
      ..options.baseUrl = ApiConfig.baseUrl
      ..options.headers = ApiConfig.header
      ..options.connectTimeout = ApiConfig.connectionTimeout
      ..options.receiveTimeout = ApiConfig.receiveTimeout
      ..options.responseType = ResponseType.json
      ..interceptors.add(DioInterceptor());
  }

  void updateHeaders() async {
    final osVersion = await getOSVersion();
    final loginToken = await getLoginToken();
    ApiConfig.header['os-version'] = osVersion;
    ApiConfig.header['Authorization'] = loginToken;
  }

  Future<String?> getLoginToken() async {
    return await secureStorage.read(key: 'login_token');
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

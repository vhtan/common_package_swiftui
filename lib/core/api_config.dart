import 'dart:io';

import 'package:mvvm_cubit/data/model/auth/login_response.dart';

class ApiConfig {
  ApiConfig._();

  static LoginResponse? loginResponse;
  static const String baseUrl = "http://45.119.213.78:32181/app/api/v1";
  static const Duration receiveTimeout = Duration(milliseconds: 15000);
  static const Duration connectionTimeout = Duration(milliseconds: 15000);
  static const String getTrip = '/trip';
  static const String createTrip = '/create_trip';
  static const String login = '/user/login';
  static const String logout = '/user/logout';
  static Map<String, String?> header = {
    'Content-Type': 'application/json',
    'X-CLIENT-ID': 'vndeli_app',
    'X-API-KEY': 'mgpV4rgh1otK3wfLBgSlpnC8eKAo8m4M',
    'os-type': getOSType(),
  };

  static String getOSType() {
    if (Platform.isIOS) {
      return 'iOS';
    } else if (Platform.isAndroid) {
      return 'Android';
    }
    return 'unsupport';
  }
}

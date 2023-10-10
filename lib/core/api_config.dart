import 'dart:io';

class ApiConfig {
  ApiConfig._();

  static const String baseUrl = "http://45.119.213.78:32181/app/api/v1";
  // static const String baseUrl = "http://localhost:8081/app/api/v1";
  static const Duration receiveTimeout = Duration(milliseconds: 5000);
  static const Duration connectionTimeout = Duration(milliseconds: 5000);
  static const String getTrip = '/routing/detail';
  static const String createTrip = '/create_trip';
  static const String login = '/user/login';
  static const String logout = '/user/logout';
  static const String currencyList = '/currency/list';
  static const String uploadImage = '/sos/image/upload';

  static const String taskPurposeList = '/task-purpose/list';
  static const String vehicleList = '/vehicle/list';
  static const String userSearchList = '/user/search';

  static String arrivedStopPoint(String id) {
    return 'routing/routing-detail/$id/arrived';
  }

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

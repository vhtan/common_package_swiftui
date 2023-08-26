class ApiConfig {
  ApiConfig._();

  static const String baseUrl = "http://45.119.213.78:32181/app/api/v1";
  static const Duration receiveTimeout = Duration(milliseconds: 15000);
  static const Duration connectionTimeout = Duration(milliseconds: 15000);
  static const String listDelivery = '/delivery';
  static const String login = '/user/login';
  static const String logout = '/user/logout';
  static const header = {
    'Content-Type': 'application/json',
    'X-CLIENT-ID': 'vndeli_app',
    'X-API-KEY': 'mgpV4rgh1otK3wfLBgSlpnC8eKAo8m4M',
  };
}

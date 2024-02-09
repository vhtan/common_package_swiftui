import 'dart:io';

class ApiConfig {
  ApiConfig._();

  static const Duration receiveTimeout = Duration(milliseconds: 15000);
  static const Duration connectionTimeout = Duration(milliseconds: 15000);
  static const String getTrip = '/routing/detail';
  static String warningList({
    required bool isOpen,
    required int page,
  }) {
    return '/warning/list?isOpen=$isOpen&page=$page';
  }

  static const String createTrip = '/routing/job';
  static const String tempFormDetails = '/routing/job/detail';
  static const String login = '/user/login';
  static const String logout = '/user/logout';
  static const String currencyList = '/currency/list';
  static const String uploadImage = '/image/upload';

  static const String taskPurposeList = '/task-purpose/list';
  static const String vehicleList = '/vehicle/list';
  static const String userSearchList = '/user/search';
  static const String updatePushToken = '/push-token';
  static const String warningProcess = '/warning/process';
  static const vietMapGetLocation =
      'https://maps.vietmap.vn/api/place/v3?apikey=12963eff8f160538ffd99bf225440c49a0907f7b7eddda45&refid=';
  static const vietMapSearch =
      'https://maps.vietmap.vn/api/autocomplete/v3?apikey=12963eff8f160538ffd99bf225440c49a0907f7b7eddda45&text=';

  static String arrivedStopPoint(String id) {
    return '/routing/routing-detail/$id/arrived';
  }

  static const String handleTempForm = '/routing/job/process';

  static const String totalUnreadNotification =
      '/notification/count?isRead=false';

  static String chattingList(String id) {
    return '/warning/list/chatting?warningId=$id';
  }

  static String warningDetails(String id) {
    return '/warning/$id';
  }

  // paths of sos
  static const String getSOSReasons = '/sos/reason/list';
  static const String submitSOS = '/sos/submit';

  static String notificationList(bool isEmergency, {int? page}) {
    if (isEmergency) {
      return '/notification/list?isRead=false&type=EMERGENCY';
    } else {
      return '/notification/list?page=${page ?? 0}';
    }
  }

  static String readNotification(String id) {
    return '/notification/$id';
  }

  static String tempFormHistories(int page) {
    return '/routing/job/list?page=$page&size=10';
  }

  static String errorReportList(int page) {
    return '/error-report/list?page=$page&size=10';
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

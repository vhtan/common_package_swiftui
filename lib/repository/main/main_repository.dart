import 'package:mvvm_cubit/common/network/list_response/list_response.dart';
import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/main/main_api.dart';
import 'package:mvvm_cubit/data/model/chatting/chat_message_response.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/data/request/check_in/check_in_request.dart';
import 'package:mvvm_cubit/data/request/push_token/push_token_request.dart';
import 'package:mvvm_cubit/data/request/temp_form_process/temp_form_process_request.dart';
import 'package:mvvm_cubit/data/request/warning_process/warning_process_request.dart';

class MainRepository with RepositoryHelper<dynamic> {
  final MainApi _api;

  const MainRepository({required MainApi api}) : _api = api;

  Future<TripResponse?> getTrip() async {
    return _api.getTrip();
  }

  Future<TempFormResponse?> getTempFormDetails() async {
    return _api.getTempFormDetails();
  }

  Future<List<WarningDetailsResponse>> getWarningList(int page) async {
    return _api.getWarningList(page);
  }

  Future<dynamic> submitArrived(CheckInRequest request) async {
    return _api.submitArrived(request);
  }

  Future<dynamic> updatePushToken(PushTokenRequest request) async {
    return _api.updatePushToken(request);
  }

  Future<WarningDetailsResponse> getWarningDetails(String id) async {
    return _api.getWarningDetails(id);
  }

  Future<dynamic> warningProcess(WarningProcessRequest request) async {
    return _api.warningProcess(request);
  }

  Future<dynamic> cancelTempForm() async {
    return _api.cancelTempForm();
  }

  Future<dynamic> closeTempForm(String note) async {
    return _api.closeTempForm(note);
  }

  Future<int> totalUnreadNotification() async {
    return _api.totalUnreadNotification();
  }

  Future<dynamic> readNotification(String id) async {
    return _api.readNotification(id);
  }

  Future<List<NotificationResponse>> getNotificationList(
    bool isEmergency, {
    int? page,
  }) async {
    return _api.getNotificationList(
      isEmergency,
      page: page,
    );
  }

  Future<List<ChatMessageResponse>> getChattingList(String id) async {
    return _api.getChattingList(id);
  }

  Future<ListResponse> getTempFormHistories(int page) async {
    return _api.getTempFormHistories(page);
  }

  Future<List<WarningDetailsResponse>> getWarningHistories(int page) async {
    return _api.getWarningHistories(page);
  }

  Future<dynamic> tempFormProcess(TempFormProcessRequest request) async {
    return _api.tempFormProcess(request);
  }

  Future<ListResponse> getFaultList(int page) async {
    return _api.getFaultList(page);
  }

  Future<ListResponse> getSOSHistories(int page) async {
    return _api.getSOSHistories(page);
  }
}

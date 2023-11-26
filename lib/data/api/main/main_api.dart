import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/network/api_error.dart';
import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/chatting/chat_message_response.dart';
import 'package:mvvm_cubit/data/model/fault/fault_response.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/temp_form_history/temp_form_history_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';
import 'package:mvvm_cubit/data/request/check_in/check_in_request.dart';
import 'package:mvvm_cubit/data/request/push_token/push_token_request.dart';
import 'package:mvvm_cubit/data/request/temp_form_process/temp_form_process_request.dart';
import 'package:mvvm_cubit/data/request/warning_process/warning_process_request.dart';

class MainApi with ApiHelper<dynamic> {
  final DioClient client;

  MainApi({required this.client});

  Future<TripResponse?> getTrip() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.getTrip,
      ),
    );

    if (apiResponse.code == ErrorCode.SUCCESS) {
      return TripResponse.fromJson(apiResponse.detail);
    } else {
      return null;
    }
  }

  Future<TempFormResponse?> getTempFormDetails() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.tempFormDetails,
      ),
    );

    if (apiResponse.code == ErrorCode.SUCCESS) {
      return TempFormResponse.fromJson(apiResponse.detail);
    } else {
      return null;
    }
  }

  Future<List<WarningDetailsResponse>> getWarningList() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.warningList(true),
      ),
    );
    return parseWarningDetailsResponseList(apiResponse.detail);
  }

  Future<dynamic> submitArrived(CheckInRequest request) async {
    return await makePostRequest(
      client.dio.post(
        ApiConfig.arrivedStopPoint(request.id),
        data: request,
      ),
    );
  }

  Future<dynamic> updatePushToken(PushTokenRequest request) async {
    return await makePostRequest(
      client.dio.post(
        ApiConfig.updatePushToken,
        data: request,
      ),
    );
  }

  Future<WarningDetailsResponse> getWarningDetails(String id) async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.warningDetails(id),
      ),
    );
    return WarningDetailsResponse.fromJson(apiResponse.detail);
  }

  Future<dynamic> warningProcess(WarningProcessRequest request) async {
    return await makePostRequest(
      client.dio.post(
        ApiConfig.warningProcess,
        data: request,
      ),
    );
  }

  Future<dynamic> cancelTempForm() async {
    return await makeGetRequest(
      client.dio.post(
        ApiConfig.handleTempForm,
        data: HandleTempFormRequest(action: 'CANCEL'),
      ),
    );
  }

  Future<dynamic> closeTempForm(String note) async {
    return await makeGetRequest(
      client.dio.post(
        ApiConfig.handleTempForm,
        data: HandleTempFormRequest(
          action: 'CLOSE',
          note: note,
        ),
      ),
    );
  }

  Future<List<NotificationResponse>> getNotificationList(
      bool isEmergency) async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.notificationList(isEmergency),
      ),
    );
    return parseNotificationResponseList(apiResponse.detail);
  }

  Future<int> totalUnreadNotification() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.totalUnreadNotification,
      ),
    );
    return apiResponse.detail['totalUnread'];
  }

  Future<dynamic> readNotification(String id) async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.readNotification(id),
      ),
    );
    logger.d(apiResponse);
    return 0;
  }

  Future<List<ChatMessageResponse>> getChattingList(String id) async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.chattingList(id),
      ),
    );
    return parseChatMessageResponseList(apiResponse.detail);
  }

  Future<List<TempFormHistoryResponse>> getTempFormHistories() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.tempFormHistories,
      ),
    );

    return parseTempFormHistoryResponseList(apiResponse.detail['content']);
  }

  Future<List<WarningDetailsResponse>> getWarningHistories() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.warningList(false),
      ),
    );

    return parseWarningDetailsResponseList(apiResponse.detail);
  }

  Future<dynamic> tempFormProcess(TempFormProcessRequest request) async {
    return await makePostRequest(
      client.dio.post(
        ApiConfig.handleTempForm,
        data: request,
      ),
    );
  }

  Future<List<FaultResponse>> getFaultList() async {
    final apiResponse = await makeGetRequest(
      client.dio.get(
        ApiConfig.errorReportList,
      ),
    );

    return parseFaultResponseList(apiResponse.detail['content']);
  }
}

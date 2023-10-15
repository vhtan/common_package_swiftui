import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/main/main_api.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/warning/warning_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/data/request/check_in/check_in_request.dart';
import 'package:mvvm_cubit/data/request/push_token/push_token_request.dart';

class MainRepository with RepositoryHelper<dynamic> {
  final MainApi _api;

  const MainRepository({required MainApi api}) : _api = api;

  Future<TripResponse> getTrip() async {
    return _api.getTrip();
  }

  Future<TempFormResponse> getTempFormDetails() async {
    return _api.getTempFormDetails();
  }

  Future<List<WarningResponse>> getWarningList() async {
    return _api.getWarningList();
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
}

import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';

class MainState {}

class GetWarningListMainState extends MainState {
  List<WarningDetailsResponse> warningList;

  GetWarningListMainState({required this.warningList});
}

class GetTempFormDetailsMainState extends MainState {
  TempFormResponse tempForm;

  GetTempFormDetailsMainState({required this.tempForm});
}

class GetTripMainState extends MainState {
  TripResponse trip;

  GetTripMainState({required this.trip});
}

class DidDeleteTripMainState extends MainState {
  DidDeleteTripMainState();
}

class DidCloseTripMainState extends MainState {
  DidCloseTripMainState();
}

class EmptyTripMainState extends MainState {
  EmptyTripMainState();
}

class EmptyTempFormMainState extends MainState {
  EmptyTempFormMainState();
}

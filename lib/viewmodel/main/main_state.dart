import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';

class MainState {
  final TempFormResponse? tempForm;
  final TripResponse? trip;

  MainState({this.tempForm, this.trip});
}

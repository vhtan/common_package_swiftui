import 'package:location/location.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/warning/warning_response.dart';

class MainState {
  final String? id;
  final TempFormResponse? tempForm;
  final TripResponse? trip;
  final List<WarningResponse>? warningList;
  final LocationData? locationData;
  final String? imagePath;
  final bool canCheckIn;
  final bool canFinish;

  MainState({
    this.id,
    this.tempForm,
    this.trip,
    this.warningList,
    this.locationData,
    this.imagePath,
    bool? canCheckIn,
    bool? canFinish,
  })  : canCheckIn = canCheckIn ?? false,
        canFinish = canCheckIn ?? false;

  MainState copyWith({
    String? id,
    TempFormResponse? tempForm,
    TripResponse? trip,
    List<WarningResponse>? warningList,
    LocationData? locationData,
    String? imagePath,
    bool? canCheckIn,
    bool? canFinish,
  }) {
    return MainState(
      id: id ?? this.id,
      tempForm: tempForm ?? this.tempForm,
      trip: trip ?? this.trip,
      warningList: warningList ?? this.warningList,
      locationData: locationData ?? this.locationData,
      imagePath: imagePath ?? this.imagePath,
      canCheckIn: canCheckIn ?? false,
      canFinish: canFinish ?? false,
    );
  }
}

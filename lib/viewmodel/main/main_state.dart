import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';

class MainState {
  final Trip? pendingTrip;
  final TripResponse? trip;

  MainState({this.pendingTrip, this.trip});
}

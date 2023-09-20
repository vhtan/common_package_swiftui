import 'package:mvvm_cubit/data/model/main/trip.dart';

class MainState {
  final Trip? pendingTrip;
  final Trip? trip;

  MainState({this.pendingTrip, this.trip});
}

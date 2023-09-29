import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';

class AddTripState {
  final Trip? trip;
  final List<String>? reasons;
  final List<String>? vehicleTypes;
  final List<String>? guardGuys;

  late String? reason;
  late String? stopPlace;
  late int? amount;
  late String? vehicle;
  late String? guard;
  late String? licensePlate;

  AddTripState({
    this.trip,
    this.reasons,
    this.vehicleTypes,
    this.guardGuys,
    this.reason,
    this.stopPlace,
    this.amount,
    this.vehicle,
    this.guard,
    this.licensePlate,
  });

  AddTripState copyWith({
    Trip? trip,
    List<String>? reasons,
    List<String>? vehicleTypes,
    List<String>? guardGuys,
    String? reason,
    String? stopPlace,
    int? amount,
    String? vehicle,
    String? guard,
    String? licensePlate,
  }) {
    return AddTripState(
      trip: trip ?? this.trip,
      reasons: reasons ?? this.reasons,
      vehicleTypes: vehicleTypes ?? this.vehicleTypes,
      guardGuys: guardGuys ?? this.guardGuys,
      reason: reason ?? this.reason,
      stopPlace: stopPlace ?? this.stopPlace,
      amount: amount ?? this.amount,
      vehicle: vehicle ?? this.vehicle,
      guard: guard ?? this.guard,
      licensePlate: licensePlate ?? this.licensePlate,
    );
  }

  bool isValid() {
    final flag = (reason?.isNotEmpty == true) &&
        (stopPlace?.isNotEmpty == true) &&
        (amount != null && amount! > 0) &&
        (vehicle?.isNotEmpty == true) &&
        (guard?.isNotEmpty == true) &&
        (licensePlate?.isNotEmpty == true);
    logger.d(flag);
    return flag;
  }
}

import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';

class AddTripState {
  final Trip? trip;
  final List<PurposeResponse>? purposes;
  final List<UserRoleResponse>? drivers;
  final List<UserRoleResponse>? guards;
  final List<VehicleResponse>? vehicles;

  late String? purpose;
  late String? stopPlace;
  late int? amount;
  late String? driver;
  late String? vehicle;
  late String? guard;
  late String? licensePlate;

  AddTripState({
    this.trip,
    this.purposes,
    this.drivers,
    this.guards,
    this.vehicles,
    this.purpose,
    this.stopPlace,
    this.amount,
    this.driver,
    this.vehicle,
    this.guard,
    this.licensePlate,
  });

  AddTripState copyWith({
    Trip? trip,
    List<PurposeResponse>? purposes,
    List<UserRoleResponse>? drivers,
    List<UserRoleResponse>? guards,
    List<VehicleResponse>? vehicles,
    String? purpose,
    String? stopPlace,
    int? amount,
    String? driver,
    String? vehicle,
    String? guard,
    String? licensePlate,
  }) {
    return AddTripState(
      trip: trip ?? this.trip,
      purposes: purposes ?? this.purposes,
      drivers: drivers ?? this.drivers,
      guards: guards ?? this.guards,
      vehicles: vehicles ?? this.vehicles,
      purpose: purpose ?? this.purpose,
      stopPlace: stopPlace ?? this.stopPlace,
      amount: amount ?? this.amount,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
      guard: guard ?? this.guard,
      licensePlate: licensePlate ?? this.licensePlate,
    );
  }

  bool isValid() {
    final flag = (purpose?.isNotEmpty == true) &&
        (stopPlace?.isNotEmpty == true) &&
        (amount != null && amount! > 0) &&
        (driver?.isNotEmpty == true) &&
        (vehicle?.isNotEmpty == true) &&
        (guard?.isNotEmpty == true) &&
        (licensePlate?.isNotEmpty == true);
    return flag;
  }
}

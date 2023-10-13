import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/data/model/map_location/map_location_response.dart';
import 'package:mvvm_cubit/data/model/purpose/purpose_response.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
import 'package:mvvm_cubit/data/model/vehicle/vehicle_response.dart';
import 'package:mvvm_cubit/data/request/add_trip/add_trip_request.dart';

class AddTripState {
  final String? tempForm;
  final List<PurposeResponse>? purposes;
  final List<UserRoleResponse>? drivers;
  final List<UserRoleResponse>? guards;
  final List<VehicleResponse>? vehicles;
  final List<String>? currencies;

  late PurposeResponse? purpose;
  late int? amount;
  late UserRoleResponse? driver;
  late VehicleResponse? vehicle;
  late UserRoleResponse? guard;
  late MapLocationResponse? location;
  late String? currency;

  AddTripState({
    this.tempForm,
    this.purposes,
    this.drivers,
    this.guards,
    this.vehicles,
    this.currencies,
    this.purpose,
    this.amount,
    this.driver,
    this.vehicle,
    this.guard,
    this.location,
    this.currency,
  });

  AddTripState copyWith({
    String? tempForm,
    List<PurposeResponse>? purposes,
    List<UserRoleResponse>? drivers,
    List<UserRoleResponse>? guards,
    List<VehicleResponse>? vehicles,
    List<String>? currencies,
    PurposeResponse? purpose,
    int? amount,
    UserRoleResponse? driver,
    VehicleResponse? vehicle,
    UserRoleResponse? guard,
    String? licensePlate,
    MapLocationResponse? location,
    String? currency,
  }) {
    return AddTripState(
      tempForm: tempForm ?? this.tempForm,
      purposes: purposes ?? this.purposes,
      drivers: drivers ?? this.drivers,
      guards: guards ?? this.guards,
      vehicles: vehicles ?? this.vehicles,
      purpose: purpose ?? this.purpose,
      amount: amount ?? this.amount,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
      guard: guard ?? this.guard,
      location: location ?? this.location,
      currency: currency ?? this.currency,
      currencies: currencies ?? this.currencies,
    );
  }

  bool isValid() {
    final flag = (purpose?.id?.isNotEmpty == true) &&
        (amount != null && amount! > 0) &&
        (driver?.id?.isNotEmpty == true) &&
        (vehicle?.id?.isNotEmpty == true) &&
        (guard?.id?.isNotEmpty == true) &&
        (currency?.isNotEmpty == true);
    logger.d(purpose?.id);
    return flag;
  }

  AddTripRequest toRequest() {
    return AddTripRequest(
      purposeId: purpose?.id ?? '',
      stopPointAddress: location?.address ?? '',
      latitude: location?.lat ?? 0,
      longitude: location?.lng ?? 0,
      quantity: double.parse(amount?.toString() ?? '0'),
      currency: currency ?? '',
      driverId: driver?.id ?? '',
      bodyguardId: guard?.id ?? '',
      vehicleId: vehicle?.id ?? '',
      note: 'note',
    );
  }
}

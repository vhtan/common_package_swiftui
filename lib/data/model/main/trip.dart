import 'package:json_annotation/json_annotation.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  @JsonKey(name: "reason")
  late String? reason;

  @JsonKey(name: "stopPlace")
  late String? stopPlace;

  @JsonKey(name: "amount")
  late int? amount;

  @JsonKey(name: "vehicle")
  late String? vehicle;

  @JsonKey(name: "guard")
  late String? guard;

  @JsonKey(name: "licensePlates")
  late String? licensePlates;

  Trip({
    this.reason,
    this.stopPlace,
    this.amount,
    this.vehicle,
    this.guard,
    this.licensePlates,
  });

  Trip copyWith({
    String? reason,
    String? stopPlace,
    int? amount,
    String? vehicle,
    String? guard,
    String? licensePlates,
  }) {
    return Trip(
      reason: reason ?? this.reason,
      stopPlace: stopPlace ?? this.stopPlace,
      amount: amount ?? this.amount,
      vehicle: vehicle ?? this.vehicle,
      guard: guard ?? this.guard,
      licensePlates: licensePlates ?? this.licensePlates,
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  Map<String, dynamic> toJson() => _$TripToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:mvvm_cubit/data/model/main/duty.dart';

part 'trip.g.dart';

@JsonSerializable()
class Trip {
  final String title;
  @JsonKey(name: "duties")
  final List<PickUpDuty> duties;

  Trip({required this.title, required this.duties});

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  Map<String, dynamic> toJson() => _$TripToJson(this);
}

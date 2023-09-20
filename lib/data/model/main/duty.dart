import 'package:json_annotation/json_annotation.dart';

part 'duty.g.dart';

abstract class Duty {
  late int id;
  late String title;
  late String buttonTitle;
}

@JsonSerializable()
class PickUpDuty implements Duty {
  PickUpDuty({
    required this.id,
    required this.title,
    required this.buttonTitle,
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  int id;
  @override
  String title;
  @override
  String buttonTitle;
  final String name;
  final String address;
  final String phone;

  factory PickUpDuty.fromJson(Map<String, dynamic> json) =>
      _$PickUpDutyFromJson(json);

  Map<String, dynamic> toJson() => _$PickUpDutyToJson(this);
}

@JsonSerializable()
class DeliveryDuty implements Duty {
  DeliveryDuty({
    required this.id,
    required this.title,
    required this.buttonTitle,
    required this.requestFormId,
    required this.totalAmount,
    required this.type,
  });
  @override
  int id;
  @override
  String title;
  @override
  String buttonTitle;
  final String requestFormId;
  final String totalAmount;
  final String type;

  factory DeliveryDuty.fromJson(Map<String, dynamic> json) =>
      _$DeliveryDutyFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryDutyToJson(this);
}

import 'package:uuid/uuid.dart';

class SOSSubmitRequest {
  String? vehicleId;
  String? reasonId;
  String? imgName;
  String? sosMessage;
  SOSType? type;
  String? requestId;
  int? requestTime;

  SOSSubmitRequest({
    this.reasonId,
    this.vehicleId,
    this.imgName,
    this.sosMessage,
    this.type,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;
  Map<String, dynamic> toParams() {
    return {
      "reasonId": reasonId,
      "imgName": imgName,
      "sosMessage": sosMessage,
      "requestId": requestId,
      "requestTime": requestTime
    };
  }
}

enum SOSType { robbed, arrested, other }

import 'package:uuid/uuid.dart';

class SOSSubmitRequest {
  late final String? reasonId;
  late final String? imgName;
  late final String? sosMessage;
  late final String? requestId;
  late final int? requestTime;
  SOSSubmitRequest({
    this.reasonId,
    this.imgName,
    this.sosMessage,
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

class SOSRobberSubmitRequest {
  late final String? vehicleId;
  late final String? imgName;
  late final String? message;
  late final String? requestId;
  late final int? requestTime;
  SOSRobberSubmitRequest({
    this.vehicleId,
    this.imgName,
    this.message,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;
  Map<String, dynamic> toParams() {
    return {
      "vehicleId": vehicleId,
      "imgName": imgName,
      "message": message,
      "robbed": true,
      "requestId": requestId,
      "requestTime": requestTime
    };
  }
}

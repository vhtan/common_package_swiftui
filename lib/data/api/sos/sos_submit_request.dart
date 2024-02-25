import 'package:uuid/uuid.dart';

class SOSSubmitRequest {
  String vehicleId;
  String? reasonId;
  String? imgName;
  String? sosMessage;
  SOSType? type;
  String? requestId;
  int? requestTime;

  SOSSubmitRequest({
    this.reasonId,
    required this.vehicleId,
    this.imgName,
    this.sosMessage,
    required this.type,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;
  Map<String, dynamic> toParams() {
    return {
      "reasonId": reasonId,
      "imgName": imgName,
      "sosMessage": sosMessage,
      "requestId": requestId,
      "requestTime": requestTime,
      "type": type?.value,
      "vehicleId": vehicleId,
    };
  }
}

enum SOSType {
  robbed,
  arrested,
  other;

  String? get value {
    switch (this) {
      case SOSType.robbed:
        return 'robbed';
      case SOSType.arrested:
        return 'arrested';
      default:
        return null;
    }
  }
}

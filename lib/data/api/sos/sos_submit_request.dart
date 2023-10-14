import 'dart:ffi';

class SOSSubmitRequest {
  late final String reasonId;
  late final String imgUrl;
  late final String sosMessage;
  late final String requestId;
  late final Long requestTime;
  Map<String, dynamic> toParams() {
    return {
      "reasonId": reasonId,
      "imgUrl": imgUrl,
      "sosMessage": sosMessage,
      "requestId": requestId,
      "requestTime": requestTime
    };
  }
}

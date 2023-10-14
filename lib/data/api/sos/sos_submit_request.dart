
class SOSSubmitRequest {
  late final String? reasonId;
  late final String? imgUrl;
  late final String? sosMessage;
  late final String? requestId;
  late final int? requestTime;
  SOSSubmitRequest({this.reasonId, this.imgUrl, this.sosMessage, this.requestId, this.requestTime });
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

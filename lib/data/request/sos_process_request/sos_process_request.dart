import 'package:uuid/uuid.dart';

class SOSProcessRequest {
  final String sosId;
  final String message;
  final String requestId;
  final int requestTime;

  SOSProcessRequest({
    required this.sosId,
    required this.message,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return {
      'sosId': sosId,
      'message': message,
      'requestId': requestId,
      'requestTime': requestTime,
      'action': 'chat'
    };
  }
}

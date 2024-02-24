import 'package:freezed_annotation/freezed_annotation.dart';
part 'push_notification.g.dart';
part 'push_notification.freezed.dart';

@freezed
abstract class PushNotification with _$PushNotification {
  const factory PushNotification({
    String? id,
    PushNotificationType? type,
  }) = _PushNotification;

  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationFromJson(json);
}

enum PushNotificationType { warning, routing, routingjobtemp, sos }

import 'package:freezed_annotation/freezed_annotation.dart';
part 'notification_response.g.dart';
part 'notification_response.freezed.dart';

@freezed
abstract class NotificationResponse with _$NotificationResponse {
  const factory NotificationResponse({
    String? id,
    String? title,
    String? message,
    int? dateCreated,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}

List<NotificationResponse> parseNotificationResponseList(
    List<dynamic> parsedList) {
  return parsedList
      .map(
          (json) => NotificationResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}

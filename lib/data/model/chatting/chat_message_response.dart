import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/user_role/user_role_response.dart';
part 'chat_message_response.g.dart';
part 'chat_message_response.freezed.dart';

@freezed
abstract class ChatMessageResponse with _$ChatMessageResponse {
  const factory ChatMessageResponse({
    String? id,
    String? text,
    int? dateCreated,
    UserRoleResponse? userCreated,
  }) = _ChatMessageResponse;

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageResponseFromJson(json);
}

List<ChatMessageResponse> parseChatMessageResponseList(
    List<dynamic> parsedList) {
  return parsedList
      .map((json) => ChatMessageResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}

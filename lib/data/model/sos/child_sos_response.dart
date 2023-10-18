import 'package:freezed_annotation/freezed_annotation.dart';
part 'child_sos_response.g.dart';
part 'child_sos_response.freezed.dart';

@freezed
abstract class ChildSOSResponse with _$ChildSOSResponse {
  const factory ChildSOSResponse({
    String? id,
    String? userDeletedId,
    String? requestId,
    String? name,
    int? isActive,
    int? dateCreated,
    int? requestTime,
    int? dateDeleted,
  }) = _ChildSOSResponse;

  factory ChildSOSResponse.fromJson(Map<String, dynamic> json) =>
      _$ChildSOSResponseFromJson(json);
}

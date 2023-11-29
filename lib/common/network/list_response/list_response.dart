import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_response.g.dart';
part 'list_response.freezed.dart';

@freezed
abstract class ListResponse with _$ListResponse {
  factory ListResponse({
    List<dynamic>? content,
    int? totalPages,
    int? totalElements,
    bool? first,
    bool? last,
  }) = _ListResponse;

  factory ListResponse.fromJson(Map<String, dynamic> json) =>
      _$ListResponseFromJson(json);
}

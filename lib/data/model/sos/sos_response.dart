import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/sos/child_sos_response.dart';
part 'sos_response.g.dart';
part 'sos_response.freezed.dart';

@freezed
abstract class SOSResponse with _$SOSResponse {
  const factory SOSResponse({
    List<ChildSOSResponse>? detail,
  }) = _SOSResponse;

  factory SOSResponse.fromJson(Map<String, dynamic> json) =>
      _$SOSResponseFromJson(json);
}

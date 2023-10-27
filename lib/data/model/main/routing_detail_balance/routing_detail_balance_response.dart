import 'package:freezed_annotation/freezed_annotation.dart';

part 'routing_detail_balance_response.g.dart';
part 'routing_detail_balance_response.freezed.dart';

@freezed
abstract class RoutingDetailBalanceResponse
    with _$RoutingDetailBalanceResponse {
  const factory RoutingDetailBalanceResponse({
    String? id,
    String? currency,
    double? quantity,
    String? attribute,
  }) = _RoutingDetailBalanceResponse;

  factory RoutingDetailBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$RoutingDetailBalanceResponseFromJson(json);
}

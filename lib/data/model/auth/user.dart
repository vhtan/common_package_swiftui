import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:material_text_fields/utils/extensions.dart';

part 'user.g.dart';

@immutable
@JsonSerializable()
class User {
  const User([this.phone, this.password, this.session]);
  final String? phone;
  final String? password;
  final String? session;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool isValid() {
    return phone.isNotNullOrEmpty() && password.isNotNullOrEmpty();
  }
}

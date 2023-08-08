import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:material_text_fields/utils/extensions.dart';

part 'user.g.dart';

@immutable
@JsonSerializable()
class User {
  const User({
    this.id,
    required this.phone,
    required this.password,
  });

  final int? id;
  final String phone;
  final String password;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool isValid() {
    print('phone $phone');
    print('password $password');
    return phone.isNotNullOrEmpty() && password.isNotNullOrEmpty();
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'user.g.dart';

@immutable
@JsonSerializable()
class User {
  const User({
    this.id,
    required this.name,
    required this.email,
  });

  final int? id;
  final String name;
  final String email;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

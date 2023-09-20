// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_trip_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AddTripResponse _$AddTripResponseFromJson(Map<String, dynamic> json) {
  return _AddTripResponse.fromJson(json);
}

/// @nodoc
mixin _$AddTripResponse {
  String? get title => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddTripResponseCopyWith<AddTripResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddTripResponseCopyWith<$Res> {
  factory $AddTripResponseCopyWith(
          AddTripResponse value, $Res Function(AddTripResponse) then) =
      _$AddTripResponseCopyWithImpl<$Res, AddTripResponse>;
  @useResult
  $Res call({String? title});
}

/// @nodoc
class _$AddTripResponseCopyWithImpl<$Res, $Val extends AddTripResponse>
    implements $AddTripResponseCopyWith<$Res> {
  _$AddTripResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AddTripResponseCopyWith<$Res>
    implements $AddTripResponseCopyWith<$Res> {
  factory _$$_AddTripResponseCopyWith(
          _$_AddTripResponse value, $Res Function(_$_AddTripResponse) then) =
      __$$_AddTripResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? title});
}

/// @nodoc
class __$$_AddTripResponseCopyWithImpl<$Res>
    extends _$AddTripResponseCopyWithImpl<$Res, _$_AddTripResponse>
    implements _$$_AddTripResponseCopyWith<$Res> {
  __$$_AddTripResponseCopyWithImpl(
      _$_AddTripResponse _value, $Res Function(_$_AddTripResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
  }) {
    return _then(_$_AddTripResponse(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AddTripResponse implements _AddTripResponse {
  const _$_AddTripResponse({this.title});

  factory _$_AddTripResponse.fromJson(Map<String, dynamic> json) =>
      _$$_AddTripResponseFromJson(json);

  @override
  final String? title;

  @override
  String toString() {
    return 'AddTripResponse(title: $title)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AddTripResponse &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AddTripResponseCopyWith<_$_AddTripResponse> get copyWith =>
      __$$_AddTripResponseCopyWithImpl<_$_AddTripResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AddTripResponseToJson(
      this,
    );
  }
}

abstract class _AddTripResponse implements AddTripResponse {
  const factory _AddTripResponse({final String? title}) = _$_AddTripResponse;

  factory _AddTripResponse.fromJson(Map<String, dynamic> json) =
      _$_AddTripResponse.fromJson;

  @override
  String? get title;
  @override
  @JsonKey(ignore: true)
  _$$_AddTripResponseCopyWith<_$_AddTripResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

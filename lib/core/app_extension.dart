import 'dart:convert';
import 'dart:ffi';

import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String get getGenderWidget {
    if (this == "male") return AppAsset.male;
    return AppAsset.female;
  }

  String get toCapital {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension IntegetExtension on int? {
  bool get success {
    if (this == 200 || this == 201 || this == 204) {
      return true;
    }
    return false;
  }

  bool get tokenExpired {
    return this == 401;
  }
}

extension GeneralExtension<T> on T {
  bool get isEnum {
    final split = toString().split('.');
    return split.length > 1 && split[0] == runtimeType.toString();
  }

  String get getEnumString => toString().split('.').last.toCapital;
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<E> mapWithIndex<E>(E Function(int index, T value) f) {
    return Iterable.generate(length).map((i) => f(i, elementAt(i)));
  }
}

extension MapExtension on Map {
  String get format {
    if (isEmpty) {
      return "";
    } else {
      var firstKey = entries.first.key;
      var mapValues = entries.first.value;
      return "?$firstKey=$mapValues";
    }
  }
}

//Helper functions
void pop(BuildContext context, int returnedLevel) {
  for (var i = 0; i < returnedLevel; ++i) {
    Navigator.pop(context, true);
  }
}

extension Dimension on Double {
  static const double radiusDefault = 10.0;
  static const double borderWidthDefault = 2.0;
  static const double titleFontSize = 20;
  static const double textFontSize = 16;
  static const double menuIconSize = 30;
}

// App colors
extension AppColors on Color {
  static const Color primary = Color(0xFF0041A8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFF5D04D);
  static const Color warningHigh = Color(0xFFED8422);
  static const Color warningRisk = Color(0xFFED5C22);
  static const Color red = Color(0xFFFF0000);
  static const Color border = Color(0x88000000);
  static const Color textDefaultLight = Color(0x86757373);
  static const Color textDefault = Color(0xFF000000);
  static const Color menuSelected = Color(0xFF000000);
  static const Color notificationUnread = Color(0xFFFFF7E9);
  static const Color notificationRead = Color(0xFFFFFFFF);
}

extension DateTimeFormatCustom on DateTime {
  String toStringFormat({String format = 'kk:mm, dd-MM-yyyy'}) {
    return DateFormat(format).format(this);
  }
}

extension StoreKey on String {
  // Store key
  static const loginToken = 'login_token';
  static const roleCode = 'role_code';
  static const userData = 'user_data';
}

extension ObjectToJsonExtension on Object? {
  String toJsonString() {
    if (this == null) {
      return '{}'; // You can choose a default representation for null.
    }
    final jsonString = json.encode(this);
    return jsonString;
  }
}

extension IntToDateTime on int {
  DateTime get dateFromSecond =>
      DateTime.fromMillisecondsSinceEpoch(this * 1000);

  DateTime get dateFromMillisecond => DateTime.fromMillisecondsSinceEpoch(this);
}

import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:flutter/material.dart';

import 'app_extension.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightAppTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white),
      color: AppColors.primary,
      centerTitle: true,
    ),
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.error, width: 1.0),
        borderRadius: BorderRadius.all(
          Radius.circular(Dimension.radiusDefault),
        ),
      ),
    ),
    inputDecorationTheme: inputTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
      ),
    ),
    filledButtonTheme: filledButtonTheme,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.error,
    ),
    fontFamily: AppString.appFont,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textDefault,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: AppColors.textDefaultLight),
        ),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(Dimension.radiusDefault)),
        side: BorderSide(color: Colors.grey, width: 2),
      ),
      dialHandColor: AppColors.error,
      hourMinuteColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? AppColors.error
              : AppColors.textDefault),
      hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? AppColors.textDefault
              : AppColors.textDefaultLight),
      dayPeriodBorderSide: const BorderSide(color: AppColors.textDefaultLight),
      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimension.radiusDefault),
      ),
      dayPeriodColor: Colors.transparent,
      dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? AppColors.error
              : AppColors.textDefault),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimension.radiusDefault),
        side: const BorderSide(color: AppColors.textDefault),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimension.radiusDefault),
          topRight: Radius.circular(Dimension.radiusDefault),
        ),
      ),
    ),
  );
}

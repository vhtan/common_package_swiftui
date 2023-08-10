import 'package:flutter/material.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';

import 'app_extension.dart';

const headLine6 = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: AppColors.textDefault,
  overflow: TextOverflow.ellipsis,
);

const headLine5 = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

const headLine4 = TextStyle(
  fontSize: Dimension.textFontSize,
  fontWeight: FontWeight.w700,
  overflow: TextOverflow.ellipsis,
);

const headLine3 = TextStyle(
  fontSize: Dimension.textFontSize,
  fontWeight: FontWeight.w800,
  overflow: TextOverflow.ellipsis,
);

const headLine1 =
    TextStyle(fontSize: Dimension.titleFontSize, fontWeight: FontWeight.w900);

const focusedBorder = OutlineInputBorder(
  borderSide:
      BorderSide(color: AppColors.border, width: Dimension.borderWidthDefault),
  borderRadius: BorderRadius.all(Radius.circular(Dimension.radiusDefault)),
);

const enabledBorder = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.border, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(Dimension.radiusDefault)),
);

const errorBorder = OutlineInputBorder(
  borderSide:
      BorderSide(width: Dimension.borderWidthDefault, color: AppColors.error),
  borderRadius: BorderRadius.all(Radius.circular(Dimension.radiusDefault)),
);

const inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(Dimension.radiusDefault)),
  borderSide: BorderSide(color: AppColors.error),
);

const focusedErrorBorder = OutlineInputBorder(
  borderSide:
      BorderSide(width: Dimension.borderWidthDefault, color: AppColors.error),
  borderRadius: BorderRadius.all(
    Radius.circular(Dimension.radiusDefault),
  ),
);

final inputTextTheme = FilledOrOutlinedTextTheme(
  radius: 8,
  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
  errorStyle: const TextStyle(
      color: AppColors.error,
      fontSize: Dimension.textFontSize,
      fontWeight: FontWeight.w700),
  fillColor: Colors.transparent,
  prefixIconColor: AppColors.primary,
  enabledColor: AppColors.textDefaultLight,
  focusedColor: AppColors.primary,
  floatingLabelStyle: const TextStyle(
      color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14),
  width: 1.5,
  labelStyle: const TextStyle(
      fontSize: Dimension.textFontSize, color: AppColors.textDefault),
);

final filledButtonTheme = FilledButtonThemeData(
    style: ButtonStyle(
  backgroundColor: MaterialStateProperty.all(AppColors.primary),
  shape: MaterialStateProperty.all(
    const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(Dimension.radiusDefault)),
    ),
  ),
));

const textDefault = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: AppColors.textDefault,
  overflow: TextOverflow.ellipsis,
);

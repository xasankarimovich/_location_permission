// app_text_style.dart
import 'package:flutter/material.dart';
import 'package:lesson_72_permission/utils/extension/extension.dart';
import '../color/app_color.dart';

class AppTextStyle {
  // yupqa
  static TextStyle thin = TextStyle(
    fontSize: 16.h,
    fontWeight: FontWeight.w300,
    color: AppColors.c000000,
  );

  // oddiy
  static TextStyle regular = TextStyle(
    fontSize: 16.h,
    fontWeight: FontWeight.w400,
    color: AppColors.c000000,
  );

  // o‘rtacha
  static TextStyle medium = TextStyle(
    fontSize: 16.h,
    fontWeight: FontWeight.w500,
    color: AppColors.c000000,
  );

  // qalin
  static TextStyle bold = TextStyle(
    fontSize: 16.h,
    fontWeight: FontWeight.w600,
    color: AppColors.c000000,
  );

  // yarim qalin
  static TextStyle semiBold = TextStyle(
    fontSize: 24.h,
    fontWeight: FontWeight.w700,
    color: AppColors.c000000,
  );
}

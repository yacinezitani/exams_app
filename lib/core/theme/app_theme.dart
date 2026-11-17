import 'package:exam_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness b) => ThemeData(
        useMaterial3: true,
        brightness: b,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryFor(b),
          brightness: b,
        ).copyWith(primary: AppColors.primaryFor(b)),
        scaffoldBackgroundColor: AppColors.backgroundFor(b),
        fontFamily: 'Inter',
        fontFamilyFallback: const ['IBMPlexSansArabic'],
      );
}

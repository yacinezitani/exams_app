import 'package:flutter/material.dart';

/// Colour-free tokens. Pair with `.copyWith(color: AppColors.x(context))`.
/// Poppins = headings, Inter = body. IBM Plex Sans Arabic supplies Arabic glyphs.
abstract final class AppTextStyles {
  static const _fallback = ['IBMPlexSansArabic'];

  // Poppins
  static const display32 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 32, height: 40 / 32, fontWeight: FontWeight.w600);
  static const heading26 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 26, height: 34 / 26, fontWeight: FontWeight.w600);
  static const brand20 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 20, fontWeight: FontWeight.w600);
  static const goalNumber18 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 18, fontWeight: FontWeight.w600);
  static const month16 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 16, fontWeight: FontWeight.w600);
  static const card22 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 22, height: 30 / 22, fontWeight: FontWeight.w500);

  // Inter
  static const body16 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w400);
  static const title16 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 16, fontWeight: FontWeight.w600);
  static const button16 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 16, fontWeight: FontWeight.w600);
  static const label14 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 14, fontWeight: FontWeight.w600);
  static const body14 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400);
  static const overline12 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 12, letterSpacing: 12 * 0.08, fontWeight: FontWeight.w600);
  static const caption12 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 12, fontWeight: FontWeight.w600);
  static const day15 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 15, fontWeight: FontWeight.w400);
  static const day15Selected = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 15, fontWeight: FontWeight.w700);

  // Home
  static const countdown44 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 44, height: 48 / 44, fontWeight: FontWeight.w600);
  static const countdownUnit18 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 18, fontWeight: FontWeight.w500);
  static const greeting24 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 24, height: 32 / 24, fontWeight: FontWeight.w600);
  static const section18 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 18, height: 26 / 18, fontWeight: FontWeight.w600);
  static const statValue26 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 26, height: 34 / 26, fontWeight: FontWeight.w600);
  static const tile15 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 15, fontWeight: FontWeight.w600);
  static const empty20 = TextStyle(fontFamily: 'Poppins', fontFamilyFallback: _fallback, fontSize: 20, height: 28 / 20, fontWeight: FontWeight.w600);
  static const date14 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 14, fontWeight: FontWeight.w500);
  static const unit14 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 14, fontWeight: FontWeight.w500);
  static const label13 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 13, fontWeight: FontWeight.w600);
  static const body13 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 13, fontWeight: FontWeight.w500);
  static const body12 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 12, fontWeight: FontWeight.w400);
  static const body15 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 15, height: 22 / 15, fontWeight: FontWeight.w400);
  static const navLabel12 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w500);
  static const navLabelSelected12 = TextStyle(fontFamily: 'Inter', fontFamilyFallback: _fallback, fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w700);

  /// Uppercase labels use tracking in Latin scripts only; letter-spacing
  /// breaks the joined letterforms of Arabic.
  static TextStyle overline(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar'
          ? overline12.copyWith(letterSpacing: 0)
          : overline12;
}

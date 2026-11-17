import 'package:flutter/material.dart';

/// Context-aware palette. Light values come from the design frames; dark values
/// from frames 04D / 10D / 14D.
abstract final class AppColors {
  static const _light = _Palette(
    background: Color(0xFFF6F7FB),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF141726),
    textMuted: Color(0xFF4B5163),
    primary: Color(0xFF4F46E5),
    onPrimary: Color(0xFFFFFFFF),
    primaryText: Color(0xFF4338CA),
    primarySoft: Color(0xFFEEEDFD),
    primarySoftText: Color(0xFF3730A3),
    border: Color(0xFFE4E6EF),
    dotInactive: Color(0xFFC9CCD8),
    success: Color(0xFF15803D),
    successSoft: Color(0xFFE3F5E8),
    successBorder: Color(0xFFBFE5CB),
    successText: Color(0xFF116632),
    miss: Color(0xFFD13F38),
    missSoft: Color(0xFFF3C9C6),
    weekday: Color(0xFF5F6676),
    track: Color(0xFFECEDF3),
    streak: Color(0xFFB45309),
    onPrimaryMuted: Color(0xFFE0DEFF),
  );

  static const _dark = _Palette(
    background: Color(0xFF0F1220),
    surface: Color(0xFF191D2E),
    textPrimary: Color(0xFFF2F3F8),
    textMuted: Color(0xFFA9AEC2),
    primary: Color(0xFF4F46E5),
    onPrimary: Color(0xFFFFFFFF),
    primaryText: Color(0xFFA9A4FF),
    primarySoft: Color(0xFF2A2D52),
    primarySoftText: Color(0xFFE0DEFF),
    border: Color(0xFF2A2F45),
    dotInactive: Color(0xFF4B5163),
    success: Color(0xFF4ADE80),
    successSoft: Color(0xFF12301F),
    successBorder: Color(0xFF1E4D33),
    successText: Color(0xFF86EFAC),
    miss: Color(0xFFFF8A80),
    missSoft: Color(0xFF5A2B30),
    weekday: Color(0xFFA9AEC2),
    track: Color(0xFF2A2F45),
    streak: Color(0xFFF5B454),
    onPrimaryMuted: Color(0xFFE0DEFF),
  );

  static _Palette _of(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? _dark : _light;

  /// For [ThemeData] construction only, where no [BuildContext] exists yet.
  static Color backgroundFor(Brightness b) =>
      (b == Brightness.dark ? _dark : _light).background;
  static Color primaryFor(Brightness b) =>
      (b == Brightness.dark ? _dark : _light).primary;

  static Color background(BuildContext c) => _of(c).background;
  static Color surface(BuildContext c) => _of(c).surface;
  static Color textPrimary(BuildContext c) => _of(c).textPrimary;
  static Color textMuted(BuildContext c) => _of(c).textMuted;
  static Color primary(BuildContext c) => _of(c).primary;
  static Color onPrimary(BuildContext c) => _of(c).onPrimary;
  static Color primaryText(BuildContext c) => _of(c).primaryText;
  static Color primarySoft(BuildContext c) => _of(c).primarySoft;
  static Color primarySoftText(BuildContext c) => _of(c).primarySoftText;
  static Color border(BuildContext c) => _of(c).border;
  static Color dotInactive(BuildContext c) => _of(c).dotInactive;
  static Color success(BuildContext c) => _of(c).success;
  static Color successSoft(BuildContext c) => _of(c).successSoft;
  static Color successBorder(BuildContext c) => _of(c).successBorder;
  static Color successText(BuildContext c) => _of(c).successText;
  static Color miss(BuildContext c) => _of(c).miss;
  static Color missSoft(BuildContext c) => _of(c).missSoft;
  static Color weekday(BuildContext c) => _of(c).weekday;
  static Color track(BuildContext c) => _of(c).track;
  static Color streak(BuildContext c) => _of(c).streak;
  static Color onPrimaryMuted(BuildContext c) => _of(c).onPrimaryMuted;
}

class _Palette {
  const _Palette({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textMuted,
    required this.primary,
    required this.onPrimary,
    required this.primaryText,
    required this.primarySoft,
    required this.primarySoftText,
    required this.border,
    required this.dotInactive,
    required this.success,
    required this.successSoft,
    required this.successBorder,
    required this.successText,
    required this.miss,
    required this.missSoft,
    required this.weekday,
    required this.track,
    required this.streak,
    required this.onPrimaryMuted,
  });

  final Color background,
      surface,
      textPrimary,
      textMuted,
      primary,
      onPrimary,
      primaryText,
      primarySoft,
      primarySoftText,
      border,
      dotInactive,
      success,
      successSoft,
      successBorder,
      successText,
      miss,
      missSoft,
      weekday,
      track,
      streak,
      onPrimaryMuted;
}

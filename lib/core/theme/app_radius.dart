import 'package:flutter/painting.dart';

abstract final class AppRadius {
  static const double controlValue = 16;
  static const double cardValue = 24;
  /// Small marks only (logo, goal badge); not for buttons or inputs.
  static const double markValue = 12;

  static const control = BorderRadius.all(Radius.circular(controlValue));
  static const card = BorderRadius.all(Radius.circular(cardValue));
  static const mark = BorderRadius.all(Radius.circular(markValue));
}

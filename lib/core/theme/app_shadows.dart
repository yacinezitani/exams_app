import 'package:flutter/painting.dart';

abstract final class AppShadows {
  static const soft = [
    BoxShadow(color: Color(0x0D141726), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0F141726), blurRadius: 20, offset: Offset(0, 6)),
  ];
  static const elevated = [
    BoxShadow(color: Color(0x0A141726), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x1F141726), blurRadius: 48, offset: Offset(0, 20)),
  ];
  static const primaryGlow = [
    BoxShadow(color: Color(0x404F46E5), blurRadius: 24, offset: Offset(0, 8)),
  ];
}

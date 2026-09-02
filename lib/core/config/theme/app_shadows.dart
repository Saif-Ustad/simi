import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  /// Standard card shadow.
  static const card = BoxShadow(
    color: Color(0x0D000000), // 5%
    blurRadius: 15,
    offset: Offset(0, 4),
  );

  /// Floating action shadow.
  static const floating = BoxShadow(
    color: Color(0x14000000), // 8%
    blurRadius: 20,
    offset: Offset(0, 8),
  );
}
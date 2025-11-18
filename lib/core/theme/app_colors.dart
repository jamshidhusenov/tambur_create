import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xff12237f);
  static const Color primaryDark = Color(0xFFFF3300);
  static const Color primaryLight = Color(0xFFFF8B3A);

  // Background Colors
  static const Color background = Color(0xFFF2F2F2);
  static const Color white = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C1C1C);
  static const Color textSecondary = Color(0xFF8F8F8F);
  static const Color textHint = Color(0xFFA3A3A3);
  static const Color textGreen = Color(0xFF08D010);
  static const Color green = Color(0xFF54C81A);
  static const Color blue = Color(0xFF007AFF);
  // green

  static const Color black = Color(0xFF000000);

  static const Color orangeButton = Color(0xFFEEBA00);
  static const Color redButton = Color(0xFFFF3300);
  static const Color borderColor = Color.fromARGB(255, 44, 42, 42);

  static const Color transparent = Colors.transparent;
  static const Color blackTransparent = Color(0x12000000); // Colors.black12

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFFFF8B3A),
    Color(0xFFFC7416),
    Color(0xFFFC7416),
    Color(0xFFFC7416),
    Color(0xFFFF8B3A),
  ];

  static const Gradient buttonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffff821a), Color(0xffff3300)],
  );

  static const Color red = Colors.red;

  static const Color grey = Color(0xFFA3A3A3);
  static const Color grey200 = Color(0xffEEEEFF);
  static const Color error = Color(0xFFFF3300);

  static const LinearGradient linearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFF8B3A), // #FF8B3A
      Color(0xFFFC7416), // #FC7416
      Color(0xFFFC7416), // #FC7416
      Color(0xFFFC7416), // #FC7416
      Color(0xFFFF8B3A), // #FF8B3A
    ],
    stops: [0.0, 0.2, 0.5, 0.8, 1.0],
  );
}

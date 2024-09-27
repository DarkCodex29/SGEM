import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF0D45FF); // Azul primario
  static const Color secondaryColor = Color(0xFFBB7900); // Color secundario
  static const Color tertiaryColor = Color(0xFF0066E6); // Tercer color
  static const Color alternateColor = Color(0xFFe0e3e7); // Alternativo

  // Utility Colors
  static const Color primaryText = Color(0xFF14181b); // Texto principal
  static const Color secondaryText = Color(0xFF4a5757); // Texto secundario
  static const Color primaryBackground = Color(0xFFf1f4f8); // Fondo principal
  static const Color secondaryBackground =
      Color(0xFFFFFFFF); // Fondo secundario

  // Accent Colors
  static const Color accent1 = Color(0xff520d45ff); // Primer acento
  static const Color accent2 = Color(0xff5bb7900); // Segundo acento
  static const Color accent3 = Color(0xff4d006e6); // Tercer acento
  static const Color accent4 = Color(0xffccffffff); // Cuarto acento

  // Semantic Colors
  static const Color successColor = Color(0xFF249689); // Éxito
  static const Color errorColor = Color(0xFFFF5963); // Error
  static const Color warningColor = Color(0xFFF9CF58); // Advertencia
  static const Color infoColor = Color(0xFFFFFFFF); // Información

  // Custom Colors
  static const Color complementario1 = Color(0xFF1F1F48);
  static const Color backgroundBlue = Color(0xFF051367);
  static const Color greenColor = Color(0xFF27AE60);

  // Tema para Modo Claro (Light Mode)
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
    ),
    cardColor: secondaryBackground,
    iconTheme: const IconThemeData(color: accent1),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: secondaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: primaryText),
      bodyMedium: TextStyle(color: secondaryText),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: secondaryBackground,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: primaryText,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.transparent,
    ).copyWith(surface: primaryBackground),
  );
}

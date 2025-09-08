import 'package:flutter/material.dart';

class CatppuccinColors {
  // Mocha theme (dark)
  static const Color rosewater = Color(0xFFF5E0DC);
  static const Color flamingo = Color(0xFFF2CDCD);
  static const Color pink = Color(0xFFF5C2E7);
  static const Color mauve = Color(0xFFCBA6F7);
  static const Color red = Color(0xFFF38BA8);
  static const Color maroon = Color(0xFFEBA0AC);
  static const Color peach = Color(0xFFFAB387);
  static const Color yellow = Color(0xFFF9E2AF);
  static const Color green = Color(0xFFA6E3A1);
  static const Color teal = Color(0xFF94E2D5);
  static const Color sky = Color(0xFF89DCEB);
  static const Color sapphire = Color(0xFF74C7EC);
  static const Color blue = Color(0xFF89B4FA);
  static const Color lavender = Color(0xFFB4BEFE);
  static const Color text = Color(0xFFCDD6F4);
  static const Color subtext1 = Color(0xFFBAC2DE);
  static const Color subtext0 = Color(0xFFA6ADC8);
  static const Color overlay2 = Color(0xFF9399B2);
  static const Color overlay1 = Color(0xFF7F849C);
  static const Color overlay0 = Color(0xFF6C7086);
  static const Color surface2 = Color(0xFF585B70);
  static const Color surface1 = Color(0xFF45475A);
  static const Color surface0 = Color(0xFF313244);
  static const Color base = Color(0xFF1E1E2E);
  static const Color mantle = Color(0xFF181825);
  static const Color crust = Color(0xFF11111B);
}

class CatppuccinTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(
        CatppuccinColors.blue.value,
        {
          50: CatppuccinColors.blue.withOpacity(0.1),
          100: CatppuccinColors.blue.withOpacity(0.2),
          200: CatppuccinColors.blue.withOpacity(0.3),
          300: CatppuccinColors.blue.withOpacity(0.4),
          400: CatppuccinColors.blue.withOpacity(0.5),
          500: CatppuccinColors.blue,
          600: CatppuccinColors.blue.withOpacity(0.7),
          700: CatppuccinColors.blue.withOpacity(0.8),
          800: CatppuccinColors.blue.withOpacity(0.9),
          900: CatppuccinColors.blue,
        },
      ),
      colorScheme: ColorScheme.dark(
        primary: CatppuccinColors.blue,
        onPrimary: CatppuccinColors.base,
        secondary: CatppuccinColors.mauve,
        onSecondary: CatppuccinColors.base,
        tertiary: CatppuccinColors.green,
        onTertiary: CatppuccinColors.base,
        error: CatppuccinColors.red,
        onError: CatppuccinColors.base,
        surface: CatppuccinColors.base,
        onSurface: CatppuccinColors.text,
        background: CatppuccinColors.mantle,
        onBackground: CatppuccinColors.text,
      ),
      scaffoldBackgroundColor: CatppuccinColors.base,
      appBarTheme: AppBarTheme(
        backgroundColor: CatppuccinColors.mantle,
        foregroundColor: CatppuccinColors.text,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: CatppuccinColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: CatppuccinColors.surface0,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CatppuccinColors.blue,
          foregroundColor: CatppuccinColors.base,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CatppuccinColors.blue,
        foregroundColor: CatppuccinColors.base,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: CatppuccinColors.text, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: CatppuccinColors.text, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: CatppuccinColors.text, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: CatppuccinColors.text, fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: CatppuccinColors.text, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: CatppuccinColors.text, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: CatppuccinColors.text, fontSize: 16, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(color: CatppuccinColors.text, fontSize: 14, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: CatppuccinColors.subtext1, fontSize: 12, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: CatppuccinColors.text, fontSize: 16),
        bodyMedium: TextStyle(color: CatppuccinColors.text, fontSize: 14),
        bodySmall: TextStyle(color: CatppuccinColors.subtext1, fontSize: 12),
        labelLarge: TextStyle(color: CatppuccinColors.text, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: CatppuccinColors.subtext1, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: CatppuccinColors.subtext0, fontSize: 10, fontWeight: FontWeight.w500),
      ),
      iconTheme: IconThemeData(
        color: CatppuccinColors.text,
        size: 24,
      ),
      dividerColor: CatppuccinColors.surface2,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CatppuccinColors.surface0,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: CatppuccinColors.overlay0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: CatppuccinColors.overlay0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: CatppuccinColors.blue),
        ),
        labelStyle: TextStyle(color: CatppuccinColors.subtext1),
        hintStyle: TextStyle(color: CatppuccinColors.subtext0),
      ),
    );
  }
}

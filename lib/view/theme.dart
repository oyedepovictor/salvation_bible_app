import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF4A6550); // AppBar, active icons, FAB, selected nav indicator
  static const Color primaryLight = Color(0xFF7E9A83); // Primary container, verse numbers, filled buttons, active chips
  static const Color secondary = Color(0xFF8CA3B5); // Secondary chips, cross-reference badges, progress bars
  static const Color tertiary = Color(0xFFC9A98F); // Saved note accents, verse highlights, tonal buttons
  static const Color background = Color(0xFFF7F3EC); // Scaffold background — feels like Bible paper
  static const Color surface = Color(0xFFFBF8F3); // Cards, bottom sheets, nav bar background
  static const Color onSurface = Color(0xFF3E3A36); // Primary text — softer than pure black, no eye strain
  static const Color divider = Color(0xFFE6DFD3); // List dividers, card borders, input field borders

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryLight,
        onPrimaryContainer: onSurface,
        secondary: secondary,
        onSecondary: Colors.white,
        tertiary: tertiary,
        onTertiary: onSurface,
        surface: background,
        onSurface: onSurface,
        error: const Color(0xFFBA1A1A),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 3.0,
        shadowColor: Color(0x33000000),
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

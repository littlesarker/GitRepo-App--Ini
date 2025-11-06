import 'package:flutter/material.dart';

import '../utils/color.dart';
// app_theme.dart
import 'package:flutter/material.dart';

// Light Theme Colors
const Color PRIMARY_COLOR = Colors.blue;
const Color THEME_SCAFFOLD_BACKGROUND_COLOR = Colors.white;
const Color ENABLED_BORDER_COLOR = Colors.grey;
const Color FOCUSED_BORDER_COLOR = Colors.blue;
const Color ERROR_BORDER_COLOR = Colors.red;
const Color FOCUSED_ERROR_BORDER_COLOR = Colors.redAccent;

// Dark Theme Colors
const Color DARK_PRIMARY_COLOR = Colors.blueAccent;
const Color DARK_SCAFFOLD_BACKGROUND_COLOR = Color(0xFF121212);
const Color DARK_ENABLED_BORDER_COLOR = Colors.grey;
const Color DARK_FOCUSED_BORDER_COLOR = Colors.blueAccent;
const Color DARK_ERROR_BORDER_COLOR = Colors.red;
const Color DARK_FOCUSED_ERROR_BORDER_COLOR = Colors.redAccent;

// Borders
const OutlineInputBorder ENABLED_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: ENABLED_BORDER_COLOR),
);
const OutlineInputBorder FOCUSED_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: FOCUSED_BORDER_COLOR),
);
const OutlineInputBorder ERROR_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: ERROR_BORDER_COLOR),
);
const OutlineInputBorder FOCUSED_ERROR_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: FOCUSED_ERROR_BORDER_COLOR),
);

// Dark Theme Borders
const OutlineInputBorder DARK_ENABLED_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: DARK_ENABLED_BORDER_COLOR),
);
const OutlineInputBorder DARK_FOCUSED_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: DARK_FOCUSED_BORDER_COLOR),
);
const OutlineInputBorder DARK_ERROR_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: DARK_ERROR_BORDER_COLOR),
);
const OutlineInputBorder DARK_FOCUSED_ERROR_BORDER = OutlineInputBorder(
  borderSide: BorderSide(width: 1, color: DARK_FOCUSED_ERROR_BORDER_COLOR),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: PRIMARY_COLOR,
  scaffoldBackgroundColor: THEME_SCAFFOLD_BACKGROUND_COLOR,

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: PRIMARY_COLOR,
    foregroundColor: Colors.white,
  ),

  // InputDecoration Theme
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: ENABLED_BORDER,
    focusedBorder: FOCUSED_BORDER,
    errorBorder: ERROR_BORDER,
    focusedErrorBorder: FOCUSED_ERROR_BORDER,
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: PRIMARY_COLOR,
    foregroundColor: Colors.white,
  ),

  // Other theme configurations...
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: DARK_PRIMARY_COLOR,
  scaffoldBackgroundColor: DARK_SCAFFOLD_BACKGROUND_COLOR,

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: DARK_PRIMARY_COLOR,
    foregroundColor: Colors.white,
  ),

  // InputDecoration Theme
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: DARK_ENABLED_BORDER,
    focusedBorder: DARK_FOCUSED_BORDER,
    errorBorder: DARK_ERROR_BORDER,
    focusedErrorBorder: DARK_FOCUSED_ERROR_BORDER,
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: DARK_PRIMARY_COLOR,
    foregroundColor: Colors.white,
  ),

  // Dark theme specific configurations
  cardColor: const Color(0xFF1E1E1E),
  dialogBackgroundColor: const Color(0xFF1E1E1E),
);

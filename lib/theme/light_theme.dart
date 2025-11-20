import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',

  // Primary colors
  primaryColor: Color(0xFFF0692C),
  primaryColorLight: Colors.white,
  primaryColorDark: const Color(0xff2b3941),
  secondaryHeaderColor: const Color(0xFF758493),
  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  brightness: Brightness.light,
  hintColor: const Color(0xFFA4A4A4),
  focusColor: const Color(0xFFFFF9E5),
  hoverColor: const Color(0xFFF8FAFC),
  shadowColor: const Color(0xFFE6E5E5),
  cardColor: Colors.white,

  // TextButton style (kept blue)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: const Color(0xFF036FBE)),
  ),

  // ElevatedButton style (all orange)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFF0692C), // matches primaryColor
      foregroundColor: Colors.white, // text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // optional
      ),
    ),
  ),

  // Color scheme: match primaryColor (orange) everywhere
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFF0692C), // matches primaryColor
    onPrimary: Colors.white, // text on primary
    secondary: Color(0xFFF0692C), // optional: same as primary
    onSecondary: Colors.white,
    tertiary: Color(0xFFF0692C), // optional: same
    onTertiary: Colors.white,
    error: Color(0xFFf76767),
  ).copyWith(
    surface: const Color(0xffFCFCFC),
  ),
);

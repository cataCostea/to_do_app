import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme colorScheme = ColorScheme.light(
  primary: Color(0xFF657AFF),
  secondary: Color(0xFF4F5578),
  primaryVariant: Color(0xFF3AB9F2),
  secondaryVariant: Color(0xFF),
  surface: Color(0xFFFFFFFF),
  background: Color(0xFFFFFFFF),
  error: Color(0xFF),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFFFFFFFF),
  onSurface: Color(0xFF4F5578),
  onError: Color(0xFFD9726),
  onBackground: Color(0xFF000000),
  brightness: Brightness.light,
);

final ThemeData appTheme = ThemeData(
  colorScheme: colorScheme,
  primaryColor: colorScheme.primary,
  primaryColorLight: colorScheme.primaryVariant,
  primaryColorDark: colorScheme.secondary,
  backgroundColor: colorScheme.background,
  scaffoldBackgroundColor: colorScheme.background,
  cursorColor: colorScheme.primary.withOpacity(0.7),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

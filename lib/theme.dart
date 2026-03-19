import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors mapped from Tailwind config
  static const Color primary = Color(0xFF4a7c59);
  static const Color onPrimary = Color(0xFFffffff);
  static const Color primaryContainer = Color(0xFF78a886);
  static const Color onPrimaryContainer = Color(0xFFd8f0de);
  static const Color primaryFixed = Color(0xFFc8e8d0);
  static const Color primaryFixedDim = Color(0xFF8ecf9e);
  static const Color onPrimaryFixed = Color(0xFF002110);
  static const Color onPrimaryFixedVariant = Color(0xFF2a6038);
  static const Color inversePrimary = Color(0xFF8ecf9e);

  static const Color secondary = Color(0xFF6b6358);
  static const Color onSecondary = Color(0xFFffffff);
  static const Color secondaryContainer = Color(0xFFf0e8db);
  static const Color onSecondaryContainer = Color(0xFF5e5548);
  static const Color secondaryFixed = Color(0xFFf0e8db);
  static const Color secondaryFixedDim = Color(0xFFd4ccbf);
  static const Color onSecondaryFixed = Color(0xFF1e1a13);
  static const Color onSecondaryFixedVariant = Color(0xFF4a4538);

  static const Color tertiary = Color(0xFF705c30);
  static const Color onTertiary = Color(0xFFffffff);
  static const Color tertiaryContainer = Color(0xFFc4a66a);
  static const Color onTertiaryContainer = Color(0xFF554020);
  static const Color tertiaryFixed = Color(0xFFf8e0a8);
  static const Color tertiaryFixedDim = Color(0xFFdcc48e);
  static const Color onTertiaryFixed = Color(0xFF221a05);
  static const Color onTertiaryFixedVariant = Color(0xFF554020);

  static const Color background = Color(0xFFfaf6f0);
  static const Color onBackground = Color(0xFF2e3230);

  static const Color surface = Color(0xFFfaf6f0);
  static const Color onSurface = Color(0xFF2e3230);
  static const Color surfaceVariant = Color(0xFFe4e0d8);
  static const Color onSurfaceVariant = Color(0xFF4a4e4a);
  static const Color inverseSurface = Color(0xFF2e3230);
  static const Color inverseOnSurface = Color(0xFFf5f0e8);

  static const Color surfaceBright = Color(0xFFfaf6f0);
  static const Color surfaceDim = Color(0xFFdbd7cf);
  static const Color surfaceContainerLowest = Color(0xFFffffff);
  static const Color surfaceContainerLow = Color(0xFFf5f1ea);
  static const Color surfaceContainer = Color(0xFFf0ece4);
  static const Color surfaceContainerHigh = Color(0xFFeae6de);
  static const Color surfaceContainerHighest = Color(0xFFe4e0d8);

  static const Color error = Color(0xFFb83230);
  static const Color onError = Color(0xFFffffff);
  static const Color errorContainer = Color(0xFFffdad8);
  static const Color onErrorContainer = Color(0xFF690005);

  static const Color outline = Color(0xFF74796e);
  static const Color outlineVariant = Color(0xFFc4c8bc);

  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.literata(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: onSurface,
    ),
    displayMedium: GoogleFonts.literata(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: onSurface,
    ),
    displaySmall: GoogleFonts.literata(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: onSurface,
    ),
    headlineLarge: GoogleFonts.literata(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: onSurface,
    ),
    headlineMedium: GoogleFonts.literata(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: onSurface,
    ),
    headlineSmall: GoogleFonts.literata(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: onSurface,
    ),
    titleLarge: GoogleFonts.literata(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: onSurface,
    ),
    titleMedium: GoogleFonts.nunitoSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: onSurface,
    ),
    titleSmall: GoogleFonts.nunitoSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: onSurface,
    ),
    labelLarge: GoogleFonts.nunitoSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: onSurface,
    ),
    labelMedium: GoogleFonts.nunitoSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: onSurface,
    ),
    labelSmall: GoogleFonts.nunitoSans(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: onSurface,
    ),
    bodyLarge: GoogleFonts.nunitoSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: onSurface,
    ),
    bodyMedium: GoogleFonts.nunitoSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: onSurface,
    ),
    bodySmall: GoogleFonts.nunitoSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: onSurface,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    ),
    scaffoldBackgroundColor: background,
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: primary,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFfaf6f0), // or background
      selectedItemColor: primary,
      unselectedItemColor: Color(0x99705c30),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

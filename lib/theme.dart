import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
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
  static const Color darkBackground = Color(0xFF121715);
  static const Color darkSurface = Color(0xFF1a201d);
  static const Color darkSurfaceHigh = Color(0xFF232a27);
  static const Color darkOnSurface = Color(0xFFedf2ed);
  static const Color darkOnSurfaceVariant = Color(0xFFb4beb6);

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

  static ThemeData get lightTheme {
    final scheme = const ColorScheme(
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
    );

    return _buildTheme(
      scheme: scheme,
      scaffoldColor: background,
      canvasColor: surface,
      text: textTheme,
    );
  }

  static ThemeData get darkTheme {
    final darkText = textTheme.apply(
      bodyColor: darkOnSurface,
      displayColor: darkOnSurface,
    );
    final scheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF9FD6AD),
      onPrimary: Color(0xFF10311A),
      primaryContainer: Color(0xFF244B31),
      onPrimaryContainer: Color(0xFFD5F3DA),
      secondary: Color(0xFFD4CCBF),
      onSecondary: Color(0xFF2B261E),
      secondaryContainer: Color(0xFF3A342B),
      onSecondaryContainer: Color(0xFFF2EBDD),
      tertiary: Color(0xFFE6CA91),
      onTertiary: Color(0xFF36280B),
      tertiaryContainer: Color(0xFF554020),
      onTertiaryContainer: Color(0xFFFFE8B9),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: darkSurface,
      onSurface: darkOnSurface,
      onSurfaceVariant: darkOnSurfaceVariant,
      outline: Color(0xFF8F968E),
      outlineVariant: Color(0xFF414942),
      inverseSurface: Color(0xFFE2E8E1),
      onInverseSurface: Color(0xFF2F352F),
      inversePrimary: primary,
    );

    return _buildTheme(
      scheme: scheme,
      scaffoldColor: darkBackground,
      canvasColor: darkSurface,
      text: darkText,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme scheme,
    required Color scaffoldColor,
    required Color canvasColor,
    required TextTheme text,
  }) {
    return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scaffoldColor,
    canvasColor: canvasColor,
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface.withValues(alpha: 0.94),
      indicatorColor: scheme.primary.withValues(alpha: 0.14),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return text.labelMedium?.copyWith(
          color: selected ? scheme.primary : scheme.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? scheme.primary : scheme.onSurfaceVariant,
          size: 24,
        );
      }),
      elevation: 0,
      height: 72,
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.22),
        ),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.45)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
      selectedColor: scheme.primary.withValues(alpha: 0.14),
      secondarySelectedColor: scheme.primary.withValues(alpha: 0.14),
      labelStyle: text.labelMedium ?? const TextStyle(),
      secondaryLabelStyle: text.labelMedium?.copyWith(color: scheme.primary) ?? const TextStyle(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: 0.25),
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.onPrimary;
        }
        return scheme.surface;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primary;
        }
        return scheme.surfaceContainerHighest;
      }),
    ),
  );
  }
}

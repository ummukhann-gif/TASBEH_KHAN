import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppPalette {
  terra('Terra'),
  softRose('Soft Rose'),
  royalBlue('Royal Blue'),
  lavender('Lavender'),
  midnight('Midnight');

  const AppPalette(this.label);

  final String label;
}

class AppTheme {
  static ThemeData buildTheme({
    required AppPalette palette,
    required Brightness brightness,
  }) {
    final tokens = _PaletteTokens.resolve(
      palette: palette,
      brightness: brightness,
    );

    final scheme =
        ColorScheme.fromSeed(
          seedColor: tokens.seed,
          brightness: brightness,
        ).copyWith(
          primary: tokens.primary,
          secondary: tokens.secondary,
          tertiary: tokens.tertiary,
          surface: tokens.surface,
          onSurface: tokens.onSurface,
          onSurfaceVariant: tokens.onSurfaceVariant,
          outline: tokens.outline,
          outlineVariant: tokens.outlineVariant,
          surfaceTint: tokens.primary,
        );

    final baseText = ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      useMaterial3: true,
    ).textTheme;

    final textTheme = GoogleFonts.nunitoSansTextTheme(baseText).copyWith(
      displayLarge: GoogleFonts.literata(
        textStyle: baseText.displayLarge,
        fontWeight: FontWeight.w800,
        color: scheme.onSurface,
      ),
      displayMedium: GoogleFonts.literata(
        textStyle: baseText.displayMedium,
        fontWeight: FontWeight.w800,
        color: scheme.onSurface,
      ),
      displaySmall: GoogleFonts.literata(
        textStyle: baseText.displaySmall,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      headlineLarge: GoogleFonts.literata(
        textStyle: baseText.headlineLarge,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      headlineMedium: GoogleFonts.literata(
        textStyle: baseText.headlineMedium,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      headlineSmall: GoogleFonts.literata(
        textStyle: baseText.headlineSmall,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      titleLarge: GoogleFonts.literata(
        textStyle: baseText.titleLarge,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      titleMedium: GoogleFonts.nunitoSans(
        textStyle: baseText.titleMedium,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      titleSmall: GoogleFonts.nunitoSans(
        textStyle: baseText.titleSmall,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      bodyLarge: GoogleFonts.nunitoSans(
        textStyle: baseText.bodyLarge,
        color: scheme.onSurface,
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        textStyle: baseText.bodyMedium,
        color: scheme.onSurface,
      ),
      bodySmall: GoogleFonts.nunitoSans(
        textStyle: baseText.bodySmall,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.nunitoSans(
        textStyle: baseText.labelLarge,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      labelMedium: GoogleFonts.nunitoSans(
        textStyle: baseText.labelMedium,
        fontWeight: FontWeight.w700,
        color: scheme.onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.nunitoSans(
        textStyle: baseText.labelSmall,
        fontWeight: FontWeight.w700,
        color: scheme.onSurfaceVariant,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: tokens.background,
      canvasColor: tokens.surface,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.18),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
            color: scheme.primary.withValues(alpha: 0.35),
            width: 1.4,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? scheme.onPrimary
              : scheme.surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.surfaceContainerHighest;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.outlineVariant.withValues(alpha: 0.4),
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.14),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}

class _PaletteTokens {
  const _PaletteTokens({
    required this.seed,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
  });

  final Color seed;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color background;
  final Color surface;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;

  static _PaletteTokens resolve({
    required AppPalette palette,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    return switch (palette) {
      AppPalette.terra => _PaletteTokens(
        seed: const Color(0xFF4A7C59),
        primary: isDark ? const Color(0xFF8ECF9E) : const Color(0xFF4A7C59),
        secondary: isDark ? const Color(0xFFD4CCBF) : const Color(0xFF6B6358),
        tertiary: isDark ? const Color(0xFFDCC48E) : const Color(0xFF705C30),
        background: isDark ? const Color(0xFF141715) : const Color(0xFFFAF6F0),
        surface: isDark ? const Color(0xFF1A1E1B) : const Color(0xFFF5F1EA),
        onSurface: isDark ? const Color(0xFFF4F2EC) : const Color(0xFF2E3230),
        onSurfaceVariant: isDark
            ? const Color(0xFFBCC2BA)
            : const Color(0xFF4A4E4A),
        outline: isDark ? const Color(0xFF8A918B) : const Color(0xFF74796E),
        outlineVariant: isDark
            ? const Color(0xFF3A403C)
            : const Color(0xFFC4C8BC),
      ),
      AppPalette.softRose => _PaletteTokens(
        seed: const Color(0xFFE7B0B7),
        primary: isDark ? const Color(0xFFFFC9D0) : const Color(0xFF9A5563),
        secondary: isDark ? const Color(0xFFE5CCCF) : const Color(0xFF816367),
        tertiary: isDark ? const Color(0xFFF7D29E) : const Color(0xFFA07237),
        background: isDark ? const Color(0xFF1D1719) : const Color(0xFFFFF7F7),
        surface: isDark ? const Color(0xFF261F21) : const Color(0xFFFFF1F2),
        onSurface: isDark ? const Color(0xFFFCEDEE) : const Color(0xFF342B2D),
        onSurfaceVariant: isDark
            ? const Color(0xFFD0B9BC)
            : const Color(0xFF66585A),
        outline: isDark ? const Color(0xFFA58E91) : const Color(0xFF8F777B),
        outlineVariant: isDark
            ? const Color(0xFF4A3D40)
            : const Color(0xFFE5D0D3),
      ),
      AppPalette.royalBlue => _PaletteTokens(
        seed: const Color(0xFF2B4C7E),
        primary: isDark ? const Color(0xFFB0C8FF) : const Color(0xFF2B4C7E),
        secondary: isDark ? const Color(0xFFD4D8E6) : const Color(0xFF5E6576),
        tertiary: isDark ? const Color(0xFFBFD2FF) : const Color(0xFF4962AA),
        background: isDark ? const Color(0xFF111621) : const Color(0xFFF6F8FD),
        surface: isDark ? const Color(0xFF1A2230) : const Color(0xFFEEF3FC),
        onSurface: isDark ? const Color(0xFFF1F5FF) : const Color(0xFF1F2A3A),
        onSurfaceVariant: isDark
            ? const Color(0xFFC0CADC)
            : const Color(0xFF556173),
        outline: isDark ? const Color(0xFF8E9AB1) : const Color(0xFF748198),
        outlineVariant: isDark
            ? const Color(0xFF344154)
            : const Color(0xFFD0D8E7),
      ),
      AppPalette.lavender => _PaletteTokens(
        seed: const Color(0xFF9B89B3),
        primary: isDark ? const Color(0xFFE0D0FF) : const Color(0xFF6E5A89),
        secondary: isDark ? const Color(0xFFD9D0E4) : const Color(0xFF70667B),
        tertiary: isDark ? const Color(0xFFF3CDB7) : const Color(0xFFA96E54),
        background: isDark ? const Color(0xFF17141D) : const Color(0xFFFAF7FF),
        surface: isDark ? const Color(0xFF211C29) : const Color(0xFFF4EFFA),
        onSurface: isDark ? const Color(0xFFF7F1FF) : const Color(0xFF2F2A36),
        onSurfaceVariant: isDark
            ? const Color(0xFFC9BDD5)
            : const Color(0xFF655C72),
        outline: isDark ? const Color(0xFF9D91A9) : const Color(0xFF857A92),
        outlineVariant: isDark
            ? const Color(0xFF40384A)
            : const Color(0xFFE0D6EA),
      ),
      AppPalette.midnight => _PaletteTokens(
        seed: const Color(0xFF121212),
        primary: isDark ? const Color(0xFFCADAB8) : const Color(0xFF304A3B),
        secondary: isDark ? const Color(0xFFC7CCCA) : const Color(0xFF5D6661),
        tertiary: isDark ? const Color(0xFFE6D2A0) : const Color(0xFF7D6640),
        background: isDark ? const Color(0xFF0D0E10) : const Color(0xFFF4F5F4),
        surface: isDark ? const Color(0xFF16181B) : const Color(0xFFECEFED),
        onSurface: isDark ? const Color(0xFFF4F5F4) : const Color(0xFF202322),
        onSurfaceVariant: isDark
            ? const Color(0xFFBCC3BE)
            : const Color(0xFF5A625D),
        outline: isDark ? const Color(0xFF8A918D) : const Color(0xFF757D78),
        outlineVariant: isDark
            ? const Color(0xFF323734)
            : const Color(0xFFD1D6D2),
      ),
    };
  }
}

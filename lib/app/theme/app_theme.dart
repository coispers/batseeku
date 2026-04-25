import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  const AppColors._();

  static const Color maroon = Color(0xFF8B2332);
  static const Color maroonDark = Color(0xFF61101C);
  static const Color maroonSoft = Color(0xFFF8E8EB);
  static const Color maroonMuted = Color(0xFFAD5D6B);
  static const Color background = Color(0xFFF8F4F1);
  static const Color backgroundAlt = Color(0xFFF2EBE6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFFCFAF9);
  static const Color textPrimary = Color(0xFF281E1A);
  static const Color textSecondary = Color(0xFF4F4541);
  static const Color textMuted = Color(0xFF766A63);
  static const Color line = Color(0xFFE2D6CE);
  static const Color lineStrong = Color(0xFFC8B6AB);
  static const Color success = Color(0xFF1F8B4C);
  static const Color successSurface = Color(0xFFE9F7EE);
  static const Color warning = Color(0xFFB54708);
  static const Color warningSurface = Color(0xFFFFF2E0);
  static const Color danger = Color(0xFFB42318);
  static const Color dangerSurface = Color(0xFFFDEDEC);
  static const Color info = Color(0xFF155D8A);
  static const Color infoSurface = Color(0xFFE8F3FB);
  static const Color disabled = Color(0xFFBCAFA7);
  static const Color focusRing = Color(0xFF9F3547);
  static const Color pressedOverlay = Color(0x1F8B2332);
  static const Color hoverOverlay = Color(0x148B2332);
}

class AppSpacing {
  const AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
}

class AppRadii {
  const AppRadii._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;
}

class AppIconSize {
  const AppIconSize._();

  static const double xs = 14;
  static const double sm = 18;
  static const double md = 22;
  static const double lg = 28;
}

class AppBreakpoints {
  const AppBreakpoints._();

  static const double tablet = 760;
  static const double desktop = 1120;
}

class AppMotion {
  const AppMotion._();

  static const Duration fast = Duration(milliseconds: 140);
  static const Duration medium = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 360);

  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve standard = Curves.easeInOutCubic;
}

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final TextTheme textTheme = _buildTextTheme();

    final ColorScheme scheme = const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.maroon,
      onPrimary: Colors.white,
      secondary: AppColors.maroonDark,
      onSecondary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 68,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.focusRing, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.maroonSoft,
        iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.maroon,
              size: AppIconSize.md,
            );
          }
          return const IconThemeData(
            color: AppColors.textMuted,
            size: AppIconSize.md,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.maroon,
            );
          }
          return textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceMuted,
        selectedColor: AppColors.maroonSoft,
        disabledColor: AppColors.backgroundAlt,
        side: const BorderSide(color: AppColors.line),
        labelStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.maroon,
        inactiveTrackColor: AppColors.maroonSoft,
        thumbColor: AppColors.maroon,
        overlayColor: AppColors.pressedOverlay,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.maroon,
          disabledForegroundColor: Colors.white,
          disabledBackgroundColor: AppColors.disabled,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle:
              textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.maroon,
          side: const BorderSide(color: AppColors.lineStrong),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle:
              textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.maroon,
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle:
              textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.maroon.withOpacity(0.44);
          }
          return AppColors.backgroundAlt;
        }),
        thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.maroon;
          }
          return AppColors.surface;
        }),
      ),
      splashColor: AppColors.pressedOverlay,
      highlightColor: AppColors.hoverOverlay,
    );
  }

  static TextTheme _buildTextTheme() {
    final TextTheme base = GoogleFonts.nunitoSansTextTheme();

    return base.copyWith(
      displayMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 34,
        color: AppColors.textPrimary,
        height: 1.08,
      ),
      headlineMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 29,
        color: AppColors.textPrimary,
        height: 1.14,
      ),
      titleLarge: GoogleFonts.nunitoSans(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.nunitoSans(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        height: 1.35,
      ),
    );
  }
}

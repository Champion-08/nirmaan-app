/// Nirmaan Design System — Full Light & Dark ThemeData
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'dimens.dart';
import 'typography.dart';

class NirmaanTheme {
  NirmaanTheme._();

  // ═══════════════════════════════════════════════════════════════════
  //  LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: NirmaanColors.pageCanvas,
      colorScheme: const ColorScheme.light(
        primary: NirmaanColors.brandNavy,
        secondary: NirmaanColors.brandRoyalBlue,
        surface: NirmaanColors.cardSurface,
        error: NirmaanColors.dangerText,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: NirmaanColors.white,
        foregroundColor: NirmaanColors.headingDark,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: NirmaanTypography.headlineMedium,
        iconTheme: const IconThemeData(color: NirmaanColors.headingDark, size: 22),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: NirmaanColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
          side: NirmaanBorders.cardBorder,
        ),
        margin: EdgeInsets.zero,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NirmaanColors.inputSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NirmaanDimens.base,
          vertical: NirmaanDimens.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
          borderSide: NirmaanBorders.inputBorder,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
          borderSide: NirmaanBorders.inputBorder,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
          borderSide: const BorderSide(color: NirmaanColors.brandNavy, width: 1.5),
        ),
        hintStyle: NirmaanTypography.bodyMedium.copyWith(
          color: NirmaanColors.bodyGrey.withValues(alpha: 0.5),
        ),
        labelStyle: NirmaanTypography.labelLarge,
      ),

      // Elevated button (primary navy)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NirmaanColors.brandNavy,
          foregroundColor: NirmaanColors.white,
          minimumSize: const Size.fromHeight(NirmaanDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NirmaanDimens.buttonRadius),
          ),
          textStyle: NirmaanTypography.button,
          elevation: 0,
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: NirmaanTypography.displayLarge,
        displayMedium: NirmaanTypography.displayMedium,
        headlineLarge: NirmaanTypography.headlineLarge,
        headlineMedium: NirmaanTypography.headlineMedium,
        headlineSmall: NirmaanTypography.headlineSmall,
        titleLarge: NirmaanTypography.titleLarge,
        titleMedium: NirmaanTypography.titleMedium,
        bodyLarge: NirmaanTypography.bodyLarge,
        bodyMedium: NirmaanTypography.bodyMedium,
        bodySmall: NirmaanTypography.bodySmall,
        labelLarge: NirmaanTypography.labelLarge,
        labelMedium: NirmaanTypography.labelMedium,
        labelSmall: NirmaanTypography.labelSmall,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: NirmaanColors.divider,
        thickness: 1,
        space: 0,
      ),

      // Bottom nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NirmaanColors.white,
        selectedItemColor: NirmaanColors.brandNavy,
        unselectedItemColor: NirmaanColors.bodyGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: NirmaanColors.tintedHighlight,
        labelStyle: NirmaanTypography.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.pillRadius),
        ),
        side: BorderSide.none,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  DARK THEME
  // ═══════════════════════════════════════════════════════════════════
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NirmaanColors.darkCanvas,
      colorScheme: const ColorScheme.dark(
        primary: NirmaanColors.brandRoyalBlue,
        secondary: NirmaanColors.brandAccentGreen,
        surface: NirmaanColors.darkCard,
        error: NirmaanColors.dangerText,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: NirmaanColors.darkCard,
        foregroundColor: NirmaanColors.darkHeading,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle:
            NirmaanTypography.headlineMedium.copyWith(color: NirmaanColors.darkHeading),
        iconTheme: const IconThemeData(color: NirmaanColors.darkHeading, size: 22),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: NirmaanColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
          side: NirmaanBorders.darkCardBorder,
        ),
        margin: EdgeInsets.zero,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NirmaanColors.darkInputSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NirmaanDimens.base,
          vertical: NirmaanDimens.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
          borderSide: NirmaanBorders.darkInputBorder,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
          borderSide: NirmaanBorders.darkInputBorder,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
          borderSide: const BorderSide(color: NirmaanColors.brandRoyalBlue, width: 1.5),
        ),
        hintStyle: NirmaanTypography.bodyMedium.copyWith(
          color: NirmaanColors.darkBody.withValues(alpha: 0.5),
        ),
        labelStyle: NirmaanTypography.darkLabelLarge,
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NirmaanColors.brandRoyalBlue,
          foregroundColor: NirmaanColors.white,
          minimumSize: const Size.fromHeight(NirmaanDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NirmaanDimens.buttonRadius),
          ),
          textStyle: NirmaanTypography.button,
          elevation: 0,
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: NirmaanTypography.darkDisplayLarge,
        displayMedium: NirmaanTypography.displayMedium.copyWith(color: NirmaanColors.darkHeading),
        headlineLarge: NirmaanTypography.darkHeadlineLarge,
        headlineMedium: NirmaanTypography.darkHeadlineMedium,
        headlineSmall: NirmaanTypography.headlineSmall.copyWith(color: NirmaanColors.darkHeading),
        titleLarge: NirmaanTypography.darkTitleLarge,
        titleMedium: NirmaanTypography.titleMedium.copyWith(color: NirmaanColors.darkHeading),
        bodyLarge: NirmaanTypography.darkBodyLarge,
        bodyMedium: NirmaanTypography.darkBodyMedium,
        bodySmall: NirmaanTypography.darkBodySmall,
        labelLarge: NirmaanTypography.darkLabelLarge,
        labelMedium: NirmaanTypography.labelMedium.copyWith(color: NirmaanColors.darkBody),
        labelSmall: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.darkBody),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: NirmaanColors.darkDivider,
        thickness: 1,
        space: 0,
      ),

      // Bottom nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NirmaanColors.darkCard,
        selectedItemColor: NirmaanColors.white,
        unselectedItemColor: NirmaanColors.darkBody,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: NirmaanColors.darkTintedHighlight,
        labelStyle: NirmaanTypography.labelMedium.copyWith(color: NirmaanColors.darkBody),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NirmaanDimens.pillRadius),
        ),
        side: BorderSide.none,
      ),
    );
  }
}

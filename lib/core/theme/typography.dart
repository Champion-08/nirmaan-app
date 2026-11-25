/// Nirmaan Design System — Typography
///
/// Heading / KPI: Plus Jakarta Sans  |  Body / Labels: Inter
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class NirmaanTypography {
  NirmaanTypography._();

  // ─── Light theme text styles ────────────────────────────────────────

  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: NirmaanColors.headingDark,
    height: 1.2,
  );

  static TextStyle displayMedium = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: NirmaanColors.headingDark,
    height: 1.25,
  );

  static TextStyle headlineLarge = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: NirmaanColors.headingDark,
    height: 1.3,
  );

  static TextStyle headlineMedium = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: NirmaanColors.headingDark,
    height: 1.3,
  );

  static TextStyle headlineSmall = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: NirmaanColors.headingDark,
    height: 1.35,
  );

  static TextStyle titleLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: NirmaanColors.headingDark,
    height: 1.4,
  );

  static TextStyle titleMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: NirmaanColors.headingDark,
    height: 1.4,
  );

  static TextStyle kpiNumber = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: NirmaanColors.headingDark,
    height: 1.15,
  );

  // ─── Body / Labels (Inter) ──────────────────────────────────────────

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: NirmaanColors.bodyGrey,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: NirmaanColors.bodyGrey,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: NirmaanColors.bodyGrey,
    height: 1.5,
  );

  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: NirmaanColors.bodyGrey,
    height: 1.4,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: NirmaanColors.bodyGrey,
    height: 1.4,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: NirmaanColors.bodyGrey,
    height: 1.4,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: NirmaanColors.white,
    height: 1.4,
  );

  // ─── Dark variants ─────────────────────────────────────────────────

  static TextStyle get darkDisplayLarge =>
      displayLarge.copyWith(color: NirmaanColors.darkHeading);

  static TextStyle get darkHeadlineLarge =>
      headlineLarge.copyWith(color: NirmaanColors.darkHeading);

  static TextStyle get darkHeadlineMedium =>
      headlineMedium.copyWith(color: NirmaanColors.darkHeading);

  static TextStyle get darkTitleLarge =>
      titleLarge.copyWith(color: NirmaanColors.darkHeading);

  static TextStyle get darkKpiNumber =>
      kpiNumber.copyWith(color: NirmaanColors.darkHeading);

  static TextStyle get darkBodyLarge =>
      bodyLarge.copyWith(color: NirmaanColors.darkBody);

  static TextStyle get darkBodyMedium =>
      bodyMedium.copyWith(color: NirmaanColors.darkBody);

  static TextStyle get darkBodySmall =>
      bodySmall.copyWith(color: NirmaanColors.darkBody);

  static TextStyle get darkLabelLarge =>
      labelLarge.copyWith(color: NirmaanColors.darkBody);
}

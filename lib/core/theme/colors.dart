/// Nirmaan Design System — Color Tokens
///
/// All color values match the Figma prototype exactly.
library;

import 'package:flutter/material.dart';

class NirmaanColors {
  NirmaanColors._();

  // ─── Brand ──────────────────────────────────────────────────────────
  static const Color brandNavy = Color(0xFF0D254C);
  static const Color brandRoyalBlue = Color(0xFF1A3B8B);
  static const Color brandAccentGreen = Color(0xFF22C55E);

  // ─── Surfaces — Light ───────────────────────────────────────────────
  static const Color pageCanvas = Color(0xFFF5F8FC);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE6ECF5);
  static const Color inputSurface = Color(0xFFF4F7FB);
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color tintedHighlight = Color(0xFFEEF3FB);

  // ─── Surfaces — Dark ────────────────────────────────────────────────
  static const Color darkCanvas = Color(0xFF0A1120);
  static const Color darkCard = Color(0xFF131E32);
  static const Color darkCardBorder = Color(0xFF1E2D45);
  static const Color darkInputSurface = Color(0xFF162035);
  static const Color darkInputBorder = Color(0xFF253550);
  static const Color darkTintedHighlight = Color(0xFF152240);

  // ─── Typography ─────────────────────────────────────────────────────
  static const Color headingDark = Color(0xFF0B1F3A);
  static const Color bodyGrey = Color(0xFF526075);
  static const Color darkHeading = Color(0xFFE8ECF4);
  static const Color darkBody = Color(0xFF8896AB);

  // ─── Status Pills ───────────────────────────────────────────────────
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successText = Color(0xFF15803D);

  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningText = Color(0xFFB45309);

  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color dangerText = Color(0xFFB91C1C);

  static const Color infoBg = Color(0xFFE0E7FF);
  static const Color infoText = Color(0xFF1D4ED8);

  // ─── Bottom Nav ─────────────────────────────────────────────────────
  static const Color navActivePill = Color(0xFFDCE6F7);

  // ─── Misc ───────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color notificationDot = Color(0xFFEF4444);
  static const Color divider = Color(0xFFE6ECF5);
  static const Color darkDivider = Color(0xFF1E2D45);
}

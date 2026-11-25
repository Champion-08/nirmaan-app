/// Nirmaan Design System — Spacing, Radius & Elevation constants
library;

import 'package:flutter/material.dart';
import 'colors.dart';

class NirmaanDimens {
  NirmaanDimens._();

  // ─── Spacing scale (multiples of 4) ─────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // ─── Border radius ──────────────────────────────────────────────────
  static const double cardRadius = 16;
  static const double inputRadius = 12;
  static const double pillRadius = 100;
  static const double buttonRadius = 12;

  // ─── Component heights ──────────────────────────────────────────────
  static const double inputHeight = 52;
  static const double buttonHeight = 52;
  static const double bottomNavHeight = 72;
}

class NirmaanShadows {
  NirmaanShadows._();

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: NirmaanColors.brandNavy.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardShadowDark => [
        BoxShadow(
          color: NirmaanColors.black.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}

class NirmaanBorders {
  NirmaanBorders._();

  static BorderSide get cardBorder =>
      const BorderSide(color: NirmaanColors.cardBorder, width: 1);

  static BorderSide get darkCardBorder =>
      const BorderSide(color: NirmaanColors.darkCardBorder, width: 1);

  static BorderSide get inputBorder =>
      const BorderSide(color: NirmaanColors.inputBorder, width: 1);

  static BorderSide get darkInputBorder =>
      const BorderSide(color: NirmaanColors.darkInputBorder, width: 1);
}

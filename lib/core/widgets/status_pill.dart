/// StatusPill — Colored pill for Success / Warning / Danger / Info states.
library;

import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum StatusPillVariant { success, warning, danger, info }

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.variant,
    this.icon,
  });

  final String label;
  final StatusPillVariant variant;
  final IconData? icon;

  Color get _bg {
    switch (variant) {
      case StatusPillVariant.success:
        return NirmaanColors.successBg;
      case StatusPillVariant.warning:
        return NirmaanColors.warningBg;
      case StatusPillVariant.danger:
        return NirmaanColors.dangerBg;
      case StatusPillVariant.info:
        return NirmaanColors.infoBg;
    }
  }

  Color get _fg {
    switch (variant) {
      case StatusPillVariant.success:
        return NirmaanColors.successText;
      case StatusPillVariant.warning:
        return NirmaanColors.warningText;
      case StatusPillVariant.danger:
        return NirmaanColors.dangerText;
      case StatusPillVariant.info:
        return NirmaanColors.infoText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(NirmaanDimens.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: _fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: NirmaanTypography.labelSmall.copyWith(
              color: _fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

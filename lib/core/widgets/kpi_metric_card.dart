/// KpiMetricCard — Compact KPI card matching the Figma spec.
///
/// Shows a metric label, large KPI value, and optional sparkline / delta.
library;

import 'package:flutter/material.dart';
import '../theme/theme.dart';

class KpiMetricCard extends StatelessWidget {
  const KpiMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.delta,
    this.deltaPositive = true,
    this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final String? delta;
  final bool deltaPositive;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(NirmaanDimens.base),
        decoration: BoxDecoration(
          color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
          borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
          border: Border.all(
            color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
          ),
          boxShadow: isDark ? NirmaanShadows.cardShadowDark : NirmaanShadows.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + label
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? NirmaanColors.darkTintedHighlight
                          : NirmaanColors.tintedHighlight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 16, color: NirmaanColors.brandRoyalBlue),
                  ),
                  const SizedBox(width: NirmaanDimens.sm),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: isDark
                        ? NirmaanTypography.darkBodySmall
                        : NirmaanTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: NirmaanDimens.md),

            // KPI value
            Text(
              value,
              style: isDark ? NirmaanTypography.darkKpiNumber : NirmaanTypography.kpiNumber,
            ),

            // Delta
            if (delta != null) ...[
              const SizedBox(height: NirmaanDimens.xs),
              Row(
                children: [
                  Icon(
                    deltaPositive ? Icons.trending_up : Icons.trending_down,
                    size: 14,
                    color: deltaPositive
                        ? NirmaanColors.successText
                        : NirmaanColors.dangerText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    delta!,
                    style: NirmaanTypography.labelSmall.copyWith(
                      color: deltaPositive
                          ? NirmaanColors.successText
                          : NirmaanColors.dangerText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

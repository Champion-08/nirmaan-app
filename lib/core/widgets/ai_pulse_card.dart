/// AiPulseCard — Tinted highlight card for AI insights, Live Sync pills,
/// security banners, and sparkline boxes.
library;

import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AiPulseCard extends StatelessWidget {
  const AiPulseCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(NirmaanDimens.base),
        decoration: BoxDecoration(
          color: isDark
              ? NirmaanColors.darkTintedHighlight
              : NirmaanColors.tintedHighlight,
          borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? NirmaanColors.brandRoyalBlue.withValues(alpha: 0.2)
                      : NirmaanColors.brandRoyalBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: NirmaanColors.brandRoyalBlue,
                ),
              ),
              const SizedBox(width: NirmaanDimens.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: (isDark
                            ? NirmaanTypography.darkTitleLarge
                            : NirmaanTypography.titleLarge)
                        .copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: isDark
                        ? NirmaanTypography.darkBodySmall
                        : NirmaanTypography.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

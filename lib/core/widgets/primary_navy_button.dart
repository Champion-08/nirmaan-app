/// PrimaryNavyButton — 52px tall, 12px radius, navy fill (#0D254C),
/// white bold text with optional trailing arrow.
library;

import 'package:flutter/material.dart';
import '../theme/theme.dart';

class PrimaryNavyButton extends StatelessWidget {
  const PrimaryNavyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.showArrow = true,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: NirmaanDimens.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: NirmaanColors.brandNavy,
          foregroundColor: NirmaanColors.white,
          disabledBackgroundColor: NirmaanColors.brandNavy.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NirmaanDimens.buttonRadius),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.xl),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: NirmaanColors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: NirmaanDimens.sm),
                  ],
                  Text(label, style: NirmaanTypography.button),
                  if (showArrow) ...[
                    const SizedBox(width: NirmaanDimens.sm),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ],
              ),
      ),
    );
  }
}

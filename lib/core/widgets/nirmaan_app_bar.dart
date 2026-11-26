/// NirmaanAppBar — Top bar with [N] icon, title, notification bell & profile avatar.
///
/// Two variants:
///   • `NirmaanAppBar()`  — main app bar (home screen)
///   • `NirmaanAppBar.sub(title: …, actionLabel: …)` — sub-page with back arrow
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';

class NirmaanAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NirmaanAppBar({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
    this.hasUnread = true,
  })  : isSub = false,
        title = null,
        actionLabel = null,
        onAction = null;

  /// Sub-page variant with back arrow, page title, and optional right action pill.
  const NirmaanAppBar.sub({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  })  : isSub = true,
        onNotificationTap = null,
        onProfileTap = null,
        hasUnread = false;

  final bool isSub;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final bool hasUnread;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isSub) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).maybePop();
          },
        ),
        title: Text(
          title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          if (actionLabel case final label?)
            Padding(
              padding: const EdgeInsets.only(right: NirmaanDimens.base),
              child: _ActionPill(
                label: label,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onAction?.call();
                },
              ),
            ),
        ],
      );
    }

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: NirmaanDimens.base),
        child: Center(
          child: _NirmaanLogo(isDark: isDark),
        ),
      ),
      leadingWidth: 48,
      titleSpacing: NirmaanDimens.sm,
      title: Text(
        'Nirmaan',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: isDark
                  ? NirmaanColors.darkHeading
                  : NirmaanColors.headingDark,
            ),
      ),
      actions: [
        // Notification bell
        Stack(
          children: [
            IconButton(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: Icon(
                Icons.notifications_outlined,
                color: isDark
                    ? NirmaanColors.darkHeading
                    : NirmaanColors.headingDark,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                if (onNotificationTap != null) {
                  onNotificationTap!();
                } else {
                  context.push('/notifications');
                }
              },
            ),
            if (hasUnread)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: NirmaanColors.notificationDot,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        // Profile avatar
        Padding(
          padding: const EdgeInsets.only(right: NirmaanDimens.base),
          child: Center(
            child: InkResponse(
              radius: 24,
              onTap: () {
                HapticFeedback.lightImpact();
                if (onProfileTap != null) {
                  onProfileTap!();
                } else {
                  context.push('/profile');
                }
              },
              child: const CircleAvatar(
                radius: 17,
                backgroundColor: NirmaanColors.brandNavy,
                child: Text(
                  'N',
                  style: TextStyle(color: NirmaanColors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Private helpers ─────────────────────────────────────────────────

class _NirmaanLogo extends StatelessWidget {
  const _NirmaanLogo({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.brandRoyalBlue : NirmaanColors.brandNavy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              'N',
              style: NirmaanTypography.titleLarge.copyWith(
                color: NirmaanColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: NirmaanColors.brandAccentGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: NirmaanDimens.base,
          vertical: NirmaanDimens.sm,
        ),
        decoration: BoxDecoration(
          color: NirmaanColors.brandNavy,
          borderRadius: BorderRadius.circular(NirmaanDimens.pillRadius),
        ),
        child: Text(
          label,
          style: NirmaanTypography.labelMedium.copyWith(
            color: NirmaanColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

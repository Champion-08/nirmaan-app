/// NirmaanAppBar — Top bar with [N] icon, title, notification bell & profile avatar.
///
/// Two variants:
///   • `NirmaanAppBar()`  — main app bar (home screen)
///   • `NirmaanAppBar.sub(title: …, actionLabel: …)` — sub-page with back arrow
library;

import 'package:flutter/material.dart';
import '../theme/theme.dart';

class NirmaanAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NirmaanAppBar({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
    this.hasUnread = true,
  })  : _isSub = false,
        _subTitle = null,
        _actionLabel = null,
        _onAction = null;

  /// Sub-page variant with back arrow, page title, and optional right action pill.
  const NirmaanAppBar.sub({
    super.key,
    required String title,
    String? actionLabel,
    VoidCallback? onAction,
  })  : _isSub = true,
        _subTitle = title,
        _actionLabel = actionLabel,
        _onAction = onAction,
        onNotificationTap = null,
        onProfileTap = null,
        hasUnread = false;

  final bool _isSub;
  final String? _subTitle;
  final String? _actionLabel;
  final VoidCallback? _onAction;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final bool hasUnread;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isSub) {
      return AppBar(
        leading: const BackButton(),
        title: Text(
          _subTitle ?? '',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          if (_actionLabel case final label?)
            Padding(
              padding: const EdgeInsets.only(right: NirmaanDimens.base),
              child: _ActionPill(label: label, onTap: _onAction),
            ),
        ],
      );
    }

    return AppBar(
      leadingWidth: 180,
      leading: Padding(
        padding: const EdgeInsets.only(left: NirmaanDimens.base),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NirmaanLogo(isDark: isDark),
            const SizedBox(width: NirmaanDimens.sm),
            Text(
              'Nirmaan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isDark
                        ? NirmaanColors.darkHeading
                        : NirmaanColors.headingDark,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        // Notification bell
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: isDark
                    ? NirmaanColors.darkHeading
                    : NirmaanColors.headingDark,
              ),
              onPressed: onNotificationTap,
            ),
            if (hasUnread)
              Positioned(
                right: 10,
                top: 10,
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
          child: GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 17,
              backgroundColor: NirmaanColors.brandNavy,
              child: Text(
                'N',
                style: NirmaanTypography.titleMedium
                    .copyWith(color: NirmaanColors.white, fontSize: 13),
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

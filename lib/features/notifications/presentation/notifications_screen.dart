import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/providers/app_providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  int _selectedFilter = 0; // 0 = All (5), 1 = Unread (3)

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: NirmaanAppBar.sub(
        title: 'Notifications',
        actionLabel: 'Mark all read',
        onAction: () {
          // Mark all notifications as read in state
          final list = notificationsAsync.valueOrNull ?? [];
          for (final n in list) {
            ref.read(notificationsProvider.notifier).markAsRead(n.id);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All notifications marked as read')),
          );
        },
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load notifications')),
        data: (allNotifs) {
          final unreadCount = allNotifs.where((n) => !n.isRead).length;
          final filteredList = _selectedFilter == 1
              ? allNotifs.where((n) => !n.isRead).toList()
              : allNotifs;

          return ListView(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            children: [
              // Filter pills: All (5) / Unread (3)
              Row(
                children: [
                  ChoiceChip(
                    label: Text('All (${allNotifs.length})'),
                    selected: _selectedFilter == 0,
                    selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                    labelStyle: TextStyle(
                      color: _selectedFilter == 0
                          ? (isDark ? Colors.white : NirmaanColors.brandNavy)
                          : (isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey),
                      fontWeight: _selectedFilter == 0 ? FontWeight.w700 : FontWeight.w500,
                    ),
                    onSelected: (_) => setState(() => _selectedFilter = 0),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('Unread ($unreadCount)'),
                    selected: _selectedFilter == 1,
                    selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                    labelStyle: TextStyle(
                      color: _selectedFilter == 1
                          ? (isDark ? Colors.white : NirmaanColors.brandNavy)
                          : (isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey),
                      fontWeight: _selectedFilter == 1 ? FontWeight.w700 : FontWeight.w500,
                    ),
                    onSelected: (_) => setState(() => _selectedFilter = 1),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Group: TODAY
              _SectionDivider(title: 'TODAY', isDark: isDark),
              ...filteredList.take(2).map((notif) => _NotificationCard(
                    notification: notif,
                    isDark: isDark,
                  )),

              const SizedBox(height: NirmaanDimens.md),

              // Group: YESTERDAY
              _SectionDivider(title: 'YESTERDAY', isDark: isDark),
              ...filteredList.skip(2).map((notif) => _NotificationCard(
                    notification: notif,
                    isDark: isDark,
                  )),

              const SizedBox(height: NirmaanDimens.xl),

              // You're all caught up! banner
              Container(
                padding: const EdgeInsets.all(NirmaanDimens.base),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                  borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                  border: Border.all(
                    color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.done_all_rounded, size: 20, color: NirmaanColors.brandRoyalBlue),
                    const SizedBox(width: 8),
                    Text(
                      "You're all caught up!",
                      style: NirmaanTypography.titleMedium.copyWith(
                        color: NirmaanColors.brandRoyalBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.xxl),
            ],
          );
        },
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.title, required this.isDark});
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: NirmaanTypography.labelSmall.copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
          color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
        ),
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({
    required this.notification,
    required this.isDark,
  });

  final NotificationModel notification;
  final bool isDark;

  StatusPillVariant get _pillVariant {
    switch (notification.type) {
      case 'LOW STOCK':
        return StatusPillVariant.danger;
      case 'AI INSIGHT':
        return StatusPillVariant.info;
      case 'CUSTOMER':
        return StatusPillVariant.warning;
      case 'SALES':
        return StatusPillVariant.success;
      default:
        return StatusPillVariant.info;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: NirmaanDimens.sm),
      padding: const EdgeInsets.all(NirmaanDimens.base),
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
        borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
        border: Border.all(
          color: notification.isRead
              ? (isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder)
              : NirmaanColors.brandRoyalBlue.withValues(alpha: 0.4),
          width: notification.isRead ? 1 : 1.5,
        ),
        boxShadow: isDark ? NirmaanShadows.cardShadowDark : NirmaanShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusPill(
                label: notification.type,
                variant: _pillVariant,
              ),
              const Spacer(),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: NirmaanColors.brandRoyalBlue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notification.title,
            style: NirmaanTypography.titleMedium.copyWith(
              color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            notification.body,
            style: NirmaanTypography.bodySmall.copyWith(
              color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          // Inline action button
          Row(
            children: [
              if (notification.actionLabel != null)
                FilledButton.tonal(
                  onPressed: () {
                    ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                    if (notification.actionRoute != null) {
                      context.push(notification.actionRoute!);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                    foregroundColor: NirmaanColors.brandNavy,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(NirmaanDimens.pillRadius),
                    ),
                  ),
                  child: Text(
                    notification.actionLabel!,
                    style: NirmaanTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: NirmaanColors.brandNavy,
                    ),
                  ),
                ),
              const Spacer(),
              if (!notification.isRead)
                TextButton(
                  onPressed: () {
                    ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                  },
                  child: Text(
                    'Dismiss',
                    style: NirmaanTypography.labelSmall.copyWith(
                      color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// More Screen — Settings hub including Appearance (dark mode toggle).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/widgets/widgets.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: const NirmaanAppBar.sub(title: 'More'),
      body: ListView(
        padding: const EdgeInsets.all(NirmaanDimens.base),
        children: [
          // ── Business Profile ────────────────────────────────────────
          _SectionTitle('Business Profile'),
          _SettingsTile(
            icon: Icons.store_outlined,
            title: 'Store Settings',
            subtitle: 'Business name, address, GST',
            isDark: isDark,
          ),
          _SettingsTile(
            icon: Icons.print_outlined,
            title: 'Invoice & Billing',
            subtitle: 'Templates, receipt settings',
            isDark: isDark,
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── Appearance ─────────────────────────────────────────────
          _SectionTitle('Appearance'),
          Container(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
              border: Border.all(
                color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  color: NirmaanColors.brandRoyalBlue,
                ),
                const SizedBox(width: NirmaanDimens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dark Mode',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        isDark ? 'On' : 'Off',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: isDark,
                  activeTrackColor: NirmaanColors.brandAccentGreen,
                  onChanged: (_) {
                    ref.read(themeModeProvider.notifier).toggle();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── Data & Sync ────────────────────────────────────────────
          _SectionTitle('Data & Sync'),
          _SettingsTile(
            icon: Icons.cloud_sync_outlined,
            title: 'Cloud Backup',
            subtitle: 'Last synced 5 min ago',
            isDark: isDark,
            trailing: const StatusPill(
              label: 'Live',
              variant: StatusPillVariant.success,
            ),
          ),
          _SettingsTile(
            icon: Icons.download_outlined,
            title: 'Export Data',
            subtitle: 'PDF, Excel, CSV',
            isDark: isDark,
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── Support ────────────────────────────────────────────────
          _SectionTitle('Support'),
          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & FAQ',
            subtitle: 'Get assistance',
            isDark: isDark,
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'About Nirmaan',
            subtitle: 'Version 1.0.0',
            isDark: isDark,
          ),

          const SizedBox(height: NirmaanDimens.xxl),
        ],
      ),
    );
  }
}

// ─── Helper widgets ──────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: NirmaanDimens.md),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: NirmaanDimens.sm),
      padding: const EdgeInsets.all(NirmaanDimens.base),
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
        borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
        border: Border.all(
          color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: NirmaanColors.brandRoyalBlue, size: 22),
          const SizedBox(width: NirmaanDimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          ?trailing,
          if (trailing == null)
            Icon(Icons.chevron_right,
                color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                size: 20),
        ],
      ),
    );
  }
}

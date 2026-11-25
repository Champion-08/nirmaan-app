import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../data/providers/app_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _language = 'English';

  // Notification toggles
  bool _businessAlerts = true;
  bool _dailyBrief = true;
  bool _lowStockAlerts = true;
  bool _customerAlerts = true;
  bool _aiRecommendations = true;
  bool _marketingUpdates = false;

  // Business preferences
  bool _autoSync = true;
  bool _roundOff = true;
  bool _printReceipt = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: const NirmaanAppBar.sub(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(NirmaanDimens.base),
        children: [
          // ── APP PREFERENCES ──────────────────────────────────────────
          _SectionHeader(title: 'APP PREFERENCES', isDark: isDark),
          Container(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
              border: Border.all(
                color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Appearance', style: NirmaanTypography.titleMedium),
                const SizedBox(height: 10),
                // Light / Dark / System Segmented Button
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode_outlined, size: 16),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode_outlined, size: 16),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(Icons.phone_android_rounded, size: 16),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      ref.read(themeModeProvider.notifier).setMode(newSelection.first);
                    },
                  ),
                ),

                const Divider(height: 24),

                // Language dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('App Language', style: NirmaanTypography.titleMedium),
                        Text('Preferred interface language', style: NirmaanTypography.bodySmall),
                      ],
                    ),
                    DropdownButton<String>(
                      value: _language,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
                      items: const [
                        DropdownMenuItem(value: 'English', child: Text('English')),
                        DropdownMenuItem(value: 'Hindi', child: Text('Hindi (हिंदी)')),
                        DropdownMenuItem(value: 'Gujarati', child: Text('Gujarati (ગુજરાતી)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _language = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── NOTIFICATIONS TOGGLES ────────────────────────────────────
          _SectionHeader(title: 'NOTIFICATIONS', isDark: isDark),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
              border: Border.all(
                color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
              ),
            ),
            child: Column(
              children: [
                _SwitchTile(
                  title: 'Business Alerts',
                  subtitle: 'Urgent balance, invoice & sync warnings',
                  value: _businessAlerts,
                  onChanged: (v) => setState(() => _businessAlerts = v),
                ),
                const Divider(height: 1),
                _SwitchTile(
                  title: 'Daily Business Brief',
                  subtitle: 'Morning summary of sales & targets',
                  value: _dailyBrief,
                  onChanged: (v) => setState(() => _dailyBrief = v),
                ),
                const Divider(height: 1),
                _SwitchTile(
                  title: 'Low Stock Alerts',
                  subtitle: 'Pings when items drop below threshold',
                  value: _lowStockAlerts,
                  onChanged: (v) => setState(() => _lowStockAlerts = v),
                ),
                const Divider(height: 1),
                _SwitchTile(
                  title: 'Customer Alerts',
                  subtitle: 'VIP visits & overdue accounts',
                  value: _customerAlerts,
                  onChanged: (v) => setState(() => _customerAlerts = v),
                ),
                const Divider(height: 1),
                _SwitchTile(
                  title: 'AI Recommendations',
                  subtitle: 'Smart stocking & pricing suggestions',
                  value: _aiRecommendations,
                  onChanged: (v) => setState(() => _aiRecommendations = v),
                ),
                const Divider(height: 1),
                _SwitchTile(
                  title: 'Marketing Updates',
                  subtitle: 'Seasonal promo kits & festival reminders',
                  value: _marketingUpdates,
                  onChanged: (v) => setState(() => _marketingUpdates = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── BUSINESS PREFERENCES ─────────────────────────────────────
          _SectionHeader(title: 'BUSINESS PREFERENCES', isDark: isDark),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
              border: Border.all(
                color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
              ),
            ),
            child: Column(
              children: [
                _SwitchTile(
                  title: 'Auto-Sync Ledger',
                  subtitle: 'Sync changes to cloud every 60 seconds',
                  value: _autoSync,
                  onChanged: (v) => setState(() => _autoSync = v),
                ),
                const Divider(height: 1),
                _SwitchTile(
                  title: 'Round-off Totals',
                  subtitle: 'Round final bill amounts to nearest Rupee',
                  value: _roundOff,
                  onChanged: (v) => setState(() => _roundOff = v),
                ),
                const Divider(height: 1),
                _SwitchTile(
                  title: 'Print Receipt on Checkout',
                  subtitle: 'Automatically trigger thermal printer',
                  value: _printReceipt,
                  onChanged: (v) => setState(() => _printReceipt = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── ACCOUNT & LOGOUT ─────────────────────────────────────────
          _SectionHeader(title: 'ACCOUNT', isDark: isDark),
          Container(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
              border: Border.all(
                color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Signed in as Rahul Sharma',
                  style: NirmaanTypography.titleMedium,
                ),
                Text(
                  'rahul@shreekrishnagrocery.in',
                  style: NirmaanTypography.bodySmall,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      await auth.signOut();
                      if (!context.mounted) return;
                      context.go('/login');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: NirmaanColors.dangerText),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(NirmaanDimens.buttonRadius),
                      ),
                    ),
                    child: Text(
                      'Log Out of Nirmaan',
                      style: NirmaanTypography.button.copyWith(color: NirmaanColors.dangerText),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xxl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.isDark});
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

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: NirmaanTypography.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: NirmaanTypography.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: NirmaanColors.brandNavy,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

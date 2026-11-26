import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/app_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storeAsync = ref.watch(storeProvider);
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: const NirmaanAppBar.sub(title: 'Merchant Profile'),
      body: storeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load profile')),
        data: (store) => RefreshIndicator(
          color: NirmaanColors.brandNavy,
          onRefresh: () async {
            HapticFeedback.lightImpact();
            ref.invalidate(storeProvider);
            await ref.read(storeProvider.future);
          },
          child: ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 100),
            children: [
            // Header card with RS avatar, name, badges & Edit Profile
            Container(
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
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: NirmaanColors.brandNavy,
                        child: Text(
                          'RS',
                          style: NirmaanTypography.headlineLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: NirmaanColors.brandRoyalBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? NirmaanColors.darkCard : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    store.ownerName,
                    style: NirmaanTypography.headlineMedium.copyWith(
                      color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: NirmaanColors.infoBg,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'Business Owner',
                          style: NirmaanTypography.labelSmall.copyWith(
                            color: NirmaanColors.infoText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: NirmaanColors.successBg,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 12, color: NirmaanColors.successText),
                            const SizedBox(width: 4),
                            Text(
                              'KYC Verified',
                              style: NirmaanTypography.labelSmall.copyWith(
                                color: NirmaanColors.successText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.push('/business-setup');
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(120, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(NirmaanDimens.buttonRadius),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: NirmaanDimens.xl),

            // BUSINESS INFORMATION CARD
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'BUSINESS INFORMATION',
                style: NirmaanTypography.labelSmall.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                  color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                ),
              ),
            ),
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
                children: [
                  _InfoRow(
                    label: 'GST Status',
                    valueWidget: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: NirmaanColors.successBg,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'GST Registered',
                        style: NirmaanTypography.labelSmall.copyWith(
                          color: NirmaanColors.successText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    isDark: isDark,
                  ),
                  const Divider(height: 20),
                  _InfoRow(label: 'Store Name', value: store.businessName, isDark: isDark),
                  const Divider(height: 20),
                  _InfoRow(label: 'Category', value: store.category, isDark: isDark),
                  const Divider(height: 20),
                  _InfoRow(label: 'Mobile', value: store.phone, isDark: isDark),
                  const Divider(height: 20),
                  _InfoRow(label: 'Email', value: store.email ?? 'rahul@shreekrishnagrocery.in', isDark: isDark),
                  const Divider(height: 20),
                  _InfoRow(label: 'Currency', value: '₹ INR', isDark: isDark),
                  const Divider(height: 20),
                  _InfoRow(label: 'Hours', value: store.businessHours, isDark: isDark),
                ],
              ),
            ),

            const SizedBox(height: NirmaanDimens.xl),

            // ACCOUNT & PREFERENCES
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'ACCOUNT & PREFERENCES',
                style: NirmaanTypography.labelSmall.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                  color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                border: Border.all(
                  color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings_outlined, color: NirmaanColors.brandRoyalBlue),
                      title: Text('Settings & Notifications', style: NirmaanTypography.titleMedium),
                      subtitle: Text('Theme, language & alerts', style: NirmaanTypography.bodySmall),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.push('/settings');
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.notifications_active_outlined, color: NirmaanColors.brandRoyalBlue),
                      title: Text('Notification Center', style: NirmaanTypography.titleMedium),
                      subtitle: Text('Recent business triggers', style: NirmaanTypography.bodySmall),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.push('/notifications');
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: NirmaanDimens.xl),

            // Soft Red Log Out Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  await auth.signOut();
                  if (!context.mounted) return;
                  context.go('/login');
                },
                icon: const Icon(Icons.logout_rounded, color: NirmaanColors.dangerText, size: 20),
                label: Text(
                  'Log Out',
                  style: NirmaanTypography.button.copyWith(
                    color: NirmaanColors.dangerText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: NirmaanColors.dangerBg.withValues(alpha: 0.5),
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(NirmaanDimens.buttonRadius),
                  ),
                ),
              ),
            ),

            const SizedBox(height: NirmaanDimens.xxl),
          ],
        ),
      ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    this.value,
    this.valueWidget,
    required this.isDark,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: NirmaanTypography.bodyMedium.copyWith(
              color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        valueWidget ??
            Flexible(
              child: Text(
                value ?? '',
                style: NirmaanTypography.titleMedium.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
      ],
    );
  }
}

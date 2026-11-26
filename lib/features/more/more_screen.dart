import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../ai_intelligence/presentation/business_twin_simulator_sheet.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  Future<void> _openWhatsApp() async {
    HapticFeedback.lightImpact();
    final uri = Uri.parse('https://wa.me/919876543210?text=Hello%20Nirmaan%20Support');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: const NirmaanAppBar.sub(title: 'More Hub'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 100),
        children: [
          // Branch #1 • Active Pill
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: NirmaanColors.brandRoyalBlue.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: NirmaanColors.brandAccentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Branch #1 • Active',
                      style: NirmaanTypography.labelSmall.copyWith(
                        color: NirmaanColors.brandNavy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: NirmaanDimens.md),

          // Hero Banner "Operational Command - Manage your business smarter"
          Container(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [NirmaanColors.brandNavy, NirmaanColors.brandRoyalBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.trending_up_rounded, size: 16, color: NirmaanColors.brandAccentGreen),
                          const SizedBox(width: 6),
                          Text(
                            'Operational Command',
                            style: NirmaanTypography.labelSmall.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Manage your business smarter.',
                        style: NirmaanTypography.headlineMedium.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bolt_rounded, size: 28, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // Operational Navigation Cards
          _CommandHubTile(
            icon: Icons.auto_awesome_rounded,
            title: 'AI Business Coach',
            badgeText: 'Smart',
            subtitle: 'Real-time sales & inventory optimization',
            isDark: isDark,
            onTap: () => context.push('/ai-coach'),
          ),
          _CommandHubTile(
            icon: Icons.today_rounded,
            title: "Today's Business",
            subtitle: 'Daily ledger, counter cash & live bills',
            isDark: isDark,
            onTap: () => context.go('/'),
          ),
          _CommandHubTile(
            icon: Icons.model_training_rounded,
            title: 'Business Twin Simulator',
            badgeText: 'AI Sim',
            subtitle: 'Simulate margin, inventory & evening hour levers',
            isDark: isDark,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const BusinessTwinSimulatorSheet(),
              );
            },
          ),
          _CommandHubTile(
            icon: Icons.bar_chart_rounded,
            title: 'Business Analytics',
            subtitle: 'Revenue trends, top selling items & margins',
            isDark: isDark,
            onTap: () => context.push('/analytics'),
          ),
          _CommandHubTile(
            icon: Icons.health_and_safety_outlined,
            title: 'Business Health',
            subtitle: 'Overall store score: 82/100 (Optimal)',
            showGreenDot: true,
            isDark: isDark,
            onTap: () => context.push('/business-health'),
          ),
          _CommandHubTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'App appearance, languages & notification rules',
            isDark: isDark,
            onTap: () => context.push('/settings'),
          ),

          const SizedBox(height: NirmaanDimens.lg),

          // WhatsApp Support Card
          GestureDetector(
            onTap: _openWhatsApp,
            child: Container(
              padding: const EdgeInsets.all(NirmaanDimens.base),
              decoration: BoxDecoration(
                color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                border: Border.all(
                  color: const Color(0xFF25D366).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.chat_rounded, color: Color(0xFF15803D), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need Help? WhatsApp Support',
                          style: NirmaanTypography.titleMedium.copyWith(
                            color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Chat directly with Nirmaan merchant advisors',
                          style: NirmaanTypography.bodySmall.copyWith(
                            color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.open_in_new_rounded, size: 18, color: Color(0xFF15803D)),
                ],
              ),
            ),
          ),

          const SizedBox(height: NirmaanDimens.xxl),
        ],
      ),
    );
  }
}

class _CommandHubTile extends StatelessWidget {
  const _CommandHubTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
    this.badgeText,
    this.showGreenDot = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;
  final String? badgeText;
  final bool showGreenDot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: NirmaanDimens.sm),
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
        child: ListTile(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: NirmaanColors.brandRoyalBlue, size: 20),
          ),
          title: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: NirmaanTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badgeText != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: NirmaanColors.infoBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText!,
                    style: NirmaanTypography.labelSmall.copyWith(
                      color: NirmaanColors.infoText,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (showGreenDot) ...[
                const SizedBox(width: 6),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: NirmaanColors.brandAccentGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          subtitle: Text(
            subtitle,
            style: NirmaanTypography.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        ),
      ),
    );
  }
}

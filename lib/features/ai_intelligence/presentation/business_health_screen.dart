import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

class BusinessHealthScreen extends StatelessWidget {
  const BusinessHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: NirmaanAppBar.sub(
        title: 'Business Health',
      ),
      body: RefreshIndicator(
        color: NirmaanColors.brandNavy,
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 100),
          children: [
            // ── OVERALL INDEX (Week 42 Diagnostic) ────────────────────────
            Container(
              padding: const EdgeInsets.all(NirmaanDimens.xl),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('OVERALL INDEX', style: NirmaanTypography.labelSmall.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                      const StatusPill(label: '• Healthy', variant: StatusPillVariant.success),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Circular Progress Gauge
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: 0.82,
                          strokeWidth: 12,
                          backgroundColor: isDark ? NirmaanColors.darkCardBorder : const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(NirmaanColors.brandNavy),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('82', style: NirmaanTypography.displayLarge.copyWith(fontWeight: FontWeight.w800, fontSize: 40)),
                          Text('/ 100', style: NirmaanTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Updated today at 9:00 AM • Top 15% in your locality',
                    style: NirmaanTypography.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: NirmaanDimens.lg),

            // Nirmaan says [AI Alert] Card
            Container(
              padding: const EdgeInsets.all(NirmaanDimens.base),
              decoration: BoxDecoration(
                color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                border: Border.all(color: NirmaanColors.brandRoyalBlue.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: NirmaanColors.brandRoyalBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Nirmaan says', style: NirmaanTypography.titleMedium),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: NirmaanColors.warningBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('AI Alert', style: TextStyle(color: NirmaanColors.warningText, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Restock Fortune Sunflower Oil & Atta before Friday to protect ~₹6,200 in weekend sales.',
                          style: NirmaanTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: NirmaanDimens.xl),

            // ── Performance Breakdown (4 key metrics) 2x2 Grid ────────────
            Text('Performance Breakdown (4 key metrics)', style: NirmaanTypography.titleLarge),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: NirmaanDimens.md,
              crossAxisSpacing: NirmaanDimens.md,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.18,
              children: [
                _MetricHealthCard(title: 'Sales Pacing', score: '88/100', status: 'Good', isDark: isDark, isWarning: false),
                _MetricHealthCard(title: 'Inventory Turn', score: '78/100', status: 'Action', isDark: isDark, isWarning: true),
                _MetricHealthCard(title: 'Customer Loyalty', score: '84/100', status: 'Good', isDark: isDark, isWarning: false),
                _MetricHealthCard(title: 'Net Profit Margin', score: '82/100', status: 'Good', isDark: isDark, isWarning: false),
              ],
            ),

            const SizedBox(height: NirmaanDimens.xl),

            // ── Recommended Actions (3 Prioritized) ──────────────────────
            Text('Recommended Actions (3 prioritized)', style: NirmaanTypography.titleLarge),
            const SizedBox(height: 10),

            _ActionCard(
              priority: 'HIGH',
              priorityColor: NirmaanColors.dangerBg,
              priorityTextColor: NirmaanColors.dangerText,
              title: 'Restock Sunflower Oil & Chakki Atta',
              subtitle: 'Critical stock-out risk within 18 hrs',
              isDark: isDark,
            ),
            _ActionCard(
              priority: 'MED',
              priorityColor: NirmaanColors.warningBg,
              priorityTextColor: NirmaanColors.warningText,
              title: 'Send WhatsApp Retention Broadcast',
              subtitle: 'Target 4 inactive VIPs with weekend coupon',
              isDark: isDark,
            ),
            _ActionCard(
              priority: 'ROUTINE',
              priorityColor: NirmaanColors.infoBg,
              priorityTextColor: NirmaanColors.infoText,
              title: 'Settle Supplier Invoices',
              subtitle: 'Amul distributor invoice due in 3 days',
              isDark: isDark,
            ),

            const SizedBox(height: NirmaanDimens.xl),

            SizedBox(
              width: double.infinity,
              child: PrimaryNavyButton(
                label: 'View Detailed Recommendations',
                onPressed: () => context.push('/ai-coach'),
              ),
            ),

            const SizedBox(height: NirmaanDimens.xxl),
          ],
        ),
      ),
    );
  }
}

class _MetricHealthCard extends StatelessWidget {
  const _MetricHealthCard({
    required this.title,
    required this.score,
    required this.status,
    required this.isDark,
    required this.isWarning,
  });

  final String title;
  final String score;
  final String status;
  final bool isDark;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(NirmaanDimens.base),
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
        borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
        border: Border.all(
          color: isWarning ? const Color(0xFFFCD34D) : (isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status,
                style: TextStyle(
                  color: isWarning ? NirmaanColors.warningText : NirmaanColors.successText,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                isWarning ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                size: 14,
                color: isWarning ? NirmaanColors.warningText : NirmaanColors.successText,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(score, style: NirmaanTypography.headlineLarge.copyWith(fontSize: 22)),
              const SizedBox(height: 2),
              Text(title, style: NirmaanTypography.bodySmall.copyWith(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.priority,
    required this.priorityColor,
    required this.priorityTextColor,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  final String priority;
  final Color priorityColor;
  final Color priorityTextColor;
  final String title;
  final String subtitle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(NirmaanDimens.base),
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(priority, style: TextStyle(color: priorityTextColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: NirmaanTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: NirmaanTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

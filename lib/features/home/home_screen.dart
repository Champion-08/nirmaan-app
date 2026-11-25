/// Home Screen — Dashboard with KPI cards and AI insights.
library;

import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const NirmaanAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(NirmaanDimens.base),
        children: [
          // ── Greeting ───────────────────────────────────────────────
          Text(
            'Good Evening 👋',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s your business pulse for today',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: NirmaanDimens.xl),

          // ── AI Pulse Card ──────────────────────────────────────────
          AiPulseCard(
            icon: Icons.auto_awesome_rounded,
            title: 'AI Business Pulse',
            subtitle:
                'Revenue trending +12% this week. 3 items need restocking.',
            trailing: const Icon(
              Icons.chevron_right,
              color: NirmaanColors.brandRoyalBlue,
            ),
          ),
          const SizedBox(height: NirmaanDimens.base),

          // ── KPI Grid ───────────────────────────────────────────────
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: NirmaanDimens.md,
            crossAxisSpacing: NirmaanDimens.md,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.45,
            children: const [
              KpiMetricCard(
                label: 'Today\'s Revenue',
                value: '₹24,560',
                delta: '+12.3%',
                deltaPositive: true,
                icon: Icons.currency_rupee,
              ),
              KpiMetricCard(
                label: 'Pending Orders',
                value: '8',
                delta: '3 urgent',
                deltaPositive: false,
                icon: Icons.receipt_long_outlined,
              ),
              KpiMetricCard(
                label: 'Low Stock Items',
                value: '5',
                delta: '2 critical',
                deltaPositive: false,
                icon: Icons.inventory_2_outlined,
              ),
              KpiMetricCard(
                label: 'Active Customers',
                value: '142',
                delta: '+8 this week',
                deltaPositive: true,
                icon: Icons.people_outline,
              ),
            ],
          ),
          const SizedBox(height: NirmaanDimens.xl),

          // ── Quick Actions ──────────────────────────────────────────
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: NirmaanDimens.md),
          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.add_shopping_cart_rounded,
                  label: 'New Sale',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: NirmaanDimens.md),
              Expanded(
                child: _QuickAction(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan Item',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: NirmaanDimens.md),
              Expanded(
                child: _QuickAction(
                  icon: Icons.person_add_alt_1_rounded,
                  label: 'Add Customer',
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: NirmaanDimens.xl),

          // ── Recent Transactions ────────────────────────────────────
          Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: NirmaanDimens.md),
          ...List.generate(3, (i) {
            final names = ['Rahul Sharma', 'Priya Patel', 'Amit Singh'];
            final amounts = ['₹1,250', '₹3,400', '₹890'];
            final statuses = [
              StatusPillVariant.success,
              StatusPillVariant.warning,
              StatusPillVariant.success,
            ];
            final statusLabels = ['Paid', 'Pending', 'Paid'];

            return Container(
              margin: const EdgeInsets.only(bottom: NirmaanDimens.sm),
              padding: const EdgeInsets.all(NirmaanDimens.base),
              decoration: BoxDecoration(
                color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                border: Border.all(
                  color: isDark
                      ? NirmaanColors.darkCardBorder
                      : NirmaanColors.cardBorder,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(names[i],
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text('Invoice #${1001 + i}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(amounts[i],
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      StatusPill(
                        label: statusLabels[i],
                        variant: statuses[i],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: NirmaanDimens.xxl),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: NirmaanDimens.base,
        horizontal: NirmaanDimens.sm,
      ),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? NirmaanColors.darkTintedHighlight
                  : NirmaanColors.tintedHighlight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: NirmaanColors.brandRoyalBlue),
          ),
          const SizedBox(height: NirmaanDimens.sm),
          Text(
            label,
            style: NirmaanTypography.labelMedium.copyWith(
              color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

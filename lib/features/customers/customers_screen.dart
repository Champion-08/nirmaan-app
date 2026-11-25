/// Customers Screen — Placeholder for the CRM module.
library;

import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';
import '../../core/theme/theme.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final customers = [
      _Customer('Rahul Sharma', 'VIP • 24 orders', StatusPillVariant.info, 'VIP'),
      _Customer('Priya Patel', '12 orders', StatusPillVariant.success, 'Active'),
      _Customer('Amit Singh', '3 orders', StatusPillVariant.success, 'Active'),
      _Customer('Neha Gupta', 'Overdue ₹2,400', StatusPillVariant.danger, 'Overdue'),
      _Customer('Vikram Reddy', '8 orders', StatusPillVariant.success, 'Active'),
    ];

    return Scaffold(
      appBar: const NirmaanAppBar.sub(title: 'Customers', actionLabel: '+ Add'),
      body: ListView(
        padding: const EdgeInsets.all(NirmaanDimens.base),
        children: [
          // Search
          TextField(
            decoration: InputDecoration(
              hintText: 'Search customers...',
              prefixIcon: const Icon(Icons.search, size: 20),
              constraints: const BoxConstraints(maxHeight: NirmaanDimens.inputHeight),
            ),
          ),
          const SizedBox(height: NirmaanDimens.base),

          Row(
            children: const [
              Expanded(
                child: KpiMetricCard(
                  label: 'Total Customers',
                  value: '142',
                  delta: '+8 this week',
                  deltaPositive: true,
                  icon: Icons.people_outline,
                ),
              ),
              SizedBox(width: NirmaanDimens.md),
              Expanded(
                child: KpiMetricCard(
                  label: 'Outstanding',
                  value: '₹18.2K',
                  delta: '4 overdue',
                  deltaPositive: false,
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: NirmaanDimens.xl),

          Text('All Customers', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: NirmaanDimens.md),

          ...customers.map((c) {
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
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: NirmaanColors.tintedHighlight,
                    child: Text(
                      c.name[0],
                      style: NirmaanTypography.titleLarge.copyWith(
                        color: NirmaanColors.brandNavy,
                      ),
                    ),
                  ),
                  const SizedBox(width: NirmaanDimens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(c.subtitle,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  StatusPill(label: c.pillLabel, variant: c.variant),
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

class _Customer {
  const _Customer(this.name, this.subtitle, this.variant, this.pillLabel);
  final String name;
  final String subtitle;
  final StatusPillVariant variant;
  final String pillLabel;
}

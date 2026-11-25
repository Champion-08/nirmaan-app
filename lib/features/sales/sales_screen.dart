/// Sales Screen — Placeholder for the Sales module.
library;

import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';
import '../../core/theme/theme.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const NirmaanAppBar.sub(title: 'Sales', actionLabel: '+ New Sale'),
      body: ListView(
        padding: const EdgeInsets.all(NirmaanDimens.base),
        children: [
          AiPulseCard(
            icon: Icons.insights_rounded,
            title: 'Sales Insight',
            subtitle: 'Peak hours are between 11 AM – 2 PM. Consider running a promotion.',
          ),
          const SizedBox(height: NirmaanDimens.xl),
          Text('Today\'s Sales', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: NirmaanDimens.md),
          ...List.generate(5, (i) {
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sale #${2001 + i}',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text('${3 + i} items • Cash',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Text('₹${(i + 1) * 450}',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            );
          }),
          const SizedBox(height: NirmaanDimens.xl),
          PrimaryNavyButton(label: 'Create New Sale', onPressed: () {}),
          const SizedBox(height: NirmaanDimens.xxl),
        ],
      ),
    );
  }
}

/// Inventory Screen — Placeholder for Inventory management.
library;

import 'package:flutter/material.dart';
import '../../core/widgets/widgets.dart';
import '../../core/theme/theme.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      _StockItem('Basmati Rice 5kg', '42', StatusPillVariant.success, 'In Stock'),
      _StockItem('Toor Dal 1kg', '8', StatusPillVariant.warning, 'Low Stock'),
      _StockItem('Mustard Oil 1L', '0', StatusPillVariant.danger, 'Out of Stock'),
      _StockItem('Sugar 2kg', '65', StatusPillVariant.success, 'In Stock'),
      _StockItem('Wheat Flour 10kg', '5', StatusPillVariant.warning, 'Low Stock'),
    ];

    return Scaffold(
      appBar: const NirmaanAppBar.sub(title: 'Inventory', actionLabel: '+ Add Item'),
      body: ListView(
        padding: const EdgeInsets.all(NirmaanDimens.base),
        children: [
          // Search
          TextField(
            decoration: InputDecoration(
              hintText: 'Search inventory...',
              prefixIcon: const Icon(Icons.search, size: 20),
              constraints: const BoxConstraints(maxHeight: NirmaanDimens.inputHeight),
            ),
          ),
          const SizedBox(height: NirmaanDimens.base),

          // Stats row
          Row(
            children: const [
              Expanded(
                child: KpiMetricCard(
                  label: 'Total Items',
                  value: '248',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              SizedBox(width: NirmaanDimens.md),
              Expanded(
                child: KpiMetricCard(
                  label: 'Low Stock',
                  value: '5',
                  delta: '2 critical',
                  deltaPositive: false,
                  icon: Icons.warning_amber_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: NirmaanDimens.xl),

          Text('All Items', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: NirmaanDimens.md),

          ...items.map((item) {
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
                        Text(item.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('Qty: ${item.qty}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  StatusPill(label: item.statusLabel, variant: item.variant),
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

class _StockItem {
  const _StockItem(this.name, this.qty, this.variant, this.statusLabel);
  final String name;
  final String qty;
  final StatusPillVariant variant;
  final String statusLabel;
}

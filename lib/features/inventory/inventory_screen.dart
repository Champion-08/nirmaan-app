import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers/app_providers.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: NirmaanAppBar.sub(
        title: 'Inventory',
        actionLabel: '+ Add',
        onAction: () {
          HapticFeedback.lightImpact();
          context.push('/add-product');
        },
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load inventory')),
        data: (products) {
          final lowStockList = products.where((p) => p.isLowStock || p.isOutOfStock).toList();
          final outOfStockCount = products.where((p) => p.isOutOfStock).length;
          final lowStockCount = products.where((p) => p.isLowStock).length;

          return RefreshIndicator(
            color: NirmaanColors.brandNavy,
            onRefresh: () async {
              HapticFeedback.lightImpact();
              ref.invalidate(productsProvider);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 100),
              children: [
              // 3 Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _MiniSummaryCard(
                      label: 'Total Items',
                      value: '${products.length}',
                      subtitle: 'Active SKUs',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniSummaryCard(
                      label: 'Low Stock',
                      value: '$lowStockCount',
                      subtitle: 'Needs PO',
                      valueColor: NirmaanColors.warningText,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniSummaryCard(
                      label: 'Out of Stock',
                      value: '$outOfStockCount',
                      subtitle: 'Urgent',
                      valueColor: NirmaanColors.dangerText,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Dark Navy Nirmaan Recommendation [AI PULSE] Card
              Container(
                padding: const EdgeInsets.all(NirmaanDimens.base),
                decoration: BoxDecoration(
                  color: NirmaanColors.brandNavy,
                  borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'AI PULSE RECOMMENDATION',
                            style: NirmaanTypography.labelSmall.copyWith(
                              color: NirmaanColors.brandAccentGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.bolt_rounded, size: 18, color: NirmaanColors.brandAccentGreen),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Consider restocking Coca-Cola 750ml & Fortune Sunflower Oil before Friday.',
                      style: NirmaanTypography.titleMedium.copyWith(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Run-out in ~18 hrs based on weekend consumption spike.',
                      style: NirmaanTypography.bodySmall.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        // Quick reorder action: adds +24 stock
                        final oil = products.firstWhere((p) => p.name.contains('Sunflower'), orElse: () => products.first);
                        ref.read(productsProvider.notifier).updateStock(oil.id, oil.stockQty + 24);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Auto-reordered +24 units via supplier batch PO!'),
                            backgroundColor: NirmaanColors.successText,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: NirmaanColors.brandNavy,
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Quick Reorder ->', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Low Stock [12] Header + Batch PO link
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Low Stock (${lowStockList.length})', style: NirmaanTypography.titleLarge),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Supplier Batch PO drafted for low stock items.')),
                      );
                    },
                    child: Text('Batch PO >', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.brandRoyalBlue, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              ...lowStockList.map((item) {
                final isCritical = item.stockQty == 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: NirmaanDimens.sm),
                  padding: const EdgeInsets.all(NirmaanDimens.base),
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                    borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                    border: Border.all(
                      color: isCritical
                          ? const Color(0xFFFCA5A5)
                          : (isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, color: NirmaanColors.brandRoyalBlue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: NirmaanTypography.titleMedium.copyWith(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text('Qty: ${item.stockQty} remaining', style: NirmaanTypography.bodySmall),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StatusPill(
                            label: isCritical ? 'Critically Low' : 'Low Stock',
                            variant: isCritical ? StatusPillVariant.danger : StatusPillVariant.warning,
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ref.read(productsProvider.notifier).updateStock(item.id, item.stockQty + 20);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Restocked ${item.name} (+20 units)')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: NirmaanColors.brandNavy,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Reorder', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: NirmaanDimens.lg),

              // Fast Moving Products ⚡ row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Fast Moving Products ⚡', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(width: 6),
                      Text('(This Week)', style: NirmaanTypography.bodySmall),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.push('/products');
                    },
                    child: Text('View All (${products.length}) >', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.brandRoyalBlue, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.xxl),
            ],
            ),
          );
        },
      ),
    );
  }
}

class _MiniSummaryCard extends StatelessWidget {
  const _MiniSummaryCard({
    required this.label,
    required this.value,
    required this.subtitle,
    this.valueColor,
    required this.isDark,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color? valueColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          Text(label, style: NirmaanTypography.labelSmall.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            value,
            style: NirmaanTypography.headlineLarge.copyWith(
              color: valueColor ?? (isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark),
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: NirmaanTypography.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}

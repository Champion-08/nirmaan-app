import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/app_providers.dart';
import '../../sales/presentation/new_order_sheet.dart';
import '../../customers/presentation/add_customer_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storeAsync = ref.watch(storeProvider);

    final ownerName = storeAsync.valueOrNull?.ownerName.split(' ').first ?? 'Rahul';

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: const NirmaanAppBar(),
      body: RefreshIndicator(
        color: NirmaanColors.brandNavy,
        onRefresh: () async {
          HapticFeedback.lightImpact();
          ref.invalidate(storeProvider);
          ref.invalidate(ordersProvider);
          ref.invalidate(productsProvider);
          ref.invalidate(customersProvider);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 100),
          children: [
          // ── Greeting Header + AI Badge + Live Sync ────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, $ownerName 👋',
                      style: NirmaanTypography.headlineLarge,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NirmaanColors.infoBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'AI Pulse',
                            style: NirmaanTypography.labelSmall.copyWith(
                              color: NirmaanColors.infoText,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Store operating at 98.4% efficiency',
                          style: NirmaanTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Live Sync green-dot pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: NirmaanColors.brandAccentGreen.withValues(alpha: 0.3),
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
                      'Live Sync',
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

          const SizedBox(height: NirmaanDimens.xl),

          // ── TODAY'S OVERVIEW (Updated 2m ago) ─────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("TODAY'S OVERVIEW", style: NirmaanTypography.labelSmall.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6)),
              Text('Updated 2m ago', style: NirmaanTypography.bodySmall.copyWith(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),

          // 2x2 KPI Grid
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: NirmaanDimens.md,
            crossAxisSpacing: NirmaanDimens.md,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.18,
            children: const [
              KpiMetricCard(
                label: 'Revenue',
                value: '₹24,850',
                delta: '↑ 12% vs. ₹22,180',
                deltaPositive: true,
                icon: Icons.currency_rupee,
              ),
              KpiMetricCard(
                label: 'Orders',
                value: '38',
                delta: '↑ +5 (3 pending)',
                deltaPositive: true,
                icon: Icons.receipt_long_rounded,
              ),
              KpiMetricCard(
                label: 'Net Profit',
                value: '₹6,420',
                delta: '↑ 8% (25.8% margin)',
                deltaPositive: true,
                icon: Icons.pie_chart_outline_rounded,
              ),
              KpiMetricCard(
                label: 'Footfall',
                value: '26',
                delta: '↑ +3 (8 repeats)',
                deltaPositive: true,
                icon: Icons.directions_walk_rounded,
              ),
            ],
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── Today's Brief (AI Pulse Badge) ───────────────────────────
          Container(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [NirmaanColors.darkCard, NirmaanColors.darkTintedHighlight]
                    : [NirmaanColors.tintedHighlight, const Color(0xFFE4EDFC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
              border: Border.all(
                color: NirmaanColors.brandRoyalBlue.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: NirmaanColors.brandRoyalBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Text("Today's Brief", style: NirmaanTypography.titleMedium),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: NirmaanColors.infoBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('AI Pulse', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.infoText, fontSize: 9)),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.push('/daily-brief'),
                      child: Text('Insights >', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.brandRoyalBlue, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '"Revenue is pacing +12.3% above weekly average. Evening beverages & snacks sales spiked."',
                  style: NirmaanTypography.bodyMedium.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: NirmaanColors.brandRoyalBlue),
                    const SizedBox(width: 4),
                    Text(
                      'Peak hours expected between 6 PM - 9 PM',
                      style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.brandRoyalBlue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── What Needs Attention (2 Urgent) ───────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('What Needs Attention', style: NirmaanTypography.titleLarge),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: NirmaanColors.dangerBg,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '2 Urgent',
                  style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.dangerText, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2 Urgent Cards
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push('/products'),
                  child: Container(
                    padding: const EdgeInsets.all(NirmaanDimens.base),
                    decoration: BoxDecoration(
                      color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                      borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 16, color: NirmaanColors.dangerText),
                            const Spacer(),
                            const Icon(Icons.chevron_right, size: 16, color: NirmaanColors.dangerText),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Low Stock Alert', style: NirmaanTypography.titleMedium.copyWith(fontSize: 13)),
                        Text('12 items to reorder', style: NirmaanTypography.bodySmall.copyWith(color: NirmaanColors.dangerText)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.go('/'),
                  child: Container(
                    padding: const EdgeInsets.all(NirmaanDimens.base),
                    decoration: BoxDecoration(
                      color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                      borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                      border: Border.all(color: const Color(0xFFFCD34D)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_pin_circle_outlined, size: 16, color: NirmaanColors.warningText),
                            const Spacer(),
                            const Icon(Icons.chevron_right, size: 16, color: NirmaanColors.warningText),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Follow-up Due', style: NirmaanTypography.titleMedium.copyWith(fontSize: 13)),
                        Text('4 VIPs need restock', style: NirmaanTypography.bodySmall.copyWith(color: NirmaanColors.warningText)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── Quick Actions (+ Sale, + Product, + Customer) ─────────────
          Text('Quick Actions', style: NirmaanTypography.titleLarge),
          const SizedBox(height: 10),
          Row(
            children: [
              // + Sale (Navy filled button)
              Expanded(
                flex: 4,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) => const NewOrderSheet(),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                  label: const Text('+ Sale', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NirmaanColors.brandNavy,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // + Product
              Expanded(
                flex: 4,
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/add-product');
                  },
                  icon: const Icon(Icons.add_box_outlined, size: 18),
                  label: const Text('+ Product'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // + Customer
              Expanded(
                flex: 4,
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    showDialog(
                      context: context,
                      builder: (_) => const AddCustomerDialog(),
                    );
                  },
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('+ Customer'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── Last Transaction ──────────────────────────────────────────
          Text('Last Transaction', style: NirmaanTypography.titleLarge),
          const SizedBox(height: 10),
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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: NirmaanColors.brandNavy,
                  child: const Text('VK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vikram Khanna',
                        style: NirmaanTypography.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Bill #1042 • 4 items • UPI Received',
                        style: NirmaanTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹780.00', style: NirmaanTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('10:42 AM', style: NirmaanTypography.bodySmall.copyWith(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xxl),
        ],
        ),
      ),
    );
  }
}

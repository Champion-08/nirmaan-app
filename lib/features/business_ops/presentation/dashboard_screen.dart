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

  String _formatInr(double amount) {
    final intVal = amount.round();
    if (intVal == 0) return '₹0';
    final s = intVal.toString();
    if (s.length <= 3) return '₹$s';
    final last3 = s.substring(s.length - 3);
    var rest = s.substring(0, s.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    return '₹${parts.join(',')},$last3';
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final min = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $amPm';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storeAsync = ref.watch(currentStoreProvider);
    final ordersAsync = ref.watch(ordersProvider);
    final productsAsync = ref.watch(productsProvider);
    final customersAsync = ref.watch(customersProvider);

    final store = storeAsync.valueOrNull;
    final rawOwner = store?.ownerName.trim() ?? '';
    final ownerName = rawOwner.isNotEmpty ? rawOwner.split(' ').first : 'Merchant';

    final orders = ordersAsync.valueOrNull ?? [];
    final products = productsAsync.valueOrNull ?? [];
    final customers = customersAsync.valueOrNull ?? [];

    final now = DateTime.now();
    final todayOrders = orders.where((o) =>
        o.createdAt.year == now.year &&
        o.createdAt.month == now.month &&
        o.createdAt.day == now.day).toList();

    final revenueToday = todayOrders.fold<double>(0, (sum, o) => sum + o.totalAmount);
    final profitToday = todayOrders.fold<double>(0, (sum, o) => sum + o.netProfit);
    final marginPct = revenueToday > 0 ? (profitToday / revenueToday * 100).toStringAsFixed(1) : '0.0';
    final pendingCount = todayOrders.where((o) => o.status.toLowerCase() == 'pending').length;

    final lowStockCount = products.where((p) => p.isLowStock || p.isOutOfStock).length;
    final followUpCount = customers.where((c) => c.segment.toLowerCase().contains('vip')).length;
    final urgentCount = (lowStockCount > 0 ? 1 : 0) + (followUpCount > 0 ? 1 : 0);
    final lastOrder = orders.isNotEmpty ? orders.first : null;

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
            children: [
              KpiMetricCard(
                label: 'Revenue',
                value: _formatInr(revenueToday),
                delta: todayOrders.isEmpty ? 'No sales today yet' : '${todayOrders.length} bills today',
                deltaPositive: revenueToday > 0,
                icon: Icons.currency_rupee,
              ),
              KpiMetricCard(
                label: 'Orders',
                value: '${todayOrders.length}',
                delta: pendingCount > 0 ? '$pendingCount pending billing' : 'All bills settled',
                deltaPositive: todayOrders.isNotEmpty,
                icon: Icons.receipt_long_rounded,
              ),
              KpiMetricCard(
                label: 'Net Profit',
                value: _formatInr(profitToday),
                delta: '$marginPct% margin',
                deltaPositive: profitToday > 0,
                icon: Icons.pie_chart_outline_rounded,
              ),
              KpiMetricCard(
                label: 'Footfall',
                value: '${todayOrders.length}',
                delta: '${customers.length} total customers',
                deltaPositive: todayOrders.isNotEmpty,
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
                  orders.isEmpty && products.isEmpty
                      ? '"Welcome to Nirmaan! Add your first products and record a sale to unlock AI insights."'
                      : '"You have ${products.length} products in catalogue and ${todayOrders.length} orders today totaling ${_formatInr(revenueToday)}."',
                  style: NirmaanTypography.bodyMedium.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: NirmaanColors.brandRoyalBlue),
                    const SizedBox(width: 4),
                    Text(
                      lowStockCount > 0
                          ? '$lowStockCount items need restocking soon'
                          : 'Store inventory is looking healthy',
                      style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.brandRoyalBlue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── What Needs Attention ──────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('What Needs Attention', style: NirmaanTypography.titleLarge),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: urgentCount > 0 ? NirmaanColors.dangerBg : NirmaanColors.successBg,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  urgentCount > 0 ? '$urgentCount Urgent' : 'All Clear',
                  style: NirmaanTypography.labelSmall.copyWith(
                    color: urgentCount > 0 ? NirmaanColors.dangerText : NirmaanColors.successText,
                    fontWeight: FontWeight.w700,
                  ),
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
                  onTap: () => context.push(products.isEmpty ? '/add-product' : '/products'),
                  child: Container(
                    padding: const EdgeInsets.all(NirmaanDimens.base),
                    decoration: BoxDecoration(
                      color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                      borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                      border: Border.all(
                        color: lowStockCount > 0 ? const Color(0xFFFCA5A5) : (isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              lowStockCount > 0 ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                              size: 16,
                              color: lowStockCount > 0 ? NirmaanColors.dangerText : NirmaanColors.brandRoyalBlue,
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: lowStockCount > 0 ? NirmaanColors.dangerText : NirmaanColors.bodyGrey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Low Stock Alert', style: NirmaanTypography.titleMedium.copyWith(fontSize: 13)),
                        Text(
                          products.isEmpty
                              ? 'Tap + Product to add'
                              : (lowStockCount > 0 ? '$lowStockCount items to reorder' : 'All items stocked'),
                          style: NirmaanTypography.bodySmall.copyWith(
                            color: lowStockCount > 0 ? NirmaanColors.dangerText : (isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                      border: Border.all(
                        color: followUpCount > 0 ? const Color(0xFFFCD34D) : (isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_pin_circle_outlined,
                              size: 16,
                              color: followUpCount > 0 ? NirmaanColors.warningText : NirmaanColors.brandRoyalBlue,
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: followUpCount > 0 ? NirmaanColors.warningText : NirmaanColors.bodyGrey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Follow-up Due', style: NirmaanTypography.titleMedium.copyWith(fontSize: 13)),
                        Text(
                          customers.isEmpty
                              ? 'No customers yet'
                              : (followUpCount > 0 ? '$followUpCount VIPs to contact' : '${customers.length} active buyers'),
                          style: NirmaanTypography.bodySmall.copyWith(
                            color: followUpCount > 0 ? NirmaanColors.warningText : (isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
            child: lastOrder == null
                ? Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                        child: const Icon(Icons.receipt_long_outlined, color: NirmaanColors.brandRoyalBlue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No orders yet — tap + Sale to record your first bill',
                          style: NirmaanTypography.bodySmall,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: NirmaanColors.brandNavy,
                        child: Text(
                          lastOrder.customerInitials.isNotEmpty ? lastOrder.customerInitials : 'CU',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lastOrder.customerName,
                              style: NirmaanTypography.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Bill ${lastOrder.orderNumber} • ${lastOrder.itemCount} items • ${lastOrder.paymentMethod}',
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
                          Text(
                            '₹${lastOrder.totalAmount.toStringAsFixed(2)}',
                            style: NirmaanTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatTime(lastOrder.createdAt),
                            style: NirmaanTypography.bodySmall.copyWith(fontSize: 11),
                          ),
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

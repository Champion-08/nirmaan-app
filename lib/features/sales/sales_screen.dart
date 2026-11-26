import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers/app_providers.dart';
import 'presentation/new_order_sheet.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  int _selectedTabIndex = 0; // 0 = All, 1 = Pending, 2 = Completed
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: NirmaanAppBar.sub(
        title: 'Sales & Orders',
        actionLabel: '+ New Sale',
        onAction: () {
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
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load orders')),
        data: (allOrders) {
          final pendingCount = allOrders.where((o) => o.status == 'Pending').length;
          final completedCount = allOrders.where((o) => o.status == 'Completed').length;

          final filteredOrders = allOrders.where((o) {
            final matchesStatus = _selectedTabIndex == 0
                ? true
                : (_selectedTabIndex == 1 ? o.status == 'Pending' : o.status == 'Completed');
            final matchesSearch = o.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                o.orderNumber.toLowerCase().contains(_searchQuery.toLowerCase());
            return matchesStatus && matchesSearch;
          }).toList();

          double todayTotal = 0;
          for (final o in allOrders) {
            todayTotal += o.totalAmount;
          }

          return RefreshIndicator(
            color: NirmaanColors.brandNavy,
            onRefresh: () async {
              HapticFeedback.lightImpact();
              ref.invalidate(ordersProvider);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 100),
              children: [
              // Header description + Date picker pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Transaction Ledger', style: NirmaanTypography.headlineSmall),
                      Text('Daily transaction log & fulfillment', style: NirmaanTypography.bodySmall),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 13, color: NirmaanColors.brandRoyalBlue),
                        const SizedBox(width: 6),
                        Text(
                          'Today, 14 Oct',
                          style: NirmaanTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.md),

              // Search bar with voice mic + filter icon
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (q) => setState(() => _searchQuery = q),
                      decoration: const InputDecoration(
                        hintText: 'Search order # or customer...',
                        prefixIcon: Icon(Icons.search_rounded, size: 20),
                        suffixIcon: Icon(Icons.mic_none_rounded, size: 20),
                        constraints: BoxConstraints(maxHeight: 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                      borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
                      border: Border.all(
                        color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.md),

              // 2 Summary Cards: Today's Total & Fulfillment
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(NirmaanDimens.base),
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
                          Text("Today's Total", style: NirmaanTypography.bodySmall),
                          const SizedBox(height: 4),
                          Text('₹${todayTotal.toStringAsFixed(0)}', style: NirmaanTypography.headlineLarge.copyWith(fontSize: 22)),
                          Text('${allOrders.length} bills settled', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.successText)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(NirmaanDimens.base),
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
                          Text('Fulfillment Rate', style: NirmaanTypography.bodySmall),
                          const SizedBox(height: 4),
                          Text('85.7%', style: NirmaanTypography.headlineLarge.copyWith(fontSize: 22)),
                          Text('$pendingCount orders pending', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.warningText)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Filter Tabs: All (42) / Pending (6) / Completed (36)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text('All (${allOrders.length})'),
                      selected: _selectedTabIndex == 0,
                      selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                      labelStyle: TextStyle(
                        color: _selectedTabIndex == 0 ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: _selectedTabIndex == 0 ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedTabIndex = 0);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('Pending ($pendingCount)'),
                      selected: _selectedTabIndex == 1,
                      selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                      labelStyle: TextStyle(
                        color: _selectedTabIndex == 1 ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: _selectedTabIndex == 1 ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedTabIndex = 1);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('Completed ($completedCount)'),
                      selected: _selectedTabIndex == 2,
                      selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                      labelStyle: TextStyle(
                        color: _selectedTabIndex == 2 ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: _selectedTabIndex == 2 ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedTabIndex = 2);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.md),

              // Order Cards
              ...filteredOrders.map((ord) {
                final isPending = ord.status == 'Pending';
                return Container(
                  margin: const EdgeInsets.only(bottom: NirmaanDimens.sm),
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                    borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                    border: Border.all(
                      color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(NirmaanDimens.base),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: NirmaanColors.brandNavy,
                              child: Text(
                                ord.customerInitials,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          ord.customerName,
                                          style: NirmaanTypography.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        ord.orderNumber,
                                        style: NirmaanTypography.bodySmall.copyWith(
                                          color: NirmaanColors.brandRoyalBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    ord.itemsSummary,
                                    style: NirmaanTypography.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            StatusPill(
                              label: ord.status,
                              variant: isPending ? StatusPillVariant.warning : StatusPillVariant.success,
                            ),
                          ],
                        ),
                      ),
                      // Tinted Payment Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(NirmaanDimens.cardRadius)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${ord.paymentMethod} • ${ord.itemCount} items',
                              style: NirmaanTypography.labelSmall,
                            ),
                            Text(
                              '₹${ord.totalAmount.toStringAsFixed(2)}',
                              style: NirmaanTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: NirmaanDimens.lg),

              // Footer Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_rounded, size: 16, color: NirmaanColors.brandRoyalBlue),
                    const SizedBox(width: 8),
                    Text(
                      'All orders synced with GST ledger & tally',
                      style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.brandRoyalBlue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/providers/app_providers.dart';

class NewOrderSheet extends ConsumerStatefulWidget {
  const NewOrderSheet({super.key});

  @override
  ConsumerState<NewOrderSheet> createState() => _NewOrderSheetState();
}

class _NewOrderSheetState extends ConsumerState<NewOrderSheet> {
  final Map<String, int> _selectedQuantities = {};
  String _customerName = 'Walk-in Counter Guest';
  String _paymentMethod = 'UPI Paid';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsAsync = ref.watch(productsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.base),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NirmaanColors.brandNavy,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.point_of_sale_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Billing / New Sale', style: NirmaanTypography.headlineSmall),
                    Text('Real-time ledger & inventory deduction', style: NirmaanTypography.bodySmall),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 20),

          // Scrollable Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.base),
              children: [
                // Customer selector
                Text('Select Customer', style: NirmaanTypography.labelLarge),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkInputSurface : NirmaanColors.inputSurface,
                    borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
                    border: Border.all(
                      color: isDark ? NirmaanColors.darkInputBorder : NirmaanColors.inputBorder,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Builder(
                      builder: (context) {
                        final customers = ref.watch(customersProvider).valueOrNull ?? [];
                        final options = {
                          'Walk-in Counter Guest',
                          ...customers.map((c) => c.name).where((n) => n.isNotEmpty),
                        }.toList();
                        final selected = options.contains(_customerName) ? _customerName : options.first;
                        return DropdownButton<String>(
                          isExpanded: true,
                          value: selected,
                          dropdownColor: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
                          items: options.map((name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(name, style: NirmaanTypography.bodyMedium),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _customerName = val);
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: NirmaanDimens.lg),

                // Product items list
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Items from Catalogue', style: NirmaanTypography.labelLarge),
                    Text('${_selectedQuantities.length} selected', style: NirmaanTypography.labelSmall),
                  ],
                ),
                const SizedBox(height: 8),

                productsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => const Text('Failed to load items'),
                  data: (products) {
                    return Column(
                      children: products.map((prod) {
                        final qty = _selectedQuantities[prod.id] ?? 0;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: qty > 0
                                  ? NirmaanColors.brandRoyalBlue
                                  : (isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
                              width: qty > 0 ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getCategoryIcon(prod.category),
                                  size: 18,
                                  color: NirmaanColors.brandRoyalBlue,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prod.name,
                                      style: NirmaanTypography.titleMedium.copyWith(fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '₹${prod.sellingPrice.toStringAsFixed(0)} • Stock: ${prod.stockQty}',
                                      style: NirmaanTypography.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              // Counter buttons
                              IconButton(
                                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                                icon: const Icon(Icons.remove_circle_outline, size: 22),
                                onPressed: qty > 0
                                    ? () {
                                        HapticFeedback.lightImpact();
                                        setState(() {
                                          if (qty == 1) {
                                            _selectedQuantities.remove(prod.id);
                                          } else {
                                            _selectedQuantities[prod.id] = qty - 1;
                                          }
                                        });
                                      }
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text('$qty', style: NirmaanTypography.titleMedium),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                                icon: const Icon(Icons.add_circle_outline, size: 22),
                                onPressed: prod.stockQty > qty
                                    ? () {
                                        HapticFeedback.lightImpact();
                                        setState(() {
                                          _selectedQuantities[prod.id] = qty + 1;
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: NirmaanDimens.lg),

                // Payment Method
                Text('Payment Method', style: NirmaanTypography.labelLarge),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      'UPI Paid',
                      'Counter Cash',
                      'GPay / UPI',
                      'Cash on Delivery',
                    ].map((method) {
                      final isSelected = _paymentMethod == method;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(method),
                          selected: isSelected,
                          selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                          labelStyle: TextStyle(
                            color: isSelected ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          onSelected: (_) {
                            HapticFeedback.lightImpact();
                            setState(() => _paymentMethod = method);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: NirmaanDimens.lg),
              ],
            ),
          ),

          // Total & Checkout CTA
          _buildBottomSummary(context, productsAsync),
        ],
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context, AsyncValue<List<ProductModel>> productsAsync) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final products = productsAsync.valueOrNull ?? [];

    double totalAmount = 0;
    double netProfit = 0;
    int itemCount = 0;
    final List<OrderItemModel> itemsList = [];

    _selectedQuantities.forEach((prodId, qty) {
      if (qty > 0) {
        final prod = products.firstWhere((p) => p.id == prodId, orElse: () => products.first);
        final subtotal = prod.sellingPrice * qty;
        final profit = (prod.sellingPrice - prod.purchasePrice) * qty;
        totalAmount += subtotal;
        netProfit += profit;
        itemCount += qty;
        itemsList.add(OrderItemModel(
          id: 'item-${DateTime.now().millisecondsSinceEpoch}-$prodId',
          orderId: '',
          productId: prod.id,
          productName: prod.name,
          qty: qty,
          unitPrice: prod.sellingPrice,
          subtotal: subtotal,
        ));
      }
    });

    final itemsSummary = itemsList.map((i) => '${i.productName.split(' ').take(2).join(' ')} (${i.qty})').join(', ');

    return Container(
      padding: const EdgeInsets.all(NirmaanDimens.base),
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Bill Amount', style: NirmaanTypography.bodySmall),
                    Text('₹${totalAmount.toStringAsFixed(2)}', style: NirmaanTypography.kpiNumber.copyWith(fontSize: 22)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: NirmaanColors.successBg,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'Net Profit: ₹${netProfit.toStringAsFixed(0)}',
                    style: NirmaanTypography.labelSmall.copyWith(
                      color: NirmaanColors.successText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: PrimaryNavyButton(
                label: 'Create Order & Print Bill',
                isLoading: _isLoading,
                onPressed: itemCount > 0
                    ? () async {
                        setState(() => _isLoading = true);
                        try {
                          final storeId = ref.read(currentStoreProvider).valueOrNull?.id ?? '';
                          final orderNumber = '#${1025 + (DateTime.now().millisecondsSinceEpoch % 1000)}';
                          final newOrder = OrderModel(
                            id: '',
                            storeId: storeId,
                            orderNumber: orderNumber,
                            customerName: _customerName,
                            customerInitials: _customerName.split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).take(2).join().toUpperCase(),
                            itemsSummary: itemsSummary.isEmpty ? 'Quick billing order' : itemsSummary,
                            itemCount: itemCount,
                            totalAmount: totalAmount,
                            netProfit: netProfit,
                            paymentMethod: _paymentMethod,
                            status: 'Completed',
                            createdAt: DateTime.now(),
                            items: itemsList,
                          );

                          // Create order in repository
                          await ref.read(ordersProvider.notifier).createOrder(newOrder);

                          // Deduct stock for each selected item
                          for (final entry in _selectedQuantities.entries) {
                            final prod = products.firstWhere((p) => p.id == entry.key);
                            final updatedQty = (prod.stockQty - entry.value).clamp(0, 99999);
                            await ref.read(productsProvider.notifier).updateStock(prod.id, updatedQty);
                          }

                          if (!context.mounted) return;
                          Navigator.pop(context);
                          ErrorHandler.showSuccess(context, 'Order $orderNumber created! Stock updated.');
                        } catch (e) {
                          if (!context.mounted) return;
                          ErrorHandler.showError(context, e);
                          if (e is SessionExpiredException) {
                            Navigator.pop(context);
                            context.go('/login');
                          }
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'dairy':
        return Icons.local_drink_rounded;
      case 'snacks':
        return Icons.cookie_outlined;
      case 'beverages':
        return Icons.wine_bar_rounded;
      case 'staples':
        return Icons.rice_bowl_rounded;
      default:
        return Icons.shopping_basket_outlined;
    }
  }
}

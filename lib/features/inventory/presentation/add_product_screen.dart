import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/app_providers.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _nameController = TextEditingController();
  final _sellingPriceController = TextEditingController(text: '32.00');
  final _purchasePriceController = TextEditingController(text: '24.00');
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();

  String _selectedCategory = 'Dairy';
  int _stockQty = 24;
  int _threshold = 5;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Dairy', 'icon': Icons.local_drink_rounded},
    {'name': 'Snacks', 'icon': Icons.cookie_outlined},
    {'name': 'Beverages', 'icon': Icons.wine_bar_rounded},
    {'name': 'Grocery', 'icon': Icons.shopping_basket_outlined},
    {'name': 'Personal Care', 'icon': Icons.clean_hands_rounded},
    {'name': 'Other', 'icon': Icons.category_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _sellingPriceController.addListener(() => setState(() {}));
    _purchasePriceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sellingPriceController.dispose();
    _purchasePriceController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  double get _sellingPrice => double.tryParse(_sellingPriceController.text) ?? 0.0;
  double get _purchasePrice => double.tryParse(_purchasePriceController.text) ?? 0.0;
  double get _margin {
    if (_sellingPrice <= 0) return 0.0;
    return ((_sellingPrice - _purchasePrice) / _sellingPrice) * 100;
  }

  double get _profitPerUnit => (_sellingPrice - _purchasePrice).clamp(0.0, 99999.0);

  void _openBarcodeScanner() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Stack(
          children: [
            MobileScanner(
              onDetect: (capture) {
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  final code = barcodes.first.rawValue!;
                  setState(() {
                    _barcodeController.text = code;
                    if (_skuController.text.isEmpty) {
                      _skuController.text = 'SKU-${code.substring(0, (code.length > 8 ? 8 : code.length))}';
                    }
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Barcode scanned: $code')),
                  );
                }
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
            Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(color: NirmaanColors.brandAccentGreen, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Align barcode inside box',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty) {
      ErrorHandler.showError(context, Exception(), customMessage: 'Please enter a product name.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final storeId = ref.read(currentStoreProvider).valueOrNull?.id ?? '';
      final newProduct = ProductModel(
        id: '',
        storeId: storeId,
        name: _nameController.text.trim(),
        sku: _skuController.text.trim().isEmpty
            ? 'SKU-${DateTime.now().millisecondsSinceEpoch % 10000}'
            : _skuController.text.trim(),
        barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
        category: _selectedCategory,
        sellingPrice: _sellingPrice,
        purchasePrice: _purchasePrice,
        unit: 'pack',
        stockQty: _stockQty,
        lowStockThreshold: _threshold,
        createdAt: DateTime.now(),
      );

      await ref.read(productsProvider.notifier).addProduct(newProduct);
      if (!mounted) return;
      context.pop();
      ErrorHandler.showSuccess(context, '${newProduct.name} saved to inventory!');
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.showError(context, e);
      if (e is SessionExpiredException) {
        context.go('/login');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: const NirmaanAppBar.sub(title: 'Add Product'),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 80),
          children: [
          // New Inventory Item [Active] header card
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: NirmaanColors.brandNavy,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Inventory Item', style: NirmaanTypography.titleLarge),
                      Text('Added directly to live store catalogue', style: NirmaanTypography.bodySmall),
                    ],
                  ),
                ),
                const StatusPill(label: 'Active', variant: StatusPillVariant.success),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── BASIC INFORMATION ─────────────────────────────────────────
          _SectionTitle(title: 'BASIC INFORMATION', isDark: isDark),
          Container(
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
                Text('Product Name', style: NirmaanTypography.labelLarge),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Amul Gold Full Cream Milk 500ml',
                  ),
                ),

                const SizedBox(height: NirmaanDimens.lg),

                Text('Category', style: NirmaanTypography.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat['name'];
                    return ChoiceChip(
                      avatar: Icon(cat['icon'] as IconData, size: 16),
                      label: Text(cat['name'] as String),
                      selected: isSelected,
                      selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                      labelStyle: TextStyle(
                        color: isSelected ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) => setState(() => _selectedCategory = cat['name'] as String),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── PRICING & MARGIN ──────────────────────────────────────────
          _SectionTitle(title: 'PRICING', isDark: isDark),
          Container(
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selling Price (₹)', style: NirmaanTypography.labelLarge),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _sellingPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(prefixText: '₹ '),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Purchase Price (₹)', style: NirmaanTypography.labelLarge),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _purchasePriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(prefixText: '₹ '),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Live Auto-calculated Profit Margin Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: NirmaanColors.successBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_up_rounded, size: 16, color: NirmaanColors.successText),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Profit Margin: ~${_margin.toStringAsFixed(1)}% (₹${_profitPerUnit.toStringAsFixed(2)} / unit)',
                          style: NirmaanTypography.labelSmall.copyWith(
                            color: NirmaanColors.successText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── STOCK LEVEL & ALERTS ─────────────────────────────────────
          _SectionTitle(title: 'STOCK LEVEL & ALERTS', isDark: isDark),
          Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Initial Stock Count', style: NirmaanTypography.labelLarge),
                        Text('Units currently in warehouse/shelf', style: NirmaanTypography.bodySmall),
                      ],
                    ),
                    // Stepper: - 24 +
                    Row(
                      children: [
                        IconButton.filledTonal(
                          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: _stockQty > 0
                              ? () {
                                  HapticFeedback.lightImpact();
                                  setState(() => _stockQty--);
                                }
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text('$_stockQty', style: NirmaanTypography.headlineMedium),
                        ),
                        IconButton.filledTonal(
                          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() => _stockQty++);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Low Stock Threshold', style: NirmaanTypography.labelLarge),
                        Text('Alert merchant when below', style: NirmaanTypography.bodySmall),
                      ],
                    ),
                    DropdownButton<int>(
                      value: _threshold,
                      dropdownColor: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
                      underline: const SizedBox(),
                      items: [3, 5, 10, 15, 20].map((t) {
                        return DropdownMenuItem(value: t, child: Text('$t packs'));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _threshold = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── BARCODE / SKU ────────────────────────────────────────────
          _SectionTitle(title: 'BARCODE / SKU', isDark: isDark),
          Container(
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _barcodeController,
                        decoration: const InputDecoration(
                          hintText: 'Barcode (EAN-13)',
                          prefixIcon: Icon(Icons.qr_code_rounded, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _openBarcodeScanner,
                      icon: const Icon(Icons.camera_alt_outlined, size: 18),
                      label: const Text('Scan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NirmaanColors.brandRoyalBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(90, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(NirmaanDimens.buttonRadius),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _skuController,
                  decoration: const InputDecoration(
                    hintText: 'Custom Store SKU (e.g. DAIRY-MILK-500)',
                    prefixIcon: Icon(Icons.tag_rounded, size: 20),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(NirmaanDimens.buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(NirmaanDimens.buttonRadius),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryNavyButton(
                  label: 'Save Product',
                  isLoading: _isLoading,
                  onPressed: _handleSave,
                ),
              ),
            ],
          ),

          const SizedBox(height: NirmaanDimens.xxl),
        ],
      ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.isDark});
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: NirmaanTypography.labelSmall.copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
          color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
        ),
      ),
    );
  }
}

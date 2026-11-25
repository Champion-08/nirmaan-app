import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/app_providers.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: const NirmaanAppBar.sub(title: 'Products Catalogue'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-product'),
        backgroundColor: NirmaanColors.brandNavy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load items')),
        data: (allProducts) {
          final lowStockItems = allProducts.where((p) => p.isLowStock || p.isOutOfStock).toList();

          final filtered = allProducts.where((p) {
            final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (p.sku?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
            final matchesCat = _selectedCategory == 'All' || p.category.toLowerCase().contains(_selectedCategory.toLowerCase());
            return matchesSearch && matchesCat;
          }).toList();

          final categories = [
            'All ${allProducts.length}',
            'Dairy ${allProducts.where((p) => p.category == 'Dairy').length}',
            'Beverages ${allProducts.where((p) => p.category == 'Beverages').length}',
            'Snacks ${allProducts.where((p) => p.category == 'Snacks').length}',
            'Staples ${allProducts.where((p) => p.category == 'Staples').length}',
            'Grocery ${allProducts.where((p) => p.category == 'Grocery').length}',
          ];

          return ListView(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            children: [
              // Header with total count + warehouse pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${allProducts.length} Total items in store',
                    style: NirmaanTypography.headlineSmall,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Main Warehouse',
                      style: NirmaanTypography.labelSmall.copyWith(
                        color: NirmaanColors.brandRoyalBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.md),

              // Search Bar + Filter Icon
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (q) => setState(() => _searchQuery = q),
                      decoration: const InputDecoration(
                        hintText: 'Search products or SKU...',
                        prefixIcon: Icon(Icons.search_rounded, size: 20),
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

              // Horizontal Category Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((catString) {
                    final catName = catString.split(' ').first;
                    final isSelected = _selectedCategory == catName;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(catString),
                        selected: isSelected,
                        selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? (isDark ? Colors.white : NirmaanColors.brandNavy)
                              : (isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey),
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        onSelected: (_) => setState(() => _selectedCategory = catName),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: NirmaanDimens.md),

              // Red Warning Banner "Products Low in Stock"
              if (lowStockItems.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: NirmaanDimens.md),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: NirmaanColors.dangerBg,
                    borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 18, color: NirmaanColors.dangerText),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${lowStockItems.length} Products Low in Stock',
                          style: NirmaanTypography.labelMedium.copyWith(
                            color: NirmaanColors.dangerText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _searchQuery = ''),
                        child: Text(
                          'Review >',
                          style: NirmaanTypography.labelSmall.copyWith(
                            color: NirmaanColors.dangerText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Product Cards List
              ...filtered.map((prod) => _ProductCard(
                    product: prod,
                    isDark: isDark,
                  )),

              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product, required this.isDark});
  final ProductModel product;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusPill = product.isOutOfStock
        ? const StatusPill(label: '• Out of Stock', variant: StatusPillVariant.danger)
        : (product.isLowStock
            ? const StatusPill(label: '• Low Stock', variant: StatusPillVariant.warning)
            : const StatusPill(label: '• In Stock', variant: StatusPillVariant.success));

    return Container(
      margin: const EdgeInsets.only(bottom: NirmaanDimens.sm),
      padding: const EdgeInsets.all(NirmaanDimens.base),
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
        borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
        border: Border.all(
          color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
        ),
        boxShadow: isDark ? NirmaanShadows.cardShadowDark : NirmaanShadows.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail / Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForCategory(product.category),
              color: NirmaanColors.brandRoyalBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: NirmaanTypography.titleMedium,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18),
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'restock', child: Text('Quick Restock (+10)')),
                        const PopupMenuItem(value: 'edit', child: Text('Edit Price / Details')),
                      ],
                      onSelected: (action) {
                        if (action == 'restock') {
                          ref.read(productsProvider.notifier).updateStock(product.id, product.stockQty + 10);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Restocked ${product.name} (+10)')),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  '${product.category} • SKU: ${product.sku ?? 'N/A'}',
                  style: NirmaanTypography.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${product.sellingPrice.toStringAsFixed(0)} / ${product.unit}',
                      style: NirmaanTypography.titleMedium.copyWith(
                        color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    statusPill,
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.stockQty <= 0
                      ? '⚠ 0 left in stock'
                      : (product.stockQty <= product.lowStockThreshold
                          ? '⚠ Only ${product.stockQty} left'
                          : '${product.stockQty} ${product.unit}s remaining'),
                  style: NirmaanTypography.labelSmall.copyWith(
                    color: product.stockQty <= product.lowStockThreshold
                        ? NirmaanColors.dangerText
                        : (isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey),
                    fontWeight: product.stockQty <= product.lowStockThreshold ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'dairy':
        return Icons.local_drink_rounded;
      case 'beverages':
        return Icons.wine_bar_rounded;
      case 'snacks':
        return Icons.cookie_outlined;
      case 'staples':
        return Icons.rice_bowl_rounded;
      default:
        return Icons.shopping_basket_outlined;
    }
  }
}

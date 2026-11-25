import '../models/product_model.dart';
import '../mock/mock_data.dart';
import '../supabase_service.dart';

class ProductRepository {
  final List<ProductModel> _localProducts = List.from(MockData.products);

  Future<List<ProductModel>> getProducts() async {
    if (SupabaseService.isDemoMode) {
      return List.unmodifiable(_localProducts);
    }

    try {
      final res = await SupabaseService.client!
          .from('products')
          .select()
          .order('name');
      return (res as List).map((p) => ProductModel.fromJson(p)).toList();
    } catch (_) {
      return List.unmodifiable(_localProducts);
    }
  }

  Future<ProductModel?> getProductByBarcode(String barcode) async {
    if (SupabaseService.isDemoMode) {
      return _localProducts.cast<ProductModel?>().firstWhere(
            (p) => p?.barcode == barcode,
            orElse: () => null,
          );
    }

    try {
      final res = await SupabaseService.client!
          .from('products')
          .select()
          .eq('barcode', barcode)
          .maybeSingle();
      if (res != null) return ProductModel.fromJson(res);
    } catch (_) {}
    return null;
  }

  Future<void> addProduct(ProductModel product) async {
    if (SupabaseService.isDemoMode) {
      _localProducts.insert(0, product);
      return;
    }

    await SupabaseService.client!.from('products').insert(product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    if (SupabaseService.isDemoMode) {
      final index = _localProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) _localProducts[index] = product;
      return;
    }

    await SupabaseService.client!
        .from('products')
        .update(product.toJson())
        .eq('id', product.id);
  }

  Future<void> updateStock(String productId, int newQty) async {
    if (SupabaseService.isDemoMode) {
      final index = _localProducts.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final current = _localProducts[index];
        _localProducts[index] = ProductModel(
          id: current.id,
          storeId: current.storeId,
          name: current.name,
          sku: current.sku,
          barcode: current.barcode,
          category: current.category,
          sellingPrice: current.sellingPrice,
          purchasePrice: current.purchasePrice,
          unit: current.unit,
          stockQty: newQty,
          lowStockThreshold: current.lowStockThreshold,
          imageUrl: current.imageUrl,
          isActive: current.isActive,
          createdAt: current.createdAt,
        );
      }
      return;
    }

    await SupabaseService.client!
        .from('products')
        .update({'stock_qty': newQty})
        .eq('id', productId);
  }
}

import '../models/product_model.dart';
import '../mock/mock_data.dart';
import '../supabase_service.dart';
import 'store_and_auth_repository.dart';

class ProductRepository {
  final List<ProductModel> _localProducts = List.from(MockData.products);
  final StoreRepository _storeRepo = StoreRepository();

  Future<List<ProductModel>> getProducts() async {
    if (SupabaseService.isDemoMode) {
      return List.unmodifiable(_localProducts);
    }

    final client = SupabaseService.requireAuthClient();
    final store = await _storeRepo.getStore();
    if (store == null || store.id.isEmpty) return [];

    final res = await client
        .from('products')
        .select()
        .eq('store_id', store.id)
        .order('name');
    return (res as List).map((p) => ProductModel.fromJson(p)).toList();
  }

  Future<ProductModel?> getProductByBarcode(String barcode) async {
    if (SupabaseService.isDemoMode) {
      return _localProducts.cast<ProductModel?>().firstWhere(
            (p) => p?.barcode == barcode,
            orElse: () => null,
          );
    }

    final client = SupabaseService.requireAuthClient();
    final store = await _storeRepo.getStore();
    if (store == null || store.id.isEmpty) return null;

    final res = await client
        .from('products')
        .select()
        .eq('store_id', store.id)
        .eq('barcode', barcode)
        .maybeSingle();
    if (res != null) return ProductModel.fromJson(res);
    return null;
  }

  Future<void> addProduct(ProductModel product) async {
    if (SupabaseService.isDemoMode) {
      _localProducts.insert(0, product);
      return;
    }

    final client = SupabaseService.requireAuthClient();
    final storeId = await _storeRepo.getRequiredStoreId();

    final payload = product.toJson();
    payload['store_id'] = storeId;
    if (product.id.isEmpty || product.id.startsWith('prod-') || product.id.startsWith('demo-')) {
      payload.remove('id');
    }

    await client.from('products').insert(payload);
  }

  Future<void> updateProduct(ProductModel product) async {
    if (SupabaseService.isDemoMode) {
      final index = _localProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) _localProducts[index] = product;
      return;
    }

    final client = SupabaseService.requireAuthClient();
    final storeId = await _storeRepo.getRequiredStoreId();

    final payload = product.toJson();
    payload['store_id'] = storeId;

    await client
        .from('products')
        .update(payload)
        .eq('id', product.id)
        .eq('store_id', storeId);
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

    final client = SupabaseService.requireAuthClient();
    final storeId = await _storeRepo.getRequiredStoreId();

    await client
        .from('products')
        .update({'stock_qty': newQty})
        .eq('id', productId)
        .eq('store_id', storeId);
  }
}

import '../models/order_model.dart';
import '../mock/mock_data.dart';
import '../supabase_service.dart';
import 'store_and_auth_repository.dart';

class OrderRepository {
  final List<OrderModel> _localOrders = List.from(MockData.orders);
  final StoreRepository _storeRepo = StoreRepository();

  Future<List<OrderModel>> getOrders() async {
    if (SupabaseService.isDemoMode) {
      return List.unmodifiable(_localOrders);
    }

    final client = SupabaseService.requireAuthClient();
    final store = await _storeRepo.getStore();
    if (store == null || store.id.isEmpty) return [];

    final res = await client
        .from('orders')
        .select('*, order_items(*)')
        .eq('store_id', store.id)
        .order('created_at', ascending: false);
    return (res as List).map((o) => OrderModel.fromJson(o)).toList();
  }

  Future<void> createOrder(OrderModel order) async {
    if (SupabaseService.isDemoMode) {
      _localOrders.insert(0, order);
      return;
    }

    final client = SupabaseService.requireAuthClient();
    final storeId = await _storeRepo.getRequiredStoreId();

    final orderJson = order.toJson();
    orderJson['store_id'] = storeId;
    if (order.id.isEmpty || order.id.startsWith('ord-') || order.id.startsWith('demo-')) {
      orderJson.remove('id');
    }

    final res = await client
        .from('orders')
        .insert(orderJson)
        .select()
        .single();

    final orderId = res['id'] as String;

    if (order.items.isNotEmpty) {
      final itemsJson = order.items.map((item) {
        return {
          'order_id': orderId,
          'product_id': item.productId,
          'product_name': item.productName,
          'qty': item.qty,
          'unit_price': item.unitPrice,
          'subtotal': item.subtotal,
        };
      }).toList();

      await client.from('order_items').insert(itemsJson);
    }
  }
}

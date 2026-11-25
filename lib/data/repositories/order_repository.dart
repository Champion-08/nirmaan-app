import '../models/order_model.dart';
import '../mock/mock_data.dart';
import '../supabase_service.dart';

class OrderRepository {
  final List<OrderModel> _localOrders = List.from(MockData.orders);

  Future<List<OrderModel>> getOrders() async {
    if (SupabaseService.isDemoMode) {
      return List.unmodifiable(_localOrders);
    }

    try {
      final res = await SupabaseService.client!
          .from('orders')
          .select('*, order_items(*)')
          .order('created_at', ascending: false);
      return (res as List).map((o) => OrderModel.fromJson(o)).toList();
    } catch (_) {
      return List.unmodifiable(_localOrders);
    }
  }

  Future<void> createOrder(OrderModel order) async {
    if (SupabaseService.isDemoMode) {
      _localOrders.insert(0, order);
      return;
    }

    final orderJson = order.toJson();
    final res = await SupabaseService.client!
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

      await SupabaseService.client!.from('order_items').insert(itemsJson);
    }
  }
}

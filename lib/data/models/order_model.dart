/// Order and OrderItem Data Models
class OrderModel {
  final String id;
  final String storeId;
  final String orderNumber;
  final String? customerId;
  final String customerName;
  final String customerInitials;
  final String itemsSummary;
  final int itemCount;
  final double totalAmount;
  final double netProfit;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.storeId,
    required this.orderNumber,
    this.customerId,
    required this.customerName,
    required this.customerInitials,
    required this.itemsSummary,
    this.itemCount = 1,
    required this.totalAmount,
    this.netProfit = 0.0,
    this.paymentMethod = 'UPI Paid',
    this.status = 'Completed',
    required this.createdAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String? ?? '',
      orderNumber: json['order_number'] as String,
      customerId: json['customer_id'] as String?,
      customerName: json['customer_name'] as String? ?? 'Guest Customer',
      customerInitials: json['customer_initials'] as String? ?? 'GC',
      itemsSummary: json['items_summary'] as String? ?? '',
      itemCount: json['item_count'] as int? ?? 1,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      netProfit: (json['net_profit'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] as String? ?? 'UPI Paid',
      status: json['status'] as String? ?? 'Completed',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      items: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'order_number': orderNumber,
    'customer_id': customerId,
    'customer_name': customerName,
    'customer_initials': customerInitials,
    'items_summary': itemsSummary,
    'item_count': itemCount,
    'total_amount': totalAmount,
    'net_profit': netProfit,
    'payment_method': paymentMethod,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}

class OrderItemModel {
  final String id;
  final String orderId;
  final String? productId;
  final String productName;
  final int qty;
  final double unitPrice;
  final double subtotal;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    this.productId,
    required this.productName,
    required this.qty,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String? ?? '',
      orderId: json['order_id'] as String? ?? '',
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String? ?? '',
      qty: json['qty'] as int? ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_id': orderId,
    'product_id': productId,
    'product_name': productName,
    'qty': qty,
    'unit_price': unitPrice,
    'subtotal': subtotal,
  };
}

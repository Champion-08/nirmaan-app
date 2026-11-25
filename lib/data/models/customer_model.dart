/// Customer Data Model
class CustomerModel {
  final String id;
  final String storeId;
  final String name;
  final String initials;
  final String phone;
  final String segment;
  final double totalSpent;
  final int orderCount;
  final int avgCycleDays;
  final DateTime? lastPurchaseAt;
  final String preferredPayment;
  final int loyaltyPoints;
  final DateTime createdAt;

  const CustomerModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.initials,
    required this.phone,
    this.segment = 'Regular',
    this.totalSpent = 0.0,
    this.orderCount = 0,
    this.avgCycleDays = 7,
    this.lastPurchaseAt,
    this.preferredPayment = 'UPI / Instant',
    this.loyaltyPoints = 0,
    required this.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String? ?? '',
      name: json['name'] as String,
      initials: json['initials'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      segment: json['segment'] as String? ?? 'Regular',
      totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0.0,
      orderCount: json['order_count'] as int? ?? 0,
      avgCycleDays: json['avg_cycle_days'] as int? ?? 7,
      lastPurchaseAt: json['last_purchase_at'] != null
          ? DateTime.parse(json['last_purchase_at'] as String)
          : null,
      preferredPayment: json['preferred_payment'] as String? ?? 'UPI / Instant',
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'name': name,
    'initials': initials,
    'phone': phone,
    'segment': segment,
    'total_spent': totalSpent,
    'order_count': orderCount,
    'avg_cycle_days': avgCycleDays,
    'last_purchase_at': lastPurchaseAt?.toIso8601String(),
    'preferred_payment': preferredPayment,
    'loyalty_points': loyaltyPoints,
    'created_at': createdAt.toIso8601String(),
  };
}

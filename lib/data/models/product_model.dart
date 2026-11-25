/// Product Data Model
class ProductModel {
  final String id;
  final String storeId;
  final String name;
  final String? sku;
  final String? barcode;
  final String category;
  final double sellingPrice;
  final double purchasePrice;
  final String unit;
  final int stockQty;
  final int lowStockThreshold;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.sku,
    this.barcode,
    required this.category,
    required this.sellingPrice,
    required this.purchasePrice,
    this.unit = 'unit',
    required this.stockQty,
    this.lowStockThreshold = 5,
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
  });

  bool get isLowStock => stockQty <= lowStockThreshold && stockQty > 0;
  bool get isOutOfStock => stockQty <= 0;
  bool get isInStock => stockQty > lowStockThreshold;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String? ?? '',
      name: json['name'] as String,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      category: json['category'] as String? ?? 'Other',
      sellingPrice: (json['selling_price'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? 'unit',
      stockQty: json['stock_qty'] as int? ?? 0,
      lowStockThreshold: json['low_stock_threshold'] as int? ?? 5,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'name': name,
    'sku': sku,
    'barcode': barcode,
    'category': category,
    'selling_price': sellingPrice,
    'purchase_price': purchasePrice,
    'unit': unit,
    'stock_qty': stockQty,
    'low_stock_threshold': lowStockThreshold,
    'image_url': imageUrl,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
  };
}

/// Store Data Model
class StoreModel {
  final String id;
  final String ownerId;
  final String businessName;
  final String category;
  final String ownerName;
  final String phone;
  final String? email;
  final bool gstRegistered;
  final String currency;
  final String businessHours;
  final bool kycVerified;
  final DateTime createdAt;

  const StoreModel({
    required this.id,
    required this.ownerId,
    required this.businessName,
    required this.category,
    required this.ownerName,
    required this.phone,
    this.email,
    this.gstRegistered = true,
    this.currency = 'INR',
    this.businessHours = '08:00 AM - 10:00 PM',
    this.kycVerified = true,
    required this.createdAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String? ?? '',
      ownerId: json['owner_id'] as String? ?? '',
      businessName: json['business_name'] as String? ?? '',
      category: json['category'] as String? ?? 'Grocery & Daily Essentials',
      ownerName: json['owner_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      gstRegistered: json['gst_registered'] as bool? ?? true,
      currency: json['currency'] as String? ?? 'INR',
      businessHours: json['business_hours'] as String? ?? '08:00 AM - 10:00 PM',
      kycVerified: json['kyc_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'owner_id': ownerId,
    'business_name': businessName,
    'category': category,
    'owner_name': ownerName,
    'phone': phone,
    'email': email,
    'gst_registered': gstRegistered,
    'currency': currency,
    'business_hours': businessHours,
    'kyc_verified': kycVerified,
    'created_at': createdAt.toIso8601String(),
  };
}

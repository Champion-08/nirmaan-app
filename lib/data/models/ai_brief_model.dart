/// AI Brief & Business Health Data Model
class AiBriefModel {
  final String id;
  final String storeId;
  final DateTime date;
  final int healthScore;
  final int salesScore;
  final int inventoryScore;
  final int customersScore;
  final int profitScore;
  final String morningSummary;
  final String peakHours;

  const AiBriefModel({
    required this.id,
    required this.storeId,
    required this.date,
    this.healthScore = 82,
    this.salesScore = 88,
    this.inventoryScore = 78,
    this.customersScore = 84,
    this.profitScore = 82,
    required this.morningSummary,
    required this.peakHours,
  });

  factory AiBriefModel.fromJson(Map<String, dynamic> json) {
    return AiBriefModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      healthScore: json['health_score'] as int? ?? 82,
      salesScore: json['sales_score'] as int? ?? 88,
      inventoryScore: json['inventory_score'] as int? ?? 78,
      customersScore: json['customers_score'] as int? ?? 84,
      profitScore: json['profit_score'] as int? ?? 82,
      morningSummary: json['morning_summary'] as String? ?? '',
      peakHours: json['peak_hours'] as String? ?? '11:00 AM - 02:00 PM',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'date': date.toIso8601String(),
    'health_score': healthScore,
    'sales_score': salesScore,
    'inventory_score': inventoryScore,
    'customers_score': customersScore,
    'profit_score': profitScore,
    'morning_summary': morningSummary,
    'peak_hours': peakHours,
  };
}

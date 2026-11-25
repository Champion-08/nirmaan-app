/// User Settings Data Model
class UserSettingsModel {
  final String userId;
  final String themeMode;
  final String language;
  final bool businessAlerts;
  final bool dailyBrief;
  final bool lowStockAlerts;
  final bool customerAlerts;
  final bool aiRecommendations;
  final bool marketingUpdates;

  const UserSettingsModel({
    required this.userId,
    this.themeMode = 'system',
    this.language = 'English',
    this.businessAlerts = true,
    this.dailyBrief = true,
    this.lowStockAlerts = true,
    this.customerAlerts = true,
    this.aiRecommendations = true,
    this.marketingUpdates = false,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      userId: json['user_id'] as String,
      themeMode: json['theme_mode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'English',
      businessAlerts: json['business_alerts'] as bool? ?? true,
      dailyBrief: json['daily_brief'] as bool? ?? true,
      lowStockAlerts: json['low_stock_alerts'] as bool? ?? true,
      customerAlerts: json['customer_alerts'] as bool? ?? true,
      aiRecommendations: json['ai_recommendations'] as bool? ?? true,
      marketingUpdates: json['marketing_updates'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'theme_mode': themeMode,
    'language': language,
    'business_alerts': businessAlerts,
    'daily_brief': dailyBrief,
    'low_stock_alerts': lowStockAlerts,
    'customer_alerts': customerAlerts,
    'ai_recommendations': aiRecommendations,
    'marketing_updates': marketingUpdates,
  };
}

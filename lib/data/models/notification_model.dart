/// Notification Data Model
class NotificationModel {
  final String id;
  final String storeId;
  final String type;
  final String title;
  final String body;
  final String? actionLabel;
  final String? actionRoute;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.storeId,
    required this.type,
    required this.title,
    required this.body,
    this.actionLabel,
    this.actionRoute,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String? ?? '',
      type: json['type'] as String? ?? 'AI INSIGHT',
      title: json['title'] as String,
      body: json['body'] as String,
      actionLabel: json['action_label'] as String?,
      actionRoute: json['action_route'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'type': type,
    'title': title,
    'body': body,
    'action_label': actionLabel,
    'action_route': actionRoute,
    'is_read': isRead,
    'created_at': createdAt.toIso8601String(),
  };
}

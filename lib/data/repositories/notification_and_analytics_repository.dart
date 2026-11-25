import '../models/notification_model.dart';
import '../models/ai_brief_model.dart';
import '../mock/mock_data.dart';
import '../supabase_service.dart';

class NotificationRepository {
  final List<NotificationModel> _localNotifications = List.from(MockData.notifications);

  Future<List<NotificationModel>> getNotifications() async {
    if (SupabaseService.isDemoMode) {
      return List.unmodifiable(_localNotifications);
    }

    try {
      final res = await SupabaseService.client!
          .from('notifications')
          .select()
          .order('created_at', ascending: false);
      return (res as List).map((n) => NotificationModel.fromJson(n)).toList();
    } catch (_) {
      return List.unmodifiable(_localNotifications);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (SupabaseService.isDemoMode) {
      final index = _localNotifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final current = _localNotifications[index];
        _localNotifications[index] = NotificationModel(
          id: current.id,
          storeId: current.storeId,
          type: current.type,
          title: current.title,
          body: current.body,
          actionLabel: current.actionLabel,
          actionRoute: current.actionRoute,
          isRead: true,
          createdAt: current.createdAt,
        );
      }
      return;
    }

    await SupabaseService.client!
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }
}

class AnalyticsRepository {
  Future<AiBriefModel> getLatestAiBrief() async {
    if (SupabaseService.isDemoMode) return MockData.aiBrief;

    try {
      final res = await SupabaseService.client!
          .from('ai_briefs_and_health')
          .select()
          .order('date', ascending: false)
          .limit(1)
          .maybeSingle();
      if (res != null) return AiBriefModel.fromJson(res);
    } catch (_) {}
    return MockData.aiBrief;
  }
}

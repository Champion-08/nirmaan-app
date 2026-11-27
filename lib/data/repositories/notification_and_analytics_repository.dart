import '../models/notification_model.dart';
import '../models/ai_brief_model.dart';
import '../mock/mock_data.dart';
import '../supabase_service.dart';
import 'store_and_auth_repository.dart';

class NotificationRepository {
  final List<NotificationModel> _localNotifications = List.from(MockData.notifications);
  final StoreRepository _storeRepo = StoreRepository();

  Future<List<NotificationModel>> getNotifications() async {
    if (SupabaseService.isDemoMode) {
      return List.unmodifiable(_localNotifications);
    }

    final client = SupabaseService.requireAuthClient();
    final store = await _storeRepo.getStore();
    if (store == null || store.id.isEmpty) return [];

    final res = await client
        .from('notifications')
        .select()
        .eq('store_id', store.id)
        .order('created_at', ascending: false);
    return (res as List).map((n) => NotificationModel.fromJson(n)).toList();
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

    final client = SupabaseService.requireAuthClient();
    final storeId = await _storeRepo.getRequiredStoreId();

    await client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId)
        .eq('store_id', storeId);
  }
}

class AnalyticsRepository {
  final StoreRepository _storeRepo = StoreRepository();

  Future<AiBriefModel?> getLatestAiBrief() async {
    if (SupabaseService.isDemoMode) return MockData.aiBrief;

    final client = SupabaseService.requireAuthClient();
    final store = await _storeRepo.getStore();
    if (store == null || store.id.isEmpty) return null;

    final res = await client
        .from('ai_briefs_and_health')
        .select()
        .eq('store_id', store.id)
        .order('date', ascending: false)
        .limit(1)
        .maybeSingle();
    if (res != null) return AiBriefModel.fromJson(res);
    return null;
  }
}

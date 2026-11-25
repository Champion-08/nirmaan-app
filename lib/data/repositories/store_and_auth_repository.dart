import '../models/store_model.dart';
import '../models/user_settings_model.dart';
import '../mock/mock_data.dart';
import '../supabase_service.dart';

class AuthRepository {
  bool get isAuthenticated {
    if (SupabaseService.isDemoMode) return true;
    return SupabaseService.client?.auth.currentUser != null;
  }

  String get currentUserId {
    if (SupabaseService.isDemoMode) return 'demo-user-001';
    return SupabaseService.client?.auth.currentUser?.id ?? 'demo-user-001';
  }

  String get currentUserEmail {
    if (SupabaseService.isDemoMode) return 'rahul@shreekrishnagrocery.in';
    return SupabaseService.client?.auth.currentUser?.email ?? 'rahul@shreekrishnagrocery.in';
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (SupabaseService.isDemoMode) return;
    await SupabaseService.client?.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmail(String email, String password, String fullName) async {
    if (SupabaseService.isDemoMode) return;
    await SupabaseService.client?.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> signOut() async {
    if (SupabaseService.isDemoMode) return;
    await SupabaseService.client?.auth.signOut();
  }

  Future<UserSettingsModel> getUserSettings() async {
    if (SupabaseService.isDemoMode) return MockData.userSettings;

    try {
      final res = await SupabaseService.client!
          .from('user_settings')
          .select()
          .eq('user_id', currentUserId)
          .maybeSingle();
      if (res != null) {
        return UserSettingsModel.fromJson(res);
      }
    } catch (_) {}
    return MockData.userSettings;
  }
}

class StoreRepository {
  Future<StoreModel> getStore() async {
    if (SupabaseService.isDemoMode) return MockData.store;

    try {
      final res = await SupabaseService.client!
          .from('stores')
          .select()
          .limit(1)
          .maybeSingle();
      if (res != null) {
        return StoreModel.fromJson(res);
      }
    } catch (_) {}
    return MockData.store;
  }

  Future<void> updateStore(StoreModel store) async {
    if (SupabaseService.isDemoMode) return;
    await SupabaseService.client!
        .from('stores')
        .update(store.toJson())
        .eq('id', store.id);
  }
}

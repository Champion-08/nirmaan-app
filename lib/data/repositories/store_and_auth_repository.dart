import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/error_handler.dart';
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
    return SupabaseService.client?.auth.currentUser?.id ?? '';
  }

  String get currentUserEmail {
    if (SupabaseService.isDemoMode) return 'rahul@shreekrishnagrocery.in';
    return SupabaseService.client?.auth.currentUser?.email ?? '';
  }

  String get currentUserFullName {
    if (SupabaseService.isDemoMode) return 'Rahul Sharma';
    return (SupabaseService.client?.auth.currentUser?.userMetadata?['full_name'] as String?) ?? '';
  }

  Stream<AuthState>? get authStateChanges {
    if (SupabaseService.isDemoMode) return null;
    return SupabaseService.client?.auth.onAuthStateChange;
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (SupabaseService.isDemoMode) return;
    final client = SupabaseService.client;
    if (client == null) {
      throw const SessionExpiredException('Unable to connect to authentication service.');
    }
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmail(String email, String password, String fullName) async {
    if (SupabaseService.isDemoMode) return;
    final client = SupabaseService.client;
    if (client == null) {
      throw const SessionExpiredException('Unable to connect to authentication service.');
    }
    await client.auth.signUp(
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

    final client = SupabaseService.requireAuthClient();
    final userId = client.auth.currentUser!.id;
    final res = await client
        .from('user_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (res != null) {
      return UserSettingsModel.fromJson(res);
    }
    return UserSettingsModel(
      userId: userId,
    );
  }
}

class StoreRepository {
  Future<StoreModel?> getStore() async {
    if (SupabaseService.isDemoMode) return MockData.store;

    final client = SupabaseService.requireAuthClient();
    final userId = client.auth.currentUser!.id;

    final res = await client
        .from('stores')
        .select()
        .eq('owner_id', userId)
        .limit(1)
        .maybeSingle();

    if (res != null) {
      return StoreModel.fromJson(res);
    }
    return null;
  }

  Future<String> getRequiredStoreId() async {
    if (SupabaseService.isDemoMode) return MockData.store.id;
    final store = await getStore();
    if (store == null || store.id.isEmpty) {
      throw const SessionExpiredException('Please complete your Business Setup first.');
    }
    return store.id;
  }

  Future<StoreModel> upsertStore(StoreModel store) async {
    if (SupabaseService.isDemoMode) return store;

    final client = SupabaseService.requireAuthClient();
    final user = client.auth.currentUser!;

    final existing = await client
        .from('stores')
        .select('id')
        .eq('owner_id', user.id)
        .limit(1)
        .maybeSingle();

    final payload = <String, dynamic>{
      'owner_id': user.id,
      'business_name': store.businessName,
      'category': store.category,
      'owner_name': store.ownerName,
      'phone': store.phone,
      'email': store.email ?? user.email,
      'gst_registered': store.gstRegistered,
      'currency': store.currency,
      'business_hours': store.businessHours,
      'kyc_verified': store.kycVerified,
    };

    if (existing != null && existing['id'] != null) {
      final res = await client
          .from('stores')
          .update(payload)
          .eq('id', existing['id'] as String)
          .select()
          .single();
      return StoreModel.fromJson(res);
    } else {
      final res = await client
          .from('stores')
          .insert(payload)
          .select()
          .single();
      return StoreModel.fromJson(res);
    }
  }

  Future<void> updateStore(StoreModel store) async {
    await upsertStore(store);
  }
}

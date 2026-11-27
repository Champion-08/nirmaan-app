import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/utils/error_handler.dart';

/// Manages Supabase client lifecycle and detects offline/demo fallback mode.
class SupabaseService {
  static bool _isInitialized = false;
  static bool _isDemoMode = true;

  static bool get isInitialized => _isInitialized;
  static bool get isDemoMode => _isDemoMode;

  static SupabaseClient? get client {
    if (_isDemoMode || !_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static User? get currentUser {
    if (_isDemoMode || !_isInitialized) return null;
    return client?.auth.currentUser;
  }

  /// Returns an authenticated [SupabaseClient] or throws [SessionExpiredException].
  static SupabaseClient requireAuthClient() {
    final c = client;
    if (c == null || c.auth.currentUser == null) {
      throw const SessionExpiredException();
    }
    return c;
  }

  /// Initialize Supabase with values from .env.
  /// If values are missing, blank, or placeholder, automatically activates Demo Fallback Mode.
  static Future<void> initialize() async {
    final url = dotenv.env['SUPABASE_URL']?.trim() ?? '';
    final key = dotenv.env['SUPABASE_PUBLISHABLE_KEY']?.trim() ?? '';

    final isPlaceholder = url.isEmpty ||
        key.isEmpty ||
        url.contains('your_supabase_project_url') ||
        url.contains('example.com') ||
        key.contains('your_supabase_publishable') ||
        !url.startsWith('http');

    if (isPlaceholder) {
      _isDemoMode = true;
      _isInitialized = true;
      debugPrint('[Nirmaan] Supabase keys are placeholder/unconfigured. Running in OFFLINE DEMO MODE.');
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        publishableKey: key,
      );
      _isDemoMode = false;
      _isInitialized = true;
      debugPrint('[Nirmaan] Supabase initialized successfully in CLOUD MODE.');
    } catch (e) {
      _isDemoMode = true;
      _isInitialized = true;
      debugPrint('[Nirmaan] Supabase init failed: $e. Falling back to OFFLINE DEMO MODE.');
    }
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thrown when an authenticated Supabase operation is attempted with no active user session.
class SessionExpiredException implements Exception {
  const SessionExpiredException([this.message = 'Session expired. Please sign in again.']);
  final String message;

  @override
  String toString() => message;
}

/// Centralized error-mapping and floating SnackBar helper for Nirmaan.
class ErrorHandler {
  ErrorHandler._();

  /// Converts raw Supabase, Auth, and Network exceptions into polite,
  /// single-line user-facing messages. Never exposes SQL or stack traces.
  static String getUserFriendlyMessage(Object error) {
    if (error is SessionExpiredException) {
      return error.message;
    }

    if (error is PostgrestException) {
      final code = error.code ?? '';
      if (code == '42501') {
        return 'Session expired or permission denied. Please sign in again.';
      }
      if (code == '23505') {
        return 'This record already exists.';
      }
      if (code == '23503') {
        return 'Related record not found. Please refresh and try again.';
      }
      if (code == 'PGRST116') {
        return 'Requested record was not found.';
      }
      return 'Unable to sync with server. Please try again.';
    }

    if (error is AuthException) {
      final msg = error.message.toLowerCase();
      if (msg.contains('invalid login credentials') ||
          msg.contains('invalid_credentials')) {
        return 'Invalid email or password. Please try again.';
      }
      if (msg.contains('email not confirmed')) {
        return 'Please verify your email address before signing in.';
      }
      if (msg.contains('already registered') || msg.contains('user already exists')) {
        return 'An account with this email already exists.';
      }
      if (msg.contains('rate limit') || msg.contains('too many requests')) {
        return 'Too many attempts. Please wait a moment and try again.';
      }
      if (msg.contains('jwt') || msg.contains('expired') || msg.contains('session')) {
        return 'Your session has expired. Please sign in again.';
      }
      return 'Authentication failed. Please check your details and try again.';
    }

    if (error is SocketException || error is TimeoutException) {
      return 'No internet connection. Please try again.';
    }

    final raw = error.toString().toLowerCase();
    if (raw.contains('socketexception') ||
        raw.contains('failed host lookup') ||
        raw.contains('connection refused') ||
        raw.contains('network is unreachable') ||
        raw.contains('clientexception')) {
      return 'No internet connection. Please try again.';
    }

    if (raw.contains('42501') || raw.contains('row-level security')) {
      return 'Session expired or permission denied. Please sign in again.';
    }

    return 'Something went wrong. Please try again.';
  }

  /// Displays a clean floating coral/red error SnackBar safely above bottom nav.
  static void showError(
    BuildContext context,
    Object error, {
    String? customMessage,
  }) {
    if (!context.mounted) return;
    final message = customMessage ?? getUserFriendlyMessage(error);
    _showFloatingSnackBar(
      context,
      message: message,
      backgroundColor: const Color(0xFFFEE2E2),
      textColor: const Color(0xFFB91C1C),
      icon: Icons.error_outline_rounded,
    );
  }

  /// Displays a clean floating green success SnackBar.
  static void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;
    _showFloatingSnackBar(
      context,
      message: message,
      backgroundColor: const Color(0xFFDCFCE7),
      textColor: const Color(0xFF15803D),
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Displays a clean floating soft-blue info SnackBar.
  static void showInfo(BuildContext context, String message) {
    if (!context.mounted) return;
    _showFloatingSnackBar(
      context,
      message: message,
      backgroundColor: const Color(0xFFEEF3FB),
      textColor: const Color(0xFF0D254C),
      icon: Icons.info_outline_rounded,
    );
  }

  static void _showFloatingSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 4,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: textColor.withValues(alpha: 0.2)),
          ),
          content: Row(
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
  }
}

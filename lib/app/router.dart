/// GoRouter configuration for Nirmaan.
library;

import 'package:go_router/go_router.dart';
import '../app/app_shell.dart';
import '../data/supabase_service.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/reset_password_screen.dart';
import '../features/onboarding/presentation/business_setup_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/inventory/presentation/products_screen.dart';
import '../features/inventory/presentation/add_product_screen.dart';
import '../features/ai_intelligence/presentation/ai_coach_screen.dart';
import '../features/ai_intelligence/presentation/daily_brief_screen.dart';
import '../features/ai_intelligence/presentation/analytics_screen.dart';
import '../features/ai_intelligence/presentation/business_health_screen.dart';

const _publicRoutes = {
  '/splash',
  '/login',
  '/signup',
  '/forgot-password',
  '/reset-password',
};

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    if (SupabaseService.isDemoMode) return null;
    final isLoggedIn = SupabaseService.currentUser != null;
    final isPublic = _publicRoutes.contains(state.matchedLocation);
    if (!isLoggedIn && !isPublic) {
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/business-setup',
      builder: (context, state) => const BusinessSetupScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const AppShell(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/ai-coach',
      builder: (context, state) => const AiCoachScreen(),
    ),
    GoRoute(
      path: '/daily-brief',
      builder: (context, state) => const DailyBriefScreen(),
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: '/business-health',
      builder: (context, state) => const BusinessHealthScreen(),
    ),
  ],
);

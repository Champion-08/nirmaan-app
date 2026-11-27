import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/supabase_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(
    text: SupabaseService.isDemoMode ? 'rahul@shreekrishnagrocery.in' : '',
  );
  final _passwordController = TextEditingController(
    text: SupabaseService.isDemoMode ? 'merchant123' : '',
  );
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ErrorHandler.showError(context, Exception(), customMessage: 'Please enter your email and password.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final auth = ref.read(authProvider);
      await auth.signInWithEmail(email, password);
      invalidateUserProviders(ref);
      final store = await ref.read(currentStoreProvider.future);
      if (!mounted) return;
      if (store == null || store.businessName.trim().isEmpty) {
        context.go('/business-setup');
      } else {
        context.go('/');
      }
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.showError(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (!SupabaseService.isDemoMode && !ref.read(authProvider).isAuthenticated) {
      ErrorHandler.showInfo(context, 'Please sign in with your email and password.');
      return;
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: NirmaanDimens.base,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: NirmaanColors.brandNavy,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Login',
              style: NirmaanTypography.headlineSmall.copyWith(
                color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.xl, vertical: NirmaanDimens.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // [N] Icon + Enterprise badge
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: NirmaanColors.brandNavy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'N',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: NirmaanColors.infoBg,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, size: 13, color: NirmaanColors.infoText),
                        const SizedBox(width: 4),
                        Text(
                          'Enterprise',
                          style: NirmaanTypography.labelSmall.copyWith(
                            color: NirmaanColors.infoText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Title & Subtitle
              Text(
                'Welcome back',
                style: NirmaanTypography.headlineLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your business smarter.',
                style: NirmaanTypography.bodyMedium.copyWith(
                  color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                ),
              ),

              const SizedBox(height: NirmaanDimens.xxl),

              // Mobile number or Email input
              Text(
                'Mobile number or Email',
                style: NirmaanTypography.labelLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '+91 98765 43210 or name@store.com',
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                ),
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Password input
              Text(
                'Password',
                style: NirmaanTypography.labelLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/forgot-password');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: NirmaanTypography.labelMedium.copyWith(
                      color: NirmaanColors.brandRoyalBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: NirmaanDimens.md),

              // Primary Navy Login Button
              SizedBox(
                width: double.infinity,
                child: PrimaryNavyButton(
                  label: 'Login',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Divider "or continue with"
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.base),
                    child: Text(
                      'or continue with',
                      style: NirmaanTypography.bodySmall.copyWith(
                        color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Continue with Google Button
              OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _handleGoogleSignIn();
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(NirmaanDimens.buttonHeight),
                  backgroundColor: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
                  side: BorderSide(
                    color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(NirmaanDimens.buttonRadius),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.g_mobiledata_rounded,
                        size: 24,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Continue with Google',
                      style: NirmaanTypography.button.copyWith(
                        color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Security Shield Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                  borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                  border: Border.all(
                    color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 20,
                      color: NirmaanColors.brandRoyalBlue,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Protected with bank-grade 256-bit encryption & UPI compliance.',
                        style: NirmaanTypography.labelSmall.copyWith(
                          color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Footer: Don't have an account? Sign up
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: NirmaanTypography.bodyMedium.copyWith(
                        color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.push('/signup');
                      },
                      child: Text(
                        'Sign up',
                        style: NirmaanTypography.bodyMedium.copyWith(
                          color: NirmaanColors.brandRoyalBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/app_providers.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_nameController.text.trim().isEmpty || _contactController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final auth = ref.read(authProvider);
      await auth.signUpWithEmail(
        _contactController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );
      if (!mounted) return;
      // Route to business setup upon registration
      context.go('/business-setup');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration note: $e')),
      );
      context.go('/business-setup');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
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
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Create Account',
              style: NirmaanTypography.headlineSmall.copyWith(
                color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.xl, vertical: NirmaanDimens.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: NirmaanColors.successBg,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 13, color: NirmaanColors.successText),
                    const SizedBox(width: 4),
                    Text(
                      '14-Day Free Merchant Trial',
                      style: NirmaanTypography.labelSmall.copyWith(
                        color: NirmaanColors.successText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.md),

              Text(
                'Start with Nirmaan',
                style: NirmaanTypography.headlineLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'The all-in-one AI operating system for your store.',
                style: NirmaanTypography.bodyMedium.copyWith(
                  color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Owner Full Name
              Text(
                'Owner Full Name',
                style: NirmaanTypography.labelLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Rahul Sharma',
                  prefixIcon: Icon(Icons.badge_outlined, size: 20),
                ),
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Mobile number or Email
              Text(
                'Mobile number or Email',
                style: NirmaanTypography.labelLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _contactController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '+91 98765 43210 or rahul@store.com',
                  prefixIcon: Icon(Icons.phone_outlined, size: 20),
                ),
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Password
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
                  hintText: 'At least 8 characters',
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

              const SizedBox(height: NirmaanDimens.lg),

              // Confirm Password
              Text(
                'Confirm Password',
                style: NirmaanTypography.labelLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                decoration: const InputDecoration(
                  hintText: 'Re-enter password',
                  prefixIcon: Icon(Icons.lock_reset_rounded, size: 20),
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Create Account CTA
              SizedBox(
                width: double.infinity,
                child: PrimaryNavyButton(
                  label: 'Create Account',
                  isLoading: _isLoading,
                  onPressed: _handleSignup,
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Footer: Already have an account? Log in
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: NirmaanTypography.bodyMedium.copyWith(
                        color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Log in',
                        style: NirmaanTypography.bodyMedium.copyWith(
                          color: NirmaanColors.brandRoyalBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

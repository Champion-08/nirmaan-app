import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _isLoading = false;

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (!_hasMinLength || !_passwordsMatch) return;

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully! Please log in.')),
      );
      context.go('/login');
    });
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
        title: Text(
          'Set New Password',
          style: NirmaanTypography.headlineSmall.copyWith(
            color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.xl, vertical: NirmaanDimens.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a new password',
                style: NirmaanTypography.headlineLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your new password must be different from previous passwords.',
                style: NirmaanTypography.bodyMedium.copyWith(
                  color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Card Container
              Container(
                padding: const EdgeInsets.all(NirmaanDimens.base),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                  borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                  border: Border.all(
                    color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                  ),
                  boxShadow: isDark ? NirmaanShadows.cardShadowDark : NirmaanShadows.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Password',
                      style: NirmaanTypography.labelLarge.copyWith(
                        color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscure1,
                      decoration: InputDecoration(
                        hintText: 'Enter at least 8 characters',
                        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                          onPressed: () => setState(() => _obscure1 = !_obscure1),
                        ),
                      ),
                    ),

                    const SizedBox(height: NirmaanDimens.lg),

                    Text(
                      'Confirm New Password',
                      style: NirmaanTypography.labelLarge.copyWith(
                        color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscure2,
                      decoration: InputDecoration(
                        hintText: 'Re-enter new password',
                        prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                          onPressed: () => setState(() => _obscure2 = !_obscure2),
                        ),
                      ),
                    ),

                    const SizedBox(height: NirmaanDimens.lg),

                    // Live validation checkmarks
                    _ValidationCheck(
                      isValid: _hasMinLength,
                      label: 'Use at least 8 characters',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 6),
                    _ValidationCheck(
                      isValid: _passwordsMatch,
                      label: 'Passwords must match',
                      isDark: isDark,
                    ),

                    const SizedBox(height: NirmaanDimens.xl),

                    SizedBox(
                      width: double.infinity,
                      child: PrimaryNavyButton(
                        label: 'Reset Password',
                        isLoading: _isLoading,
                        onPressed: (_hasMinLength && _passwordsMatch) ? _handleResetPassword : null,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Store-Level Security card
              Container(
                padding: const EdgeInsets.all(NirmaanDimens.base),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                  borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                  border: Border.all(
                    color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined, size: 20, color: NirmaanColors.brandRoyalBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Store-Level Security',
                            style: NirmaanTypography.titleMedium.copyWith(
                              color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Changing password revokes all active sessions on other devices for your security.',
                            style: NirmaanTypography.bodySmall.copyWith(
                              color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValidationCheck extends StatelessWidget {
  const _ValidationCheck({
    required this.isValid,
    required this.label,
    required this.isDark,
  });

  final bool isValid;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isValid
        ? NirmaanColors.successText
        : (isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey);

    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: NirmaanTypography.labelMedium.copyWith(
            color: color,
            fontWeight: isValid ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _contactController = TextEditingController(text: '+91 98765 43210');
  bool _isLoading = false;

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  void _handleSendResetLink() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.push('/reset-password');
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
          'Account Recovery',
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
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: NirmaanColors.infoBg,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_reset_rounded, size: 14, color: NirmaanColors.infoText),
                    const SizedBox(width: 4),
                    Text(
                      'Account Recovery',
                      style: NirmaanTypography.labelSmall.copyWith(
                        color: NirmaanColors.infoText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.md),

              Text(
                'Forgot your password?',
                style: NirmaanTypography.headlineLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your registered mobile or email to receive password reset instructions.',
                style: NirmaanTypography.bodyMedium.copyWith(
                  color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Card Container layout
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
                      'Registered Mobile or Email',
                      style: NirmaanTypography.labelLarge.copyWith(
                        color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _contactController,
                      decoration: const InputDecoration(
                        hintText: '+91 98765 43210 or rahul@store.com',
                        prefixIcon: Icon(Icons.contact_mail_outlined, size: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Helper text
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 14, color: NirmaanColors.successText),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Instant delivery to registered merchant devices.',
                            style: NirmaanTypography.bodySmall.copyWith(
                              color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: NirmaanDimens.lg),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryNavyButton(
                        label: 'Send Reset Link',
                        isLoading: _isLoading,
                        onPressed: _handleSendResetLink,
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: NirmaanColors.brandNavy,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.security_rounded, size: 18, color: Colors.white),
                    ),
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
                            'All reset links expire after 15 minutes. Ensure only authorized store managers reset credentials.',
                            style: NirmaanTypography.bodySmall.copyWith(
                              color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              Center(
                child: TextButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

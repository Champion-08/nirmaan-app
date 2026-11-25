import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../data/providers/app_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _navigationTimer = Timer(const Duration(milliseconds: 2100), () {
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.isAuthenticated) {
        context.go('/');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.xl),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Centered white rounded container with [N] navy/blue icon + green lightning badge
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: NirmaanColors.brandNavy.withValues(alpha: 0.10),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: NirmaanColors.brandNavy,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'N',
                            style: NirmaanTypography.displayMedium.copyWith(
                              color: NirmaanColors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 14,
                        bottom: 14,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: NirmaanColors.brandAccentGreen,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            size: 13,
                            color: NirmaanColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Bold "Nirmaan" title
              Text(
                'Nirmaan',
                style: NirmaanTypography.displayMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                ),
              ),
              const SizedBox(height: 6),
              // "Your AI Business Partner" subtitle
              Text(
                'Your AI Business Partner',
                style: NirmaanTypography.bodyMedium.copyWith(
                  color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Pill loader badge: blue dot + "Syncing store ledger..."
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                  borderRadius: BorderRadius.circular(NirmaanDimens.pillRadius),
                  border: Border.all(
                    color: NirmaanColors.brandRoyalBlue.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 8,
                      height: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: NirmaanColors.brandRoyalBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Syncing store ledger...',
                      style: NirmaanTypography.labelMedium.copyWith(
                        color: NirmaanColors.brandRoyalBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Bottom badge: Indian tricolor-inspired dots (orange, white/blue, green)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark
                      ? NirmaanColors.darkCard.withValues(alpha: 0.6)
                      : NirmaanColors.cardSurface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Orange dot
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF9933),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // White / Ashoka Blue dot
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF000080),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Green dot
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF138808),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Built for India's local merchants",
                          style: NirmaanTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enterprise Grade • ISO 27001 Secure',
                      style: NirmaanTypography.labelSmall.copyWith(
                        fontSize: 10,
                        color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.lg),
            ],
          ),
        ),
      ),
    );
  }
}

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

    _navigationTimer = Timer(const Duration(milliseconds: 2100), () async {
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.isAuthenticated) {
        try {
          final store = await ref.read(storeProvider.future);
          if (!mounted) return;
          if (store == null || store.businessName.trim().isEmpty) {
            context.go('/business-setup');
          } else {
            context.go('/');
          }
        } catch (_) {
          if (!mounted) return;
          context.go('/');
        }
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
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Centered rounded white card (88x88, 22px radius, soft shadow)
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: isDark ? NirmaanColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0B1F3A).withValues(alpha: 0.10),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: NirmaanColors.brandRoyalBlue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                'N',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Bright green circle badge (24x24, #4ADE80) with dark lightning bolt overlapping bottom-right
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ADE80),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? NirmaanColors.darkCard : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            size: 14,
                            color: Color(0xFF0B1F3A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: NirmaanDimens.xl),

                // Centered bold "Nirmaan" title (28px, #0B1F3A)
                Text(
                  'Nirmaan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark ? NirmaanColors.darkHeading : const Color(0xFF0B1F3A),
                  ),
                ),
                const SizedBox(height: 6),
                // "Your AI Business Partner" subtitle (15px, #526075)
                Text(
                  'Your AI Business Partner',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? NirmaanColors.darkBody : const Color(0xFF526075),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: NirmaanDimens.xl),

                // Centered soft blue-tinted pill (#EEF3FB, 20px radius) with blue dot + "Syncing store ledger..."
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkTintedHighlight : const Color(0xFFEEF3FB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
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

                // Bottom pill (#E8EEF9) with orange, white, and green dots + "Built for India's local merchants"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkCard : const Color(0xFFE8EEF9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF9933),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFD1D5DB), width: 0.5),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 7,
                        height: 7,
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
                          color: isDark ? NirmaanColors.darkHeading : const Color(0xFF0B1F3A),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Directly below pill: shield outline icon + "Enterprise Grade • ISO 27001 Secure"
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 14,
                      color: isDark ? NirmaanColors.darkBody : const Color(0xFF526075),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Enterprise Grade • ISO 27001 Secure',
                      style: NirmaanTypography.labelSmall.copyWith(
                        fontSize: 11,
                        color: isDark ? NirmaanColors.darkBody : const Color(0xFF526075),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: NirmaanDimens.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

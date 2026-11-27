import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../data/providers/app_providers.dart';

class DailyBriefScreen extends ConsumerStatefulWidget {
  const DailyBriefScreen({super.key});

  @override
  ConsumerState<DailyBriefScreen> createState() => _DailyBriefScreenState();
}

class _DailyBriefScreenState extends ConsumerState<DailyBriefScreen> {
  bool _isPlayingAudio = false;
  final List<bool> _checklist = [true, true, false];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storeAsync = ref.watch(currentStoreProvider);
    final rawOwner = storeAsync.valueOrNull?.ownerName.trim() ?? '';
    final ownerName = rawOwner.isNotEmpty ? rawOwner.split(' ').first : 'Merchant';

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).maybePop();
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: NirmaanColors.infoBg,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 12, color: NirmaanColors.brandRoyalBlue),
                  const SizedBox(width: 4),
                  Text(
                    'Nirmaan AI Pulse',
                    style: NirmaanTypography.labelSmall.copyWith(
                      color: NirmaanColors.brandRoyalBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 100),
        children: [
          // Header info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Good morning, $ownerName',
                  style: NirmaanTypography.headlineLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Generated at 8:00 AM',
                style: NirmaanTypography.bodySmall.copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Here is your executive store briefing before the counter opens.',
            style: NirmaanTypography.bodyMedium,
          ),

          const SizedBox(height: NirmaanDimens.lg),

          // 60-sec Audio Summary Player Card
          Container(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [NirmaanColors.darkCard, NirmaanColors.darkTintedHighlight]
                    : [NirmaanColors.brandNavy, NirmaanColors.brandRoyalBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
            ),
            child: Row(
              children: [
                IconButton.filled(
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(_isPlayingAudio ? Icons.pause_rounded : Icons.play_arrow_rounded, color: NirmaanColors.brandNavy),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => _isPlayingAudio = !_isPlayingAudio);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isPlayingAudio ? 'Playing 60-second AI morning audio brief...' : 'Audio brief paused'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '60-sec Audio Summary',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isPlayingAudio ? 'Speaking: Sales pacing, stock warning...' : 'Listen to morning priorities while walking store',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('1:04', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── 3 INTELLIGENCE CARDS ─────────────────────────────────────

          // 1. SALES [↑ 12%]
          _BriefCard(
            badge: 'SALES [↑ 12%]',
            badgeColor: NirmaanColors.successBg,
            badgeTextColor: NirmaanColors.successText,
            title: 'Sales are up 12%',
            metric: 'ESTIMATED REVENUE ₹24,850 vs ₹22,180 avg',
            body: 'Strong morning demand in Milk, packaged Atta & cold drinks.',
            sparklineColor: NirmaanColors.brandAccentGreen,
            isDark: isDark,
          ),

          const SizedBox(height: NirmaanDimens.md),

          // 2. INVENTORY [⚠ Attention]
          _BriefCard(
            badge: 'INVENTORY [⚠ Attention]',
            badgeColor: NirmaanColors.warningBg,
            badgeTextColor: NirmaanColors.warningText,
            title: '7 products need attention',
            body: 'Fortune Sunflower Oil 1L is stock-out. Coca-Cola 750ml & Tata Salt running below threshold.',
            chipLabel: 'Coca-Cola 750ml, Tata Salt & 5 more',
            isDark: isDark,
          ),

          const SizedBox(height: NirmaanDimens.md),

          // 3. CUSTOMERS [4 VIPs]
          _BriefCard(
            badge: 'CUSTOMERS [4 VIPs]',
            badgeColor: NirmaanColors.infoBg,
            badgeTextColor: NirmaanColors.infoText,
            title: '4 customers need follow-up',
            body: 'VIP regular accounts have crossed expected restock cycle.',
            chipLabel: 'Rahul Patel (overdue by 20 days), Amit S.',
            isDark: isDark,
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // ── Today's Actions [3 items] ────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's Actions (3 items)", style: NirmaanTypography.titleLarge),
              GestureDetector(
                onTap: () {
                  setState(() => _checklist.fillRange(0, _checklist.length, true));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All actions marked as completed!')),
                  );
                },
                child: Text('Mark all done', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.brandRoyalBlue, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          _ActionRow(
            title: 'Restock 3 products',
            subtitle: 'Fortune Sunflower Oil & Atta 5kg',
            onTap: () => context.push('/products'),
            isDark: isDark,
          ),
          _ActionRow(
            title: 'Contact 4 customers',
            subtitle: 'Send WhatsApp nudge to overdue VIPs',
            onTap: () => context.go('/'),
            isDark: isDark,
          ),
          _ActionRow(
            title: 'Promote beverages this weekend',
            subtitle: 'Deploy 10% coupon broadcast',
            onTap: () => context.push('/ai-coach'),
            isDark: isDark,
          ),

          const SizedBox(height: NirmaanDimens.lg),

          // Store Readiness Checklist
          Container(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
              border: Border.all(
                color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Store Readiness Checklist', style: NirmaanTypography.titleMedium),
                    Text('${_checklist.where((c) => c).length} of ${_checklist.length} completed', style: NirmaanTypography.labelSmall),
                  ],
                ),
                const SizedBox(height: 8),
                _ChecklistTile(
                  label: 'Counter cash drawer float counted',
                  checked: _checklist[0],
                  onChanged: (v) => setState(() => _checklist[0] = v ?? false),
                ),
                _ChecklistTile(
                  label: 'UPI QR soundbox tested & connected',
                  checked: _checklist[1],
                  onChanged: (v) => setState(() => _checklist[1] = v ?? false),
                ),
                _ChecklistTile(
                  label: 'Evening delivery slots scheduled',
                  checked: _checklist[2],
                  onChanged: (v) => setState(() => _checklist[2] = v ?? false),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xxl),
        ],
      ),
      ),
    );
  }
}

class _BriefCard extends StatelessWidget {
  const _BriefCard({
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.title,
    required this.body,
    this.metric,
    this.chipLabel,
    this.sparklineColor,
    required this.isDark,
  });

  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final String title;
  final String body;
  final String? metric;
  final String? chipLabel;
  final Color? sparklineColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(NirmaanDimens.base),
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
        borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
        border: Border.all(
          color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge,
              style: TextStyle(color: badgeTextColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: NirmaanTypography.titleLarge),
          const SizedBox(height: 4),
          Text(body, style: NirmaanTypography.bodySmall),
          if (metric != null) ...[
            const SizedBox(height: 8),
            Text(metric!, style: NirmaanTypography.labelSmall.copyWith(fontWeight: FontWeight.bold, color: NirmaanColors.brandRoyalBlue)),
          ],
          if (chipLabel != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(chipLabel!, style: NirmaanTypography.labelSmall.copyWith(fontSize: 11)),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: NirmaanTypography.titleMedium),
                Text(subtitle, style: NirmaanTypography.bodySmall),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(60, 32),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('View', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: checked,
      onChanged: onChanged,
      title: Text(label, style: NirmaanTypography.bodyMedium),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: NirmaanColors.brandNavy,
    );
  }
}

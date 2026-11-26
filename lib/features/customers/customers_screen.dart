import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers/app_providers.dart';
import 'presentation/add_customer_dialog.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  int _selectedFilter = 0; // 0 = All, 1 = VIP Regulars, 2 = Needs Attention
  String _searchQuery = '';

  Future<void> _makeCall(String phone) async {
    HapticFeedback.lightImpact();
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendWhatsApp(String phone, String name) async {
    HapticFeedback.lightImpact();
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final msg = Uri.encodeComponent('Namaste $name ji, special seasonal offers are waiting for you at Shree Krishna General Store!');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$msg');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final customersAsync = ref.watch(customersProvider);

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: NirmaanAppBar.sub(
        title: 'Customers CRM',
        actionLabel: '+ New',
        onAction: () {
          HapticFeedback.lightImpact();
          showDialog(
            context: context,
            builder: (_) => const AddCustomerDialog(),
          );
        },
      ),
      body: customersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load customers')),
        data: (allCustomers) {
          final vipCount = allCustomers.where((c) => c.segment == 'VIP Regular').length;
          final attentionList = allCustomers.where((c) => c.totalSpent < 4000 || c.segment == 'Inactive').toList();

          final filtered = allCustomers.where((c) {
            final matchesFilter = _selectedFilter == 0
                ? true
                : (_selectedFilter == 1
                    ? c.segment == 'VIP Regular'
                    : (c.totalSpent < 4000 || c.segment == 'Inactive'));
            final matchesSearch = c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                c.phone.contains(_searchQuery);
            return matchesFilter && matchesSearch;
          }).toList();

          return RefreshIndicator(
            color: NirmaanColors.brandNavy,
            onRefresh: () async {
              HapticFeedback.lightImpact();
              ref.invalidate(customersProvider);
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 100),
              children: [
              // Search Bar with mic + filter
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (q) => setState(() => _searchQuery = q),
                      decoration: const InputDecoration(
                        hintText: 'Search customer name or phone...',
                        prefixIcon: Icon(Icons.search_rounded, size: 20),
                        suffixIcon: Icon(Icons.mic_none_rounded, size: 20),
                        constraints: BoxConstraints(maxHeight: 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                      borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
                      border: Border.all(
                        color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.md),

              // 3 Stat Cards: Directory, New (30d), Returning
              Row(
                children: [
                  Expanded(
                    child: _CrmStatCard(
                      label: 'Directory',
                      value: '${allCustomers.length}',
                      subtitle: 'Active ledgers',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _CrmStatCard(
                      label: 'New (30d)',
                      value: '12',
                      subtitle: '+14% growth',
                      valueColor: NirmaanColors.successText,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _CrmStatCard(
                      label: 'Returning',
                      value: '86%',
                      subtitle: 'Loyalty rate',
                      valueColor: NirmaanColors.brandRoyalBlue,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Dark Navy Smart Retargeting [High impact] Card
              Container(
                padding: const EdgeInsets.all(NirmaanDimens.base),
                decoration: BoxDecoration(
                  color: NirmaanColors.brandNavy,
                  borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'SMART RETARGETING [HIGH IMPACT]',
                            style: NirmaanTypography.labelSmall.copyWith(
                              color: NirmaanColors.brandAccentGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.campaign_outlined, color: Colors.white70, size: 20),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '4 regular customers have not visited in >14 days.',
                      style: NirmaanTypography.titleMedium.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estimated recoverable monthly revenue: ~₹12,400',
                      style: NirmaanTypography.bodySmall.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Batch WhatsApp nudges queued with 5% loyalty coupon!'),
                                backgroundColor: NirmaanColors.successText,
                              ),
                            );
                          },
                          icon: const Icon(Icons.send_rounded, size: 14),
                          label: const Text('Send Batch Nudge'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: NirmaanColors.brandNavy,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => setState(() => _selectedFilter = 2),
                          child: Text(
                            'View 4 list >',
                            style: NirmaanTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Filter pills: All (248), VIP Regulars (24), Needs Attention (4)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text('All (${allCustomers.length})'),
                      selected: _selectedFilter == 0,
                      selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                      labelStyle: TextStyle(
                        color: _selectedFilter == 0 ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: _selectedFilter == 0 ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedFilter = 0);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('VIP Regulars ($vipCount)'),
                      selected: _selectedFilter == 1,
                      selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                      labelStyle: TextStyle(
                        color: _selectedFilter == 1 ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: _selectedFilter == 1 ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedFilter = 1);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('Needs Attention (${attentionList.length})'),
                      selected: _selectedFilter == 2,
                      selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                      labelStyle: TextStyle(
                        color: _selectedFilter == 2 ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: _selectedFilter == 2 ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedFilter = 2);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.md),

              // Customer Cards
              ...filtered.map((cust) {
                final isVip = cust.segment == 'VIP Regular';
                final isAttention = cust.totalSpent < 4000;

                return Container(
                  margin: const EdgeInsets.only(bottom: NirmaanDimens.sm),
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                    borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                    border: Border(
                      left: BorderSide(
                        color: isAttention ? NirmaanColors.dangerText : (isVip ? NirmaanColors.brandRoyalBlue : Colors.transparent),
                        width: isAttention || isVip ? 4 : 1,
                      ),
                      top: BorderSide(color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
                      right: BorderSide(color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
                      bottom: BorderSide(color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(NirmaanDimens.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: isVip ? NirmaanColors.brandRoyalBlue : NirmaanColors.brandNavy,
                              child: Text(
                                cust.initials,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          cust.name,
                                          style: NirmaanTypography.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isVip) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: NirmaanColors.infoBg,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text('★ VIP', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.infoText, fontSize: 9, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    '${cust.phone} • ${cust.orderCount} orders',
                                    style: NirmaanTypography.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₹${cust.totalSpent.toStringAsFixed(0)}', style: NirmaanTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                                Text('Total Spent', style: NirmaanTypography.labelSmall.copyWith(fontSize: 10)),
                              ],
                            ),
                          ],
                        ),

                        if (isAttention) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: NirmaanColors.dangerBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('Follow-up due • Inactive > 14 days', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.dangerText, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],

                        const Divider(height: 16),

                        // Action Bar: Call, WhatsApp & Nudge
                        Row(
                          children: [
                            IconButton.outlined(
                              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                              icon: const Icon(Icons.phone_outlined, size: 18),
                              onPressed: () => _makeCall(cust.phone),
                              style: IconButton.styleFrom(visualDensity: VisualDensity.standard),
                            ),
                            const SizedBox(width: 8),
                            IconButton.outlined(
                              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF15803D)),
                              onPressed: () => _sendWhatsApp(cust.phone, cust.name),
                              style: IconButton.styleFrom(visualDensity: VisualDensity.standard),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                _sendWhatsApp(cust.phone, cust.name);
                              },
                              icon: const Icon(Icons.send_rounded, size: 13),
                              label: const Text('Send Nudge'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isAttention ? NirmaanColors.brandRoyalBlue : NirmaanColors.brandNavy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: NirmaanDimens.xxl),
            ],
            ),
          );
        },
      ),
    );
  }
}

class _CrmStatCard extends StatelessWidget {
  const _CrmStatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    this.valueColor,
    required this.isDark,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color? valueColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          Text(label, style: NirmaanTypography.labelSmall.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            value,
            style: NirmaanTypography.headlineLarge.copyWith(
              color: valueColor ?? (isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark),
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: NirmaanTypography.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}

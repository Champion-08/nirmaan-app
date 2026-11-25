import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

class CampaignBuilderSheet extends StatefulWidget {
  const CampaignBuilderSheet({
    super.key,
    this.initialOffer = 'Weekend Beverage Flash Sale • 10% Off on ₹500+',
    this.targetSegment = 'VIP Regulars (24 customers)',
  });

  final String initialOffer;
  final String targetSegment;

  @override
  State<CampaignBuilderSheet> createState() => _CampaignBuilderSheetState();
}

class _CampaignBuilderSheetState extends State<CampaignBuilderSheet> {
  late final TextEditingController _offerTitleController;
  late final TextEditingController _messageController;
  String _discountType = '10% Off on ₹500+';
  bool _includeCoupon = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _offerTitleController = TextEditingController(text: widget.initialOffer);
    _messageController = TextEditingController(
      text: 'Namaste! Exclusive weekend offer at Shree Krishna General Store: Enjoy 10% OFF on all cold beverages & snacks on orders above ₹500! Show this message or use code WEEKEND10 at counter checkout.',
    );
  }

  @override
  void dispose() {
    _offerTitleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleBroadcast() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSending = false);
    Navigator.pop(context);

    // Launch WhatsApp share
    final text = Uri.encodeComponent(_messageController.text);
    final url = Uri.parse('https://wa.me/?text=$text');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WhatsApp Campaign Broadcast sent to 24 VIP customers!'),
          backgroundColor: NirmaanColors.successText,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.base),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF15803D), size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WhatsApp Offer Campaign', style: NirmaanTypography.headlineSmall),
                    Text('Targeted customer promotion builder', style: NirmaanTypography.bodySmall),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.base),
              children: [
                // Target Audience
                Text('Target Audience', style: NirmaanTypography.labelLarge),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkInputSurface : NirmaanColors.inputSurface,
                    borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
                    border: Border.all(
                      color: isDark ? NirmaanColors.darkInputBorder : NirmaanColors.inputBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.people_alt_outlined, size: 18, color: NirmaanColors.brandRoyalBlue),
                      const SizedBox(width: 10),
                      Text(widget.targetSegment, style: NirmaanTypography.bodyMedium),
                      const Spacer(),
                      const StatusPill(label: 'High ROI', variant: StatusPillVariant.success),
                    ],
                  ),
                ),

                const SizedBox(height: NirmaanDimens.lg),

                // Offer Preset Chips
                Text('Select Discount / Offer Template', style: NirmaanTypography.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    '10% Off on ₹500+',
                    'Buy 2 Get 1 Free',
                    'Flat ₹50 Off Weekend',
                    '5% Extra Loyalty Points',
                  ].map((offer) {
                    final isSelected = _discountType == offer;
                    return ChoiceChip(
                      label: Text(offer),
                      selected: isSelected,
                      selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                      labelStyle: TextStyle(
                        color: isSelected ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _discountType = offer;
                          _offerTitleController.text = offer;
                          _messageController.text =
                              'Namaste! Special weekend offer at Shree Krishna General Store: $offer! Visit between 6 PM - 9 PM or reply to order home delivery.';
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: NirmaanDimens.lg),

                // Campaign Message Preview
                Text('WhatsApp Message Text', style: NirmaanTypography.labelLarge),
                const SizedBox(height: 6),
                TextField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Enter WhatsApp promotional message...',
                  ),
                ),

                const SizedBox(height: NirmaanDimens.lg),

                // Estimated Reach & Conversion Banner
                Container(
                  padding: const EdgeInsets.all(NirmaanDimens.base),
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                    borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                    border: Border.all(
                      color: NirmaanColors.brandRoyalBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.insights_rounded, size: 20, color: NirmaanColors.brandRoyalBlue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estimated Performance', style: NirmaanTypography.titleMedium),
                            const SizedBox(height: 2),
                            Text(
                              'Expected 62% open rate • ~14 visits • Estimated +₹4,800 revenue',
                              style: NirmaanTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: NirmaanDimens.lg),

                // Toggle coupon code
                SwitchListTile.adaptive(
                  value: _includeCoupon,
                  onChanged: (v) => setState(() => _includeCoupon = v),
                  title: Text('Attach Digital Coupon Code', style: NirmaanTypography.titleMedium),
                  subtitle: Text('Auto-validated during counter checkout', style: NirmaanTypography.bodySmall),
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: NirmaanDimens.xl),
              ],
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: PrimaryNavyButton(
                  label: 'Broadcast to WhatsApp Customers',
                  isLoading: _isSending,
                  onPressed: _handleBroadcast,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../data/providers/app_providers.dart';
import '../data/gemini_service.dart';
import 'campaign_builder_sheet.dart';

class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});

  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'How can I increase sales this week?',
      isUser: true,
      time: '10:14 AM',
    ),
    _ChatMessage(
      text:
          'Based on your 7-day POS ledger, your **Beverage category** is accelerating (+18% week-over-week). Evening footfall peaks between **6:00 PM - 9:00 PM**.',
      isUser: false,
      time: '10:14 AM',
      hasChart: true,
      chartTitle: 'Beverages 7-Day Trend: ₹48,250',
      chartDelta: '↑ 18%',
      showActionButtons: true,
    ),
  ];

  final List<String> _suggestedQuestions = [
    'How are my sales doing?',
    'What should I restock?',
    'Which products are slow?',
    'Which customers should I contact?',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    HapticFeedback.lightImpact();

    final userMsg = _ChatMessage(
      text: text.trim(),
      isUser: true,
      time: 'Just now',
    );

    setState(() {
      _messages.add(userMsg);
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Call GeminiService with local store intelligence fallback
    final store = ref.read(currentStoreProvider).valueOrNull;
    final storeContext = {
      'store_name': store?.businessName,
      'category': store?.category,
    };

    final aiResponse = await GeminiService.getBusinessAdvice(
      prompt: text.trim(),
      storeContext: storeContext,
    );

    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add(
        _ChatMessage(
          text: aiResponse,
          isUser: false,
          time: 'Just now',
        ),
      );
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Business Coach', style: NirmaanTypography.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text('Ask Nirmaan about your business', style: NirmaanTypography.bodySmall.copyWith(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Powered by Gemini API & Realtime POS Engine')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Store Insights Active [Live POS] status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: NirmaanColors.brandAccentGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Store Insights Active',
                  style: NirmaanTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: NirmaanColors.infoBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Live POS', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.infoText, fontSize: 9)),
                ),
                const Spacer(),
                Text('38 orders today', style: NirmaanTypography.bodySmall.copyWith(fontSize: 11)),
              ],
            ),
          ),
          const Divider(height: 1),

          // Messages stream
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(NirmaanDimens.base),
              children: [
                ..._messages.map((msg) => _buildMessageRow(msg, isDark)),
                if (_isTyping) ...[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: NirmaanColors.brandRoyalBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, size: 16, color: NirmaanColors.brandRoyalBlue),
                      ),
                      const SizedBox(width: 10),
                      Text('Nirmaan is analyzing ledger...', style: NirmaanTypography.bodySmall.copyWith(fontStyle: FontStyle.italic)),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Recommended Stock Highlight product card
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(NirmaanDimens.base),
                  decoration: BoxDecoration(
                    color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
                    borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                    border: Border.all(
                      color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: NirmaanColors.tintedHighlight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.star_rounded, color: NirmaanColors.brandRoyalBlue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recommended Stock Highlight', style: NirmaanTypography.labelSmall.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('Mango Pulps & Packaged Soda', style: NirmaanTypography.titleMedium),
                            Text('+32% demand forecast for this weekend', style: NirmaanTypography.bodySmall.copyWith(color: NirmaanColors.successText)),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => context.push('/products'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(60, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: const Text('View', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Suggested Questions Chips
                Text('Suggested questions:', style: NirmaanTypography.labelSmall.copyWith(fontSize: 11)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _suggestedQuestions.map((q) {
                    return ActionChip(
                      label: Text(q, style: const TextStyle(fontSize: 11)),
                      backgroundColor: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
                      side: BorderSide(color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
                      onPressed: () => _sendMessage(q),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Bottom Input Bar with mic and send arrow
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              child: Row(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: const Icon(Icons.mic_none_rounded, color: NirmaanColors.brandNavy),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _sendMessage('How are my sales doing?');
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ask Nirmaan or tap mic...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxHeight: 44),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: NirmaanColors.brandNavy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 18),
                    ),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageRow(_ChatMessage msg, bool isDark) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: NirmaanColors.brandNavy,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 24),
        padding: const EdgeInsets.all(NirmaanDimens.base),
        decoration: BoxDecoration(
          color: isDark ? NirmaanColors.darkCard : NirmaanColors.cardSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(
            color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
          ),
          boxShadow: isDark ? NirmaanShadows.cardShadowDark : NirmaanShadows.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: NirmaanColors.brandRoyalBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, size: 14, color: NirmaanColors.brandRoyalBlue),
                ),
                const SizedBox(width: 8),
                Text('Nirmaan Advisor', style: NirmaanTypography.titleMedium.copyWith(fontSize: 13)),
                const Spacer(),
                Text(msg.time, style: NirmaanTypography.bodySmall.copyWith(fontSize: 10)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              msg.text,
              style: NirmaanTypography.bodyMedium.copyWith(height: 1.45),
            ),

            if (msg.hasChart) ...[
              const SizedBox(height: 12),
              // Mini Embedded Line Chart
              Container(
                height: 110,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(msg.chartTitle ?? '', style: NirmaanTypography.labelSmall.copyWith(fontWeight: FontWeight.bold)),
                        Text(msg.chartDelta ?? '', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.successText, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 32),
                                FlSpot(1, 38),
                                FlSpot(2, 35),
                                FlSpot(3, 42),
                                FlSpot(4, 40),
                                FlSpot(5, 52),
                                FlSpot(6, 58),
                              ],
                              isCurved: true,
                              color: NirmaanColors.brandAccentGreen,
                              barWidth: 2.5,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: NirmaanColors.brandAccentGreen.withValues(alpha: 0.15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (msg.showActionButtons) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/products'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        minimumSize: const Size(0, 36),
                      ),
                      child: const Text('View Beverage Sales', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (_) => const CampaignBuilderSheet(
                            initialOffer: 'Weekend Beverage Flash Sale • 10% Off on ₹500+',
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NirmaanColors.brandRoyalBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        minimumSize: const Size(0, 36),
                      ),
                      child: const Text('Create Weekend Offer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.hasChart = false,
    this.chartTitle,
    this.chartDelta,
    this.showActionButtons = false,
  });

  final String text;
  final bool isUser;
  final String time;
  final bool hasChart;
  final String? chartTitle;
  final String? chartDelta;
  final bool showActionButtons;
}

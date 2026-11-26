import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedPeriod = 0; // 0 = 7 Days, 1 = 30 Days, 2 = 90 Days

  List<double> get _chartSpots {
    switch (_selectedPeriod) {
      case 0:
        return [22, 24, 21, 26, 25, 28, 25]; // 7 days (Mon-Sun)
      case 1:
        return [18, 22, 24, 20, 26, 28, 30]; // 30 days
      case 2:
        return [16, 20, 22, 25, 28, 32, 35]; // 90 days
      default:
        return [22, 24, 21, 26, 25, 28, 25];
    }
  }

  String get _revenueText => _selectedPeriod == 0 ? '₹1.72L' : (_selectedPeriod == 1 ? '₹7.45L' : '₹22.1L');
  String get _profitText => _selectedPeriod == 0 ? '₹42,500' : (_selectedPeriod == 1 ? '₹1.92L' : '₹5.68L');
  String get _ordersText => _selectedPeriod == 0 ? '286' : (_selectedPeriod == 1 ? '1,142' : '3,420');
  String get _footfallText => _selectedPeriod == 0 ? '124' : (_selectedPeriod == 1 ? '512' : '1,680');

  void _exportReport() {
    HapticFeedback.lightImpact();
    Share.share(
      'Nirmaan Store Executive Summary:\n'
      'Period: ${_selectedPeriod == 0 ? "Last 7 Days" : (_selectedPeriod == 1 ? "Last 30 Days" : "Last 90 Days")}\n'
      'Gross Revenue: $_revenueText\n'
      'Net Profit: $_profitText\n'
      'Total Orders: $_ordersText\n'
      'Report generated securely via Nirmaan OS.',
      subject: 'Nirmaan Business Intelligence Report',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: NirmaanAppBar.sub(
        title: 'Analytics',
        actionLabel: 'Export',
        onAction: _exportReport,
      ),
      body: RefreshIndicator(
        color: NirmaanColors.brandNavy,
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) setState(() {});
        },
        child: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, NirmaanDimens.sm, NirmaanDimens.base, 100),
          children: [
            // Segmented Period Switcher (7 Days / 30 Days / 90 Days)
            SegmentedButton<int>(
              segments: const [
                ButtonSegment<int>(value: 0, label: Text('7 Days')),
                ButtonSegment<int>(value: 1, label: Text('30 Days')),
                ButtonSegment<int>(value: 2, label: Text('90 Days')),
              ],
              selected: {_selectedPeriod},
              onSelectionChanged: (set) {
                HapticFeedback.lightImpact();
                setState(() => _selectedPeriod = set.first);
              },
            ),

            const SizedBox(height: NirmaanDimens.lg),

            // 2x2 KPI Cards
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: NirmaanDimens.md,
              crossAxisSpacing: NirmaanDimens.md,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.18,
            children: [
              KpiMetricCard(
                label: 'Gross Revenue',
                value: _revenueText,
                delta: '+14.2%',
                deltaPositive: true,
                icon: Icons.currency_rupee,
              ),
              KpiMetricCard(
                label: 'Net Profit',
                value: _profitText,
                delta: '24.8% margin',
                deltaPositive: true,
                icon: Icons.pie_chart_outline_rounded,
              ),
              KpiMetricCard(
                label: 'Orders',
                value: _ordersText,
                delta: '+8% vs prev',
                deltaPositive: true,
                icon: Icons.receipt_long_outlined,
              ),
              KpiMetricCard(
                label: 'Footfall',
                value: _footfallText,
                delta: '78% repeat',
                deltaPositive: true,
                icon: Icons.people_outline,
              ),
            ],
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // Sales Trend Area Line Chart
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
                    Text('Sales Trend', style: NirmaanTypography.titleLarge),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: NirmaanColors.infoBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Daily Gross', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.infoText, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: LineChart(
                    LineChartData(
                      minX: -0.2,
                      maxX: 6.2,
                      minY: 14,
                      maxY: 38,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: isDark ? Colors.white10 : Colors.black12,
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (val, meta) {
                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              final index = val.toInt();
                              if (index >= 0 && index < days.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(days[index], style: const TextStyle(fontSize: 10)),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            _chartSpots.length,
                            (i) => FlSpot(i.toDouble(), _chartSpots[i]),
                          ),
                          isCurved: true,
                          color: NirmaanColors.brandRoyalBlue,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            checkToShowDot: (spot, barData) => spot.x == 5, // Highlight Saturday
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: NirmaanColors.brandRoyalBlue.withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: NirmaanColors.brandNavy,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Sat: ₹28k ★ Peak Day', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // Revenue & Orders Category Progress Bars
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
                Text('Revenue by Department', style: NirmaanTypography.titleMedium),
                const SizedBox(height: 14),
                _CategoryProgressRow(
                  label: 'Grocery & Staples',
                  amount: '₹88,400',
                  percent: 0.51,
                  color: NirmaanColors.brandNavy,
                ),
                const SizedBox(height: 12),
                _CategoryProgressRow(
                  label: 'Beverages & Dairy',
                  amount: '₹52,100',
                  percent: 0.30,
                  color: NirmaanColors.brandRoyalBlue,
                ),
                const SizedBox(height: 12),
                _CategoryProgressRow(
                  label: 'Snacks & Personal',
                  amount: '₹31,500',
                  percent: 0.19,
                  color: NirmaanColors.brandAccentGreen,
                ),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.xl),

          // Top Products Ranked List
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
                Text('Top Products by Volume', style: NirmaanTypography.titleMedium),
                const SizedBox(height: 12),
                _TopProductTile(rank: 1, name: 'Amul Taaza Milk 1L', sales: '342 units', revenue: '₹24,624'),
                const Divider(height: 16),
                _TopProductTile(rank: 2, name: 'Coca-Cola 750ml', sales: '218 bottles', revenue: '₹9,810'),
                const Divider(height: 16),
                _TopProductTile(rank: 3, name: 'Parle-G Gold 1kg', sales: '145 packs', revenue: '₹17,400'),
              ],
            ),
          ),

          const SizedBox(height: NirmaanDimens.md),

          // Weekend Surge Detected Insight Box
          Container(
            padding: const EdgeInsets.all(NirmaanDimens.base),
            decoration: BoxDecoration(
              color: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.tintedHighlight,
              borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
              border: Border.all(color: NirmaanColors.brandRoyalBlue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: NirmaanColors.brandRoyalBlue, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Weekend Surge Detected: Friday 7 PM to Sunday 9 PM accounts for 44% of your total weekly revenue.',
                    style: NirmaanTypography.bodySmall,
                  ),
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

class _CategoryProgressRow extends StatelessWidget {
  const _CategoryProgressRow({
    required this.label,
    required this.amount,
    required this.percent,
    required this.color,
  });

  final String label;
  final String amount;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: NirmaanTypography.bodyMedium),
            Text('$amount (${(percent * 100).toInt()}%)', style: NirmaanTypography.labelMedium.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 6,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _TopProductTile extends StatelessWidget {
  const _TopProductTile({
    required this.rank,
    required this.name,
    required this.sales,
    required this.revenue,
  });

  final int rank;
  final String name;
  final String sales;
  final String revenue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: rank == 1 ? const Color(0xFFFFD700) : (rank == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32)),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('$rank', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: NirmaanTypography.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                sales,
                style: NirmaanTypography.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(revenue, style: NirmaanTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

class BusinessTwinSimulatorSheet extends StatefulWidget {
  const BusinessTwinSimulatorSheet({super.key});

  @override
  State<BusinessTwinSimulatorSheet> createState() => _BusinessTwinSimulatorSheetState();
}

class _BusinessTwinSimulatorSheetState extends State<BusinessTwinSimulatorSheet> {
  double _inventoryInvestment = 15000;
  double _averageDiscount = 5;
  double _extendedHours = 1;

  double get _simulatedRevenue {
    final base = 24850.0;
    final inventoryEffect = (_inventoryInvestment / 1000) * 450;
    final discountEffect = (10 - _averageDiscount) * 220;
    final hoursEffect = _extendedHours * 1600;
    return base + inventoryEffect + discountEffect + hoursEffect;
  }

  double get _simulatedProfit {
    final baseProfit = 6420.0;
    final revenueGain = _simulatedRevenue - 24850.0;
    final margin = (0.258 - (_averageDiscount / 100 * 0.4)).clamp(0.15, 0.35);
    return baseProfit + (revenueGain * margin);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
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
                    color: NirmaanColors.brandNavy,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.model_training_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Business Twin Simulator', style: NirmaanTypography.headlineSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('AI What-If simulation engine', style: NirmaanTypography.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 20),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(NirmaanDimens.base, 0, NirmaanDimens.base, 40),
              children: [
                // Projection Output Card
                Container(
                  padding: const EdgeInsets.all(NirmaanDimens.base),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [NirmaanColors.brandNavy, NirmaanColors.brandRoyalBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('AI SIMULATION FORECAST', style: NirmaanTypography.labelSmall.copyWith(color: NirmaanColors.brandAccentGreen, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text('94% Confidence', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Projected Daily Revenue', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${_simulatedRevenue.toStringAsFixed(0)}',
                                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  '+₹${(_simulatedRevenue - 24850).toStringAsFixed(0)} (+${(((_simulatedRevenue - 24850) / 24850) * 100).toStringAsFixed(1)}%)',
                                  style: const TextStyle(color: NirmaanColors.brandAccentGreen, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 50, color: Colors.white24),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Projected Net Profit', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${_simulatedProfit.toStringAsFixed(0)}',
                                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  '+₹${(_simulatedProfit - 6420).toStringAsFixed(0)} gain',
                                  style: const TextStyle(color: NirmaanColors.brandAccentGreen, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: NirmaanDimens.xl),

                Text('Interactive Lever Adjustments', style: NirmaanTypography.titleLarge),
                const SizedBox(height: 6),
                Text('Adjust knobs to simulate business trajectory', style: NirmaanTypography.bodySmall),

                const SizedBox(height: NirmaanDimens.lg),

                // Lever 1: Additional Inventory Restock
                _SliderRow(
                  label: 'Additional Inventory Restock',
                  valueString: '₹${_inventoryInvestment.toInt()}',
                  value: _inventoryInvestment,
                  min: 0,
                  max: 50000,
                  divisions: 10,
                  onChanged: (v) => setState(() => _inventoryInvestment = v),
                ),

                const SizedBox(height: NirmaanDimens.md),

                // Lever 2: Average Discount Offered
                _SliderRow(
                  label: 'Average Discount Campaign',
                  valueString: '${_averageDiscount.toInt()}%',
                  value: _averageDiscount,
                  min: 0,
                  max: 20,
                  divisions: 20,
                  onChanged: (v) => setState(() => _averageDiscount = v),
                ),

                const SizedBox(height: NirmaanDimens.md),

                // Lever 3: Extended Evening Hours
                _SliderRow(
                  label: 'Extended Evening Operation',
                  valueString: '+${_extendedHours.toInt()} hr(s)',
                  value: _extendedHours,
                  min: 0,
                  max: 3,
                  divisions: 3,
                  onChanged: (v) => setState(() => _extendedHours = v),
                ),

                const SizedBox(height: NirmaanDimens.xl),

                // Insight recommendations card
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
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded, color: NirmaanColors.brandRoyalBlue, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sweet spot: Investing ₹15,000 into high-margin beverages + 1 hr extended evening operation yields maximum profit growth.',
                          style: NirmaanTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
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
                  label: 'Apply Simulation Strategy to Store',
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Simulation targets saved to your Daily AI Goals!'),
                        backgroundColor: NirmaanColors.successText,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.valueString,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final String valueString;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(label, style: NirmaanTypography.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text(valueString, style: NirmaanTypography.titleMedium.copyWith(color: NirmaanColors.brandRoyalBlue, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: NirmaanColors.brandNavy,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

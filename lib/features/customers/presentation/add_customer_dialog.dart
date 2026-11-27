import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/customer_model.dart';
import '../../../data/providers/app_providers.dart';

class AddCustomerDialog extends ConsumerStatefulWidget {
  const AddCustomerDialog({super.key});

  @override
  ConsumerState<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends ConsumerState<AddCustomerDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _segment = 'Regular';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ErrorHandler.showError(context, Exception(), customMessage: 'Please enter name and phone number.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final initials = _nameController.text
          .trim()
          .split(' ')
          .map((e) => e.isNotEmpty ? e[0] : '')
          .take(2)
          .join()
          .toUpperCase();

      final storeId = ref.read(currentStoreProvider).valueOrNull?.id ?? '';
      final customer = CustomerModel(
        id: '',
        storeId: storeId,
        name: _nameController.text.trim(),
        initials: initials.isEmpty ? 'CU' : initials,
        phone: '+91 ${_phoneController.text.trim()}',
        segment: _segment,
        totalSpent: 0,
        orderCount: 0,
        avgCycleDays: 7,
        lastPurchaseAt: DateTime.now(),
        preferredPayment: 'UPI / Instant',
        loyaltyPoints: 50,
        createdAt: DateTime.now(),
      );

      await ref.read(customersProvider.notifier).addCustomer(customer);
      if (!mounted) return;
      Navigator.pop(context);
      ErrorHandler.showSuccess(context, 'Customer ${customer.name} added!');
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.showError(context, e);
      if (e is SessionExpiredException) {
        Navigator.pop(context);
        context.go('/login');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NirmaanDimens.cardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(NirmaanDimens.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NirmaanColors.brandNavy,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Add Customer', style: NirmaanTypography.headlineSmall),
              ],
            ),
            const SizedBox(height: NirmaanDimens.lg),

            Text('Full Name', style: NirmaanTypography.labelLarge),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'e.g. Amit Shah',
                prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
              ),
            ),
            const SizedBox(height: NirmaanDimens.md),

            Text('Mobile / WhatsApp', style: NirmaanTypography.labelLarge),
            const SizedBox(height: 6),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '98200 11223',
                prefixIcon: Icon(Icons.phone_outlined, size: 20),
              ),
            ),
            const SizedBox(height: NirmaanDimens.md),

            Text('Segment', style: NirmaanTypography.labelLarge),
            const SizedBox(height: 6),
            Row(
              children: ['Regular', 'Weekly', 'VIP Regular'].map((s) {
                final isSelected = _segment == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(s),
                    selected: isSelected,
                    selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                    labelStyle: TextStyle(
                      color: isSelected ? NirmaanColors.brandNavy : (isDark ? Colors.white70 : Colors.black54),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    onSelected: (_) => setState(() => _segment = s),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: NirmaanDimens.xl),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryNavyButton(
                    label: 'Save',
                    isLoading: _isLoading,
                    showArrow: false,
                    onPressed: _handleSave,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

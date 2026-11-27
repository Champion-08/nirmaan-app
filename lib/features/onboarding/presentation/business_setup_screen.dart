import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/store_model.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/supabase_service.dart';

class BusinessSetupScreen extends ConsumerStatefulWidget {
  const BusinessSetupScreen({super.key});

  @override
  ConsumerState<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends ConsumerState<BusinessSetupScreen> {
  late final TextEditingController _businessNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _phoneController;
  String _selectedCategory = 'Grocery & Daily Essentials';
  bool _isLoading = false;

  final List<String> _quickCategories = [
    'Grocery',
    'Clothing',
    'Electronics',
    'Pharmacy',
  ];

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authProvider);
    final existingStore = ref.read(currentStoreProvider).valueOrNull;
    _businessNameController = TextEditingController(
      text: existingStore?.businessName.isNotEmpty == true
          ? existingStore!.businessName
          : (SupabaseService.isDemoMode ? 'Shree Krishna General Store' : ''),
    );
    _ownerNameController = TextEditingController(
      text: existingStore?.ownerName.isNotEmpty == true
          ? existingStore!.ownerName
          : (auth.currentUserFullName.isNotEmpty
              ? auth.currentUserFullName
              : (SupabaseService.isDemoMode ? 'Rahul Sharma' : '')),
    );
    _phoneController = TextEditingController(
      text: existingStore?.phone.isNotEmpty == true
          ? existingStore!.phone.replaceFirst('+91 ', '')
          : (SupabaseService.isDemoMode ? '98765 43210' : ''),
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final businessName = _businessNameController.text.trim();
    final ownerName = _ownerNameController.text.trim();
    final phone = _phoneController.text.trim();

    if (businessName.isEmpty || ownerName.isEmpty) {
      ErrorHandler.showError(
        context,
        Exception(),
        customMessage: 'Please enter your business name and owner name.',
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final storeRepo = ref.read(storeRepoProvider);
      final auth = ref.read(authProvider);
      final currentStore = await storeRepo.getStore();
      final updatedStore = StoreModel(
        id: currentStore?.id ?? '',
        ownerId: auth.currentUserId,
        businessName: businessName,
        category: _selectedCategory,
        ownerName: ownerName,
        phone: phone.isEmpty ? '' : (phone.startsWith('+91') ? phone : '+91 $phone'),
        email: currentStore?.email ?? auth.currentUserEmail,
        gstRegistered: true,
        currency: 'INR',
        businessHours: currentStore?.businessHours ?? '08:00 AM - 10:00 PM',
        kycVerified: currentStore?.kycVerified ?? true,
        createdAt: currentStore?.createdAt ?? DateTime.now(),
      );

      await storeRepo.upsertStore(updatedStore);
      if (!mounted) return;
      invalidateUserProviders(ref);
      ErrorHandler.showSuccess(context, 'Store profile saved!');
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.showError(context, e);
      if (e is SessionExpiredException) {
        context.go('/login');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isDark ? NirmaanColors.darkCanvas : NirmaanColors.pageCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: NirmaanDimens.base,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: NirmaanColors.brandNavy,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Business Setup',
              style: NirmaanTypography.headlineSmall.copyWith(
                color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: NirmaanDimens.xl, vertical: NirmaanDimens.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress header: Step 1 pill + 50% Completed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: NirmaanColors.infoBg,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Step 1 of 2',
                      style: NirmaanTypography.labelSmall.copyWith(
                        color: NirmaanColors.infoText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '50% Completed',
                    style: NirmaanTypography.labelSmall.copyWith(
                      color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.5,
                  minHeight: 6,
                  backgroundColor: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
                  valueColor: const AlwaysStoppedAnimation<Color>(NirmaanColors.brandNavy),
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              Text(
                "Let's set up your business",
                style: NirmaanTypography.headlineLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Personalize your AI operating system for your specific retail sector.',
                style: NirmaanTypography.bodyMedium.copyWith(
                  color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Business Name
              Text(
                'Business Name',
                style: NirmaanTypography.labelLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _businessNameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Sharma General Store',
                  prefixIcon: Icon(Icons.storefront_outlined, size: 20),
                ),
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Business Category Dropdown
              Text(
                'Business Category',
                style: NirmaanTypography.labelLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? NirmaanColors.darkInputSurface : NirmaanColors.inputSurface,
                  borderRadius: BorderRadius.circular(NirmaanDimens.inputRadius),
                  border: Border.all(
                    color: isDark ? NirmaanColors.darkInputBorder : NirmaanColors.inputBorder,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    dropdownColor: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
                    items: [
                      'Grocery & Daily Essentials',
                      'Clothing & Apparel',
                      'Electronics & Mobile',
                      'Pharmacy & Healthcare',
                      'Restaurant & Cafe',
                      'Other Retail',
                    ].map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat, style: NirmaanTypography.bodyMedium),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: NirmaanDimens.sm),

              // Quick horizontal selector pills (✓ Grocery, Clothing, Electronics, Pharmacy)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickCategories.map((cat) {
                    final isSelected = _selectedCategory.toLowerCase().contains(cat.toLowerCase());
                    return Padding(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(isSelected ? '✓ $cat' : cat),
                        labelStyle: NirmaanTypography.labelSmall.copyWith(
                          color: isSelected
                              ? (isDark ? Colors.white : NirmaanColors.brandNavy)
                              : (isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey),
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        backgroundColor: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
                        selectedColor: isDark ? NirmaanColors.darkTintedHighlight : NirmaanColors.navActivePill,
                        side: BorderSide(
                          color: isSelected
                              ? NirmaanColors.brandRoyalBlue
                              : (isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder),
                        ),
                        onSelected: (_) {
                          HapticFeedback.lightImpact();
                          if (cat == 'Grocery') {
                            setState(() => _selectedCategory = 'Grocery & Daily Essentials');
                          } else if (cat == 'Clothing') {
                            setState(() => _selectedCategory = 'Clothing & Apparel');
                          } else if (cat == 'Electronics') {
                            setState(() => _selectedCategory = 'Electronics & Mobile');
                          } else if (cat == 'Pharmacy') {
                            setState(() => _selectedCategory = 'Pharmacy & Healthcare');
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Owner Full Name
              Text(
                "Owner's Full Name",
                style: NirmaanTypography.labelLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _ownerNameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Rahul Sharma',
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                ),
              ),

              const SizedBox(height: NirmaanDimens.lg),

              // Mobile / WhatsApp Number
              Text(
                'Mobile / WhatsApp Number',
                style: NirmaanTypography.labelLarge.copyWith(
                  color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '98765 43210',
                  prefixIcon: Container(
                    width: 70,
                    alignment: Alignment.center,
                    child: Text(
                      '+91  |',
                      style: NirmaanTypography.labelMedium.copyWith(
                        color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Green shield caption
              Row(
                children: [
                  const Icon(Icons.verified_user_rounded, size: 14, color: NirmaanColors.successText),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'We will never share your business ledger or customer details.',
                      style: NirmaanTypography.bodySmall.copyWith(
                        color: NirmaanColors.successText,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // 100% Private & Secure Card
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: NirmaanColors.brandNavy,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.lock_outline_rounded, size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '100% Private & Secure',
                            style: NirmaanTypography.titleMedium.copyWith(
                              color: isDark ? NirmaanColors.darkHeading : NirmaanColors.headingDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Local database cache with cloud backup. Only authenticated staff can view ledger metrics.',
                            style: NirmaanTypography.bodySmall.copyWith(
                              color: isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: NirmaanDimens.xl),

              // Continue CTA
              SizedBox(
                width: double.infinity,
                child: PrimaryNavyButton(
                  label: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _handleSave,
                ),
              ),

              const SizedBox(height: NirmaanDimens.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

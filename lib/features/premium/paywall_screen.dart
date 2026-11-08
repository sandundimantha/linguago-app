import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../app/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/primary_button.dart';

final iapProductsProvider = FutureProvider<List<ProductDetails>>((ref) async {
  final iapService = ref.watch(inAppPurchaseServiceProvider);
  return iapService.fetchProducts();
});

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  int _selectedPlanIndex = 1; // Default to Yearly (Best Value)
  bool _isRestoring = false;

  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.smart_toy_rounded,
      'title': 'Unlimited AI Roleplay',
      'subtitle': 'Practice realistic conversations without daily message limits',
    },
    {
      'icon': Icons.auto_fix_high_rounded,
      'title': 'Real-Time Grammar & Accent Feedback',
      'subtitle': 'Pinpoint feedback and customized suggestions for every sentence',
    },
    {
      'icon': Icons.offline_bolt_rounded,
      'title': 'Offline Mode Support',
      'subtitle': 'Download complete units and practice anywhere on the go',
    },
    {
      'icon': Icons.favorite_rounded,
      'title': 'Unlimited Hearts & Energy',
      'subtitle': 'Never stop a lesson because of running out of energy',
    },
  ];

  Future<void> _restorePurchases() async {
    setState(() => _isRestoring = true);
    final iapService = ref.read(inAppPurchaseServiceProvider);
    final success = await iapService.restorePurchases();
    if (mounted) {
      setState(() => _isRestoring = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Purchases restored successfully!'
                : 'No active purchases found or restore failed.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final productsAsync = ref.watch(iapProductsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          // Collapsible Premium Hero Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: colors.primary,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              TextButton(
                onPressed: _isRestoring ? null : _restorePurchases,
                child: _isRestoring
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Restore',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.primary,
                      const Color(0xFF1E3A8A), // Rich deep blue
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 36),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 44,
                          color: Color(0xFFFFD700), // Gold
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'LinguaGo Super',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Unlock your full English fluency potential',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Features and Plan Selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Features List
                  ..._features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(f['icon'] as IconData,
                                  color: colors.primary, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    f['title'] as String,
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colors.text,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    f['subtitle'] as String,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),

                  // Plan Selection Cards
                  Text(
                    'Choose Your Plan',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 12),

                  productsAsync.when(
                    data: (products) {
                      return Column(
                        children: [
                          _buildPlanOption(
                            index: 1,
                            title: '12 Months Access',
                            price: products.length > 1
                                ? products[1].price
                                : '\$59.99/year',
                            periodSubtitle: '\$5.00 / month, billed annually',
                            badge: 'SAVE 50%',
                            isBestValue: true,
                            colors: colors,
                            textTheme: textTheme,
                          ),
                          const SizedBox(height: 12),
                          _buildPlanOption(
                            index: 0,
                            title: '1 Month Access',
                            price: products.isNotEmpty
                                ? products[0].price
                                : '\$9.99/month',
                            periodSubtitle: 'Billed monthly, cancel anytime',
                            badge: null,
                            isBestValue: false,
                            colors: colors,
                            textTheme: textTheme,
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (_, __) => Text(
                      'Failed to load live store products. You can still test checkout.',
                      style: TextStyle(color: colors.mutedText, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Continue to checkout CTA
                  PrimaryButton(
                    label: 'Continue to Checkout',
                    onPressed: () {
                      final products = productsAsync.valueOrNull ?? [];
                      final selectedProduct =
                          (products.length > _selectedPlanIndex)
                              ? products[_selectedPlanIndex]
                              : null;

                      context.push(
                        '/premium/checkout',
                        extra: {
                          'product': selectedProduct,
                          'planIndex': _selectedPlanIndex,
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Legal and policy notice
                  Center(
                    child: Text(
                      'Recurring billing. Cancel anytime in Google Play / App Store.\nBy continuing you agree to LinguaGo Terms of Service.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.mutedText.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOption({
    required int index,
    required String title,
    required String price,
    required String periodSubtitle,
    required String? badge,
    required bool isBestValue,
    required AppCustomColors colors,
    required TextTheme textTheme,
  }) {
    final isSelected = _selectedPlanIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedPlanIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.08)
              : colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2.2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? colors.primary : colors.mutedText,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.text,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    periodSubtitle,
                    style: TextStyle(
                      color: colors.mutedText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


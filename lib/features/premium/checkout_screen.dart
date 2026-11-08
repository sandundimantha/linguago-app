import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../app/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/primary_button.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final ProductDetails? product;
  final int planIndex;

  const CheckoutScreen({
    super.key,
    this.product,
    this.planIndex = 1,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _handlePurchase() async {
    setState(() => _isProcessing = true);
    final iapService = ref.read(inAppPurchaseServiceProvider);

    try {
      if (widget.product != null) {
        await iapService.buyProduct(widget.product!);
      } else {
        // Fallback demo simulation
        await Future.delayed(const Duration(seconds: 1));
        await iapService.restorePurchases();
      }

      if (mounted) {
        setState(() => _isProcessing = false);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    final colors = context.appColors;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded,
                  color: colors.success, size: 54),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to LinguaGo Super!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.text,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All premium features, unlimited AI conversations, and offline units are now unlocked.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.mutedText,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Start Exploring',
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final isYearly = widget.planIndex == 1;
    final planTitle = isYearly ? 'Yearly Super Learner' : 'Monthly Super Learner';
    final planPrice = widget.product?.price ?? (isYearly ? '\$59.99' : '\$9.99');
    final billingDesc = isYearly
        ? 'Total \$59.99 charged annually. Equivalent to \$5.00/mo.'
        : 'Total \$9.99 charged monthly. Cancel anytime.';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Order Summary',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.text),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.workspace_premium_rounded,
                              color: colors.primary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                planTitle,
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isYearly ? 'Annual billing' : 'Monthly billing',
                                style: TextStyle(
                                  color: colors.mutedText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          planPrice,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colors.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(
                      billingDesc,
                      style: TextStyle(
                        color: colors.mutedText,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Security & Guarantee Badges
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    _buildSecurityRow(
                      icon: Icons.lock_outline_rounded,
                      text: 'Secured by Google Play & Apple App Store',
                      colors: colors,
                    ),
                    const SizedBox(height: 12),
                    _buildSecurityRow(
                      icon: Icons.cancel_outlined,
                      text: 'Cancel anytime in store subscription settings',
                      colors: colors,
                    ),
                    const SizedBox(height: 12),
                    _buildSecurityRow(
                      icon: Icons.bolt_rounded,
                      text: 'Instant activation across all your logged-in devices',
                      colors: colors,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Complete Purchase Button
              PrimaryButton(
                label: 'Confirm & Subscribe',
                isLoading: _isProcessing,
                onPressed: _isProcessing ? null : _handlePurchase,
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Payment is handled safely by the app store.',
                  style: TextStyle(
                    color: colors.mutedText,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityRow({
    required IconData icon,
    required String text,
    required AppCustomColors colors,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: colors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

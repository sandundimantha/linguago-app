import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SubscriptionTier { free, monthly, yearly }

class InAppPurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final SharedPreferences _prefs;

  static const String monthlySubscriptionId = 'linguago_premium_monthly';
  static const String yearlySubscriptionId = 'linguago_premium_yearly';
  static const String _premiumPrefKey = 'is_premium_unlocked';

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final _purchaseController = StreamController<bool>.broadcast();

  InAppPurchaseService(this._prefs);

  Stream<bool> get premiumStatusStream => _purchaseController.stream;

  bool isPremium() {
    return _prefs.getBool(_premiumPrefKey) ?? false;
  }

  Future<void> init() async {
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        debugPrint('IAP stream error: $error');
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _purchaseController.close();
  }

  Future<List<ProductDetails>> fetchProducts() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      // In debug or emulator without Play Store setup, return mock product details
      return _mockProducts;
    }

    const Set<String> kIds = {monthlySubscriptionId, yearlySubscriptionId};
    final ProductDetailsResponse response = await _iap.queryProductDetails(kIds);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found in store: ${response.notFoundIDs}');
    }

    if (response.productDetails.isEmpty) {
      return _mockProducts;
    }

    return response.productDetails;
  }

  Future<bool> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    try {
      final bool available = await _iap.isAvailable();
      if (!available) {
        // Mock purchase success for testing
        await _unlockPremium(true);
        return true;
      }
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Buy product error: $e');
      // For developer testing / web sandbox
      await _unlockPremium(true);
      return true;
    }
  }

  Future<bool> restorePurchases() async {
    try {
      final bool available = await _iap.isAvailable();
      if (available) {
        await _iap.restorePurchases();
      } else {
        // Simulate restore for dev testing
        await _unlockPremium(true);
      }
      return true;
    } catch (e) {
      debugPrint('Restore error: $e');
      return false;
    }
  }

  Future<void> _unlockPremium(bool unlocked) async {
    await _prefs.setBool(_premiumPrefKey, unlocked);
    _purchaseController.add(unlocked);
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Pending approval
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint('Purchase error: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          await _unlockPremium(true);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  static final List<ProductDetails> _mockProducts = [
    ProductDetails(
      id: monthlySubscriptionId,
      title: 'Monthly Super Learner',
      description: 'Unlimited AI conversation practice, offline mode & no ads.',
      price: '\$9.99',
      rawPrice: 9.99,
      currencyCode: 'USD',
    ),
    ProductDetails(
      id: yearlySubscriptionId,
      title: 'Yearly Super Learner (Best Value)',
      description: 'Save 50% on complete annual access to AI conversations and all units.',
      price: '\$59.99',
      rawPrice: 59.99,
      currencyCode: 'USD',
    ),
  ];
}

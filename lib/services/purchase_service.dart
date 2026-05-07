import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../core/constants.dart' as constants;

/// RevenueCat purchase service — handles IAP lifecycle.
/// Uses lifetime entitlement "pro" at 14,99 PLN.
class PurchaseService {
  bool _isPro = false;
  bool get isPro => _isPro;

  Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.warn);
    final config = PurchasesConfiguration(
      _apiKey,
    );
    await Purchases.configure(config);
    await _refreshProStatus();
  }

  String get _apiKey {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return constants.revenuecatApiKeyIOS;
    }
    return constants.revenuecatApiKeyAndroid;
  }

  Future<void> _refreshProStatus() async {
    try {
      final info = await Purchases.getCustomerInfo();
      _isPro = info.entitlements.active.containsKey(constants.revenuecatEntitlementId);
    } catch (_) {
      _isPro = false;
    }
  }

  /// Check if user owns the "pro" entitlement.
  Future<bool> checkPro() async {
    await _refreshProStatus();
    return _isPro;
  }

  /// Purchase the lifetime Pro product.
  /// Returns true if purchase succeeded and entitlement is active.
  Future<bool> purchasePro() async {
    try {
      final offerings = await Purchases.getOfferings();
      final pkg = offerings.current?.lifetime;
      if (pkg == null) return false;
      final result = await Purchases.purchasePackage(pkg);
      _isPro = result.entitlements.active.containsKey(constants.revenuecatEntitlementId);
      return _isPro;
    } catch (_) {
      return false;
    }
  }

  /// Restore previous purchases (e.g. after reinstall).
  Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      _isPro = info.entitlements.active.containsKey(constants.revenuecatEntitlementId);
      return _isPro;
    } catch (_) {
      return false;
    }
  }
}

/// Riverpod provider for PurchaseService.
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final service = PurchaseService();
  service.init();
  return service;
});

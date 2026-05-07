import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder purchase service — will be fully implemented in KROK 8.
class PurchaseService {
  final bool _isPro = false;
  bool get isPro => _isPro;
  Future<void> init() async {}
  Future<bool> purchasePro() async => false;
  Future<bool> restore() async => false;
}

final purchaseServiceProvider = Provider<PurchaseService>((ref) => PurchaseService());

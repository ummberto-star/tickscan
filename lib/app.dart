import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/paywall/paywall_screen.dart';
import 'features/scanner/scanner_screen.dart';
import 'services/purchase_service.dart';

class TickScanApp extends StatelessWidget {
  final bool showOnboarding;
  final bool showPaywall;

  const TickScanApp({
    super.key,
    this.showOnboarding = false,
    this.showPaywall = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TickScan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: _HomeGate(
        showOnboarding: showOnboarding,
        showPaywall: showPaywall,
      ),
    );
  }
}

/// Decides which screen to show first: onboarding → paywall → scanner.
class _HomeGate extends ConsumerStatefulWidget {
  final bool showOnboarding;
  final bool showPaywall;

  const _HomeGate({required this.showOnboarding, required this.showPaywall});

  @override
  ConsumerState<_HomeGate> createState() => _HomeGateState();
}

class _HomeGateState extends ConsumerState<_HomeGate> {
  @override
  void initState() {
    super.initState();
    _handlePaywall();
  }

  void _handlePaywall() {
    if (widget.showOnboarding) return;

    if (widget.showPaywall) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPaywallIfNeeded();
      });
    }
  }

  void _showPaywallIfNeeded() {
    final purchaseService = ref.read(purchaseServiceProvider);
    if (purchaseService.isPro) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaywallScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showOnboarding) return const OnboardingScreen();
    return const ScannerScreen();
  }
}

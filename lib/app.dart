import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/scanner/scanner_screen.dart';

class TickScanApp extends StatelessWidget {
  final bool showOnboarding;

  const TickScanApp({super.key, this.showOnboarding = false});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'TickScan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: showOnboarding ? const OnboardingScreen() : const ScannerScreen(),
      ),
    );
  }
}

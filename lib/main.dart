import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request camera permission before app starts
  await Permission.camera.request();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final prefsService = PreferencesService(prefs);

  // Determine if onboarding was already completed
  final onboardingCompleted = prefsService.onboardingCompleted;

  // Increment scan count on every app launch (used for paywall trigger)
  final scanCount = await prefsService.incrementScanCount();
  final shouldShowPaywall = scanCount >= 10; // trigger after 9 uses (10th launch shows paywall)

  runApp(
    ProviderScope(
      overrides: [
        // Override the abstract provider with our initialized instance
        preferencesServiceProvider.overrideWithValue(prefsService),
      ],
      child: TickScanApp(
        showOnboarding: !onboardingCompleted,
        showPaywall: shouldShowPaywall,
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/constants.dart' as constants;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request camera permission before app starts
  await Permission.camera.request();

  // Determine if onboarding was already completed
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool(constants.prefsKeyOnboardingCompleted) ?? false;

  runApp(TickScanApp(showOnboarding: !onboardingCompleted));
}

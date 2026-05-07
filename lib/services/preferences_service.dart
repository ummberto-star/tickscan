import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart' as constants;

/// Wrapper around SharedPreferences for tick-scan specific data.
class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Check if onboarding has been completed.
  bool get onboardingCompleted =>
      _prefs.getBool(constants.prefsKeyOnboardingCompleted) ?? false;

  /// Mark onboarding as completed.
  Future<void> completeOnboarding() async {
    await _prefs.setBool(constants.prefsKeyOnboardingCompleted, true);
  }

  /// Get current scan count.
  int get scanCount => _prefs.getInt(constants.prefsKeyScanCount) ?? 0;

  /// Increment scan count. Returns new value.
  Future<int> incrementScanCount() async {
    final count = scanCount + 1;
    await _prefs.setInt(constants.prefsKeyScanCount, count);
    return count;
  }
}

/// Riverpod provider for PreferencesService.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError(
    'Must be overridden with an initialized instance in main.dart',
  );
});

import 'package:flutter/material.dart';

// ─── App Identity ───────────────────────────────────────────────
const appName = 'TickScan';
const appTagline = 'Znajdź kleszcza zanim on znajdzie Twojego pupila';

// ─── SharedPreferences Keys ────────────────────────────────────
const prefsKeyOnboardingCompleted = 'onboarding_completed';
const prefsKeyScanCount = 'scan_count';

// ─── Affiliate Links (placeholders — replace before release) ───
// TODO: REPLACE with real affiliate links
const affiliateLinkTickTools = 'AFFILIATE_LINK_TICK_TOOLS';
const affiliateLinkProtection = 'AFFILIATE_LINK_PROTECTION';
const affiliateLinkTests = 'AFFILIATE_LINK_TESTS';

// ─── Privacy / Legal URLs (placeholders) ───────────────────────
const privacyPolicyUrl = 'PRIVACY_POLICY_URL';
const termsOfServiceUrl = 'TERMS_OF_SERVICE_URL';

// ─── RevenueCat API Keys ───────────────────────────────────────
const revenuecatApiKeyIOS = 'REVENUECAT_IOS_KEY';
const revenuecatApiKeyAndroid = 'REVENUECAT_ANDROID_KEY';
const revenuecatEntitlementId = 'pro';

// ─── Colors ────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const primary = Color(0xFF2E7D32);          // Deep green
  static const primaryLight = Color(0xFF60AD5E);
  static const primaryDark = Color(0xFF005005);
  static const accent = Color(0xFFFF8F00);           // Amber accent
  static const surface = Color(0xFFF5F5F5);
  static const surfaceDark = Color(0xFF121212);
  static const error = Color(0xFFD32F2F);
}

// ─── Spacing ───────────────────────────────────────────────────
const double spacingXs = 4;
const double spacingSm = 8;
const double spacingMd = 16;
const double spacingLg = 24;
const double spacingXl = 32;

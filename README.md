# 🐕 TickScan — Znajdź kleszcza zanim on znajdzie Twojego pupila

Aplikacja mobilna do wyszukiwania kleszczy na sierści zwierząt poprzez podgląd z kamery z nałożonym filtrem GPU.

## 🚀 Tech stack

- **Flutter** 3.41+ (Impeller renderer)
- **Dart** 3.11+
- **Riverpod** (state management)
- **RevenueCat** (IAP — jednorazowy zakup Pro)
- Zero backendu, zero AI, zero kont — 100% offline

## 📱 Targets

| Platform | Min wersja |
|----------|-----------|
| iOS | 13.0+ |
| Android | 7.0+ (API 24) |

## 🛠 Development

```bash
flutter pub get
flutter run
flutter test
flutter analyze
```

## 📦 Build

```bash
# Android
flutter build appbundle

# iOS
flutter build ios
```

## 🔑 Konfiguracja przed releasem

### 1. RevenueCat
- [ ] Załóż konto na [RevenueCat](https://revenuecat.com)
- [ ] Skonfiguruj produkt `tickscan_pro_lifetime` (14,99 PLN, jednorazowo)
- [ ] Utwórz Entitlement o ID `pro`
- [ ] Podmień klucze w `lib/core/constants.dart`:
  - `revenuecatApiKeyIOS`
  - `revenuecatApiKeyAndroid`

### 2. Linki afiliacyjne
- [ ] Podmień w `lib/core/constants.dart`:
  - `affiliateLinkTickTools`
  - `affiliateLinkProtection`
  - `affiliateLinkTests`

### 3. Assety graficzne
- [ ] Wygeneruj ikonę 1024×1024 px → zapisz jako `assets/icons/app_icon.png`
- [ ] Uruchom `flutter pub run flutter_launcher_icons` aby wygenerować ikony platform
- [ ] Utwórz 2 ilustracje onboardingu → `assets/images/onboarding_1.png`, `onboarding_2.png`
- [ ] Utwórz diagram usuwania kleszcza → `assets/images/tick_removal_diagram.png`

### 4. Prawne
- [ ] Opublikuj politykę prywatności jako statyczną stronę
- [ ] Opublikuj regulamin jako statyczną stronę  
- [ ] Podmień URL-e w `lib/core/constants.dart`:
  - `privacyPolicyUrl`
  - `termsOfServiceUrl`

### 5. Testy IAP
- [ ] Przetestuj zakup w sandbox iOS
- [ ] Przetestuj licencję testową Google Play
- [ ] Zweryfikuj przywracanie zakupów po reinstalacji

## 📋 Features

### Free
- Filtr **Negative** (domyślny — inwersja kolorów)
- Latarka (torch)
- Pinch-to-zoom
- Onboarding + przewodnik usunięcia kleszcza

### Pro (14,99 PLN jednorazowo)
- Suwaki kontrastu i jasności
- Tryby **High Contrast** i **Mono Inverted** (czarna sierść)
- Zapis zdjęć do galerii

## 📁 Struktura

```
lib/
├── main.dart
├── app.dart
├── core/           # Kolory, theme, constants
├── services/       # Camera, Purchases, Preferences
├── features/       # Scanner, Onboarding, Guide, Paywall, Settings
└── widgets/        # ProBadge, ProLockOverlay
```

## ⚠️ Disclaimer

TickScan nie jest urządzeniem medycznym. Aplikacja pomaga w wyszukiwaniu kleszczy, ale nie zastępuje profesjonalnej diagnozy weterynaryjnej.

---

© 2026 TickScan. Wszelkie prawa zastrzeżone.

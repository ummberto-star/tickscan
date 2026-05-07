import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants.dart' as constants;
import '../../services/purchase_service.dart';

/// Static settings screen with version info, legal links, restore purchase.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final purchaseService = ref.read(purchaseServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Pro Section ───────────────────────────────
            Text('TickScan Pro', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      purchaseService.isPro ? Icons.star : Icons.star_border,
                      color: purchaseService.isPro ? Colors.amber : Colors.grey,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        purchaseService.isPro
                            ? 'Masz dostęp do wszystkich funkcji Pro'
                            : 'Odblokuj zaawansowane filtry i zapis zdjęć',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    if (!purchaseService.isPro)
                      FilledButton.tonal(
                        onPressed: () {
                          Navigator.pop(context);
                          // Show paywall — navigated from parent context
                        },
                        child: const Text('Kup Pro'),
                      ),
                  ],
                ),
              ),
            ),
            if (purchaseService.isPro) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final restored = await purchaseService.restore();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            restored
                                ? 'Zakup przywrócony pomyślnie'
                                : 'Nie znaleziono wcześniejszych zakupów',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Przywróć zakup'),
                ),
              ),
            ],
            const SizedBox(height: 32),

            // ─── Legal ──────────────────────────────────────
            Text('Informacje prawne', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Polityka prywatności'),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () => _launchUrl(constants.privacyPolicyUrl),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Regulamin'),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () => _launchUrl(constants.termsOfServiceUrl),
            ),
            const SizedBox(height: 24),

            // ─── Disclaimer ─────────────────────────────────
            Text(
              '⚠️ TickScan nie jest urządzeniem medycznym. Aplikacja pomaga '
              'w wyszukiwaniu kleszczy na sierści zwierzęcia, ale nie zastępuje '
              'profesjonalnej diagnozy weterynaryjnej. W przypadku podejrzenia '
              'choroby odkleszczowej niezwłocznie skonsultuj się z lekarzem weterynarii.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 32),

            // ─── App Info ───────────────────────────────────
            Text('O aplikacji', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _AppVersionInfo(),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Zbudowane z Flutter + Impeller'),
              subtitle: const Text('Wydajne renderowanie GPU'),
              enabled: false,
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '© ${DateTime.now().year} TickScan. Wszelkie prawa zastrzeżone.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// Widget that asynchronously fetches app version/name and displays it.
class _AppVersionInfo extends StatefulWidget {
  @override
  State<_AppVersionInfo> createState() => _AppVersionInfoState();
}

class _AppVersionInfoState extends State<_AppVersionInfo> {
  String _version = 'Ładowanie…';
  String _appName = 'TickScan';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _version = 'v${info.version}+${info.buildNumber}';
        _appName = info.appName;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _version = 'niedostępne');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(_appName),
      subtitle: Text(_version),
      enabled: false,
    );
  }
}

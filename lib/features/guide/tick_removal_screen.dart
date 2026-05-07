import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants.dart' as constants;

class TickRemovalScreen extends StatelessWidget {
  const TickRemovalScreen({super.key});

  Future<void> _launchAffiliate(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Jak bezpiecznie usunąć kleszcza')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.pest_control,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'JAK BEZPIECZNIE USUNĄĆ KLESZCZA',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const _Step(text: 'Nie panikuj. Im szybciej usuniesz kleszcza, tym mniejsze ryzyko zarażenia chorobami (borelioza, babeszjoza, anaplazmoza).'),
            const _Step(text: 'Użyj specjalnego narzędzia: haczyk do kleszczy (np. Tick Twister) lub pęseta z cienkimi końcówkami. NIE używaj palców.'),
            const _Step(text: 'Chwyć kleszcza JAK NAJBLIŻEJ skóry zwierzęcia, na samej głowie pasożyta.'),
            const _Step(text: 'Wyciągaj powolnym, prostym ruchem do góry — bez wykręcania, bez szarpania. Haczyki Tick Twister wymagają delikatnego ruchu obrotowego — sprawdź instrukcję producenta.'),
            const _Step(text: 'Po usunięciu zdezynfekuj miejsce ukąszenia (np. spirytusem salicylowym lub Octeniseptem).'),
            const SizedBox(height: 24),
            Text(
              'CZEGO NIE ROBIĆ:',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            const _Warning(text: 'Nie smaruj kleszcza tłuszczem, masłem, alkoholem ani lakierem do paznokci'),
            const _Warning(text: 'Nie przypalaj zapałką'),
            const _Warning(text: 'Nie wyciskaj'),
            Text(
              'Te metody zwiększają ryzyko, że kleszcz wymiotuje treścią do rany.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'KIEDY DO WETERYNARZA:',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const _Bullet(text: 'Jeśli głowa kleszcza została w skórze'),
            const _Bullet(text: 'Jeśli pojawi się rumień, obrzęk, ropienie'),
            const _Bullet(text: 'Jeśli zwierzę staje się apatyczne, gorączkuje, kuleje, ma zmieniony apetyt'),
            const _Bullet(text: 'Profilaktycznie zawsze warto pokazać znalezionego kleszcza weterynarzowi i rozważyć test PCR'),
            const SizedBox(height: 32),
            Text(
              'Polecane produkty',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _AffiliateCard(
              title: 'Haczyki i pęsety',
              description: 'Narzędzia do bezpiecznego usuwania kleszczy',
              icon: Icons.build,
              url: constants.affiliateLinkTickTools,
              onTap: _launchAffiliate,
            ),
            const SizedBox(height: 12),
            _AffiliateCard(
              title: 'Krople i obroże przeciwkleszczowe',
              description: 'Ochrona przed kleszczami dla Twojego pupila',
              icon: Icons.shield,
              url: constants.affiliateLinkProtection,
              onTap: _launchAffiliate,
            ),
            const SizedBox(height: 12),
            _AffiliateCard(
              title: 'Testy boreliozy dla zwierząt',
              description: 'Szybkie testy diagnostyczne',
              icon: Icons.biotech,
              url: constants.affiliateLinkTests,
              onTap: _launchAffiliate,
            ),
            const SizedBox(height: 32),
            Text(
              '⚠️ Powyższe informacje mają charakter edukacyjny i nie zastępują '
              'profesjonalnej porady weterynaryjnej. W razie wątpliwości zawsze '
              'konsultuj się z lekarzem weterynarii.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String text;
  const _Step({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

class _Warning extends StatelessWidget {
  final String text;
  const _Warning({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.close, size: 16, color: Colors.red),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _AffiliateCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String url;
  final Future<void> Function(String) onTap;

  const _AffiliateCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () => onTap(url),
              child: const Text('Zobacz w sklepie'),
            ),
          ],
        ),
      ),
    );
  }
}

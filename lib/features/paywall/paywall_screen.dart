import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/purchase_service.dart';

/// Fullscreen modal paywall for TickScan Pro.
/// Triggered on 3rd app launch or when tapping a locked feature.
class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseService = ref.watch(purchaseServiceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF60AD5E)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              // Headline
              Text(
                'Odblokuj pełen TickScan',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Features list
              const _FeatureRow(icon: Icons.tune, text: 'Suwaki kontrastu i jasności'),
              const SizedBox(height: 16),
              const _FeatureRow(icon: Icons.filter_alt, text: '3 zaawansowane tryby filtra (Mono Inverted dla czarnej sierści)'),
              const SizedBox(height: 16),
              const _FeatureRow(icon: Icons.camera_alt, text: 'Zapisywanie zdjęć do galerii'),
              const SizedBox(height: 16),
              const _FeatureRow(icon: Icons.all_inclusive, text: 'Brak limitów, jednorazowy zakup, bez subskrypcji'),
              const SizedBox(height: 40),
              // Price
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '14,99 PLN — jednorazowo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // CTA
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () async {
                    final success = await purchaseService.purchasePro();
                    if (success && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Kup Pro',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Restore + Later
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      final restored = await purchaseService.restore();
                      if (restored && context.mounted) {
                        Navigator.pop(context);
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Nie znaleziono wcześniejszych zakupów.')),
                        );
                      }
                    },
                    child: const Text('Przywróć zakup'),
                  ),
                  const SizedBox(width: 8),
                  Text('·', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3))),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Może później',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

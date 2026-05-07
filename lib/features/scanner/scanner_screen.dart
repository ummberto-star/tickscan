import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/purchase_service.dart';
import '../guide/tick_removal_screen.dart';
import '../paywall/paywall_screen.dart';
import 'scanner_state.dart';
import 'widgets/filter_mode_selector.dart';
import 'widgets/torch_button.dart';
import 'widgets/slider_panel.dart';
import 'widgets/capture_button.dart';
import 'widgets/filter_overlay.dart';

/// Main scanner screen — fullscreen camera with GPU color filters for tick detection.
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Init camera after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraServiceProvider).initialize();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraService = ref.read(cameraServiceProvider);
    if (state == AppLifecycleState.inactive) {
      cameraService.controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      cameraService.initialize();
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale != 1.0) {
      final cameraService = ref.read(cameraServiceProvider);
      final newZoom = cameraService.currentZoom * details.scale;
      cameraService.setZoom(newZoom);
    }
  }

  void _handleCapture() {
    final cameraService = ref.read(cameraServiceProvider);
    final isPro = ref.read(purchaseServiceProvider).isPro;
    if (!isPro) return; // blocked for free users
    cameraService.capture();
  }

  @override
  Widget build(BuildContext context) {
    final cameraService = ref.watch(cameraServiceProvider);
    final scannerState = ref.watch(scannerStateProvider);
    final purchaseService = ref.read(purchaseServiceProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: cameraService.isInitialized
          ? GestureDetector(
              onScaleUpdate: _handleScaleUpdate,
              child: Stack(
                children: [
                  // Full-screen filtered camera preview
                  Positioned.fill(
                    child: FilterOverlay(
                      controller: cameraService.controller!,
                      mode: scannerState.mode,
                      contrast: scannerState.contrast,
                      brightness: scannerState.brightness,
                    ),
                  ),

                  // Top gradient + controls
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 8,
                        bottom: 12,
                        left: 16,
                        right: 16,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xAA000000),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          // Hamburger menu
                          GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Filter mode selector
                          FilterModeSelector(
                            currentMode: scannerState.mode,
                            onModeChanged: (mode) =>
                                ref.read(scannerStateProvider.notifier).setMode(mode),
                            isPro: purchaseService.isPro,
                          ),
                          const Spacer(),
                          // Torch button
                          TorchButton(
                            isTorchOn: cameraService.isTorchOn,
                            onToggle: cameraService.toggleTorch,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom panel: sliders + capture
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SliderPanel(
                          contrast: scannerState.contrast,
                          brightness: scannerState.brightness,
                          onContrastChanged: (v) =>
                              ref.read(scannerStateProvider.notifier).setContrast(v),
                          onBrightnessChanged: (v) =>
                              ref.read(scannerStateProvider.notifier).setBrightness(v),
                          isPro: purchaseService.isPro,
                        ),
                        const SizedBox(height: 12),
                        CaptureButton(
                          onCapture: _handleCapture,
                          isPro: purchaseService.isPro,
                        ),
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    'Inicjalizacja kamery…',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF2E7D32)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.search, color: Colors.white, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'TickScan',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.healing),
              title: const Text('Jak usunąć kleszcza'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TickRemovalScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('TickScan Pro'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaywallScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ustawienia'),
              onTap: () {
                Navigator.pop(context);
                // TODO: navigate to settings
              },
            ),
          ],
        ),
      ),
    );
  }
}

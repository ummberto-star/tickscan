import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/camera_service.dart';
import 'filter_matrix.dart';

/// Provider for the CameraService singleton.
/// Disposes the controller when no longer needed.
final cameraServiceProvider = ChangeNotifierProvider<CameraService>((ref) {
  return CameraService();
});

/// Scanner filter state — holds current filter mode, contrast, brightness.
class ScannerState {
  final FilterMode mode;
  final double contrast;
  final double brightness;

  const ScannerState({
    this.mode = FilterMode.negative,
    this.contrast = 1.0,
    this.brightness = 0.0,
  });

  ScannerState copyWith({
    FilterMode? mode,
    double? contrast,
    double? brightness,
  }) {
    return ScannerState(
      mode: mode ?? this.mode,
      contrast: contrast ?? this.contrast,
      brightness: brightness ?? this.brightness,
    );
  }
}

/// Notifier managing the scanner filter state (mode, contrast, brightness).
class ScannerStateNotifier extends StateNotifier<ScannerState> {
  ScannerStateNotifier() : super(const ScannerState());

  void setMode(FilterMode mode) => state = state.copyWith(mode: mode);
  void setContrast(double contrast) => state = state.copyWith(contrast: contrast);
  void setBrightness(double brightness) => state = state.copyWith(brightness: brightness);
}

/// Riverpod provider for ScannerState.
final scannerStateProvider =
    StateNotifierProvider<ScannerStateNotifier, ScannerState>((ref) {
  return ScannerStateNotifier();
});

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Singleton service managing the CameraController lifecycle.
/// Wraps initialization, torch toggle, zoom control, and photo capture.
class CameraService extends ChangeNotifier {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isTorchOn = false;
  double _currentZoom = 1.0;
  double _maxZoom = 1.0;
  double _minZoom = 1.0;

  CameraController? get controller => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;
  bool get isTorchOn => _isTorchOn;
  double get currentZoom => _currentZoom;
  double get maxZoom => _maxZoom;
  double get minZoom => _minZoom;

  /// Initialize the back camera with high resolution (not max — preserves FPS).
  /// Uses YUV420 format for best performance with color filters.
  Future<void> initialize() async {
    _cameras = await availableCameras();
    final back = _cameras!.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras!.first,
    );
    _controller = CameraController(
      back,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await _controller!.initialize();
    _maxZoom = await _controller!.getMaxZoomLevel();
    _minZoom = await _controller!.getMinZoomLevel();
    notifyListeners();
  }

  /// Toggle the flashlight (torch mode) on/off.
  Future<void> toggleTorch() async {
    if (!isInitialized) return;
    _isTorchOn = !_isTorchOn;
    await _controller!.setFlashMode(
      _isTorchOn ? FlashMode.torch : FlashMode.off,
    );
    notifyListeners();
  }

  /// Set the camera zoom level, clamped to valid range.
  Future<void> setZoom(double zoom) async {
    if (!isInitialized) return;
    _currentZoom = zoom.clamp(_minZoom, _maxZoom);
    await _controller!.setZoomLevel(_currentZoom);
    notifyListeners();
  }

  /// Capture a photo. Returns the XFile or null if camera isn't initialized.
  Future<XFile?> capture() async {
    if (!isInitialized) return null;
    return _controller!.takePicture();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

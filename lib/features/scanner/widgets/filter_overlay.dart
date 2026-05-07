import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../filter_matrix.dart';

/// Applies a color filter matrix on top of the camera preview.
/// Wrapped in RepaintBoundary to isolate repaints from other UI layers.
class FilterOverlay extends StatelessWidget {
  final CameraController controller;
  final FilterMode mode;
  final double contrast;
  final double brightness;

  const FilterOverlay({
    super.key,
    required this.controller,
    required this.mode,
    required this.contrast,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(
          FilterMatrix.build(
            mode: mode,
            contrast: contrast,
            brightness: brightness,
          ),
        ),
        child: CameraPreview(controller),
      ),
    );
  }
}

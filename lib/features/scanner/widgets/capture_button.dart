import 'package:flutter/material.dart';

/// Large circular shutter/capture button in the center.
class CaptureButton extends StatelessWidget {
  final VoidCallback onCapture;
  final bool isPro;

  const CaptureButton({
    super.key,
    required this.onCapture,
    required this.isPro,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCapture,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          color: isPro 
              ? Colors.white.withValues(alpha: 0.15) 
              : Colors.white.withValues(alpha: 0.05),
          boxShadow: isPro
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: isPro
            ? const Icon(Icons.camera, color: Colors.white, size: 32)
            : const Icon(Icons.lock, color: Colors.white38, size: 28),
      ),
    );
  }
}

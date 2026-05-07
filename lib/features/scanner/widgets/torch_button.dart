import 'package:flutter/material.dart';

/// Circular torch/flashlight toggle button.
class TorchButton extends StatelessWidget {
  final bool isTorchOn;
  final VoidCallback onToggle;

  const TorchButton({
    super.key,
    required this.isTorchOn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isTorchOn
              ? Colors.amber.withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.25),
        ),
        child: Icon(
          isTorchOn ? Icons.flash_on : Icons.flash_off,
          color: isTorchOn ? Colors.black87 : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

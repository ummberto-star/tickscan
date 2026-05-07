import 'package:flutter/material.dart';
/// Bottom panel with contrast and brightness sliders.
class SliderPanel extends StatelessWidget {
  final double contrast;
  final double brightness;
  final ValueChanged<double> onContrastChanged;
  final ValueChanged<double> onBrightnessChanged;
  final bool isPro;

  const SliderPanel({
    super.key,
    required this.contrast,
    required this.brightness,
    required this.onContrastChanged,
    required this.onBrightnessChanged,
    required this.isPro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Contrast slider
          _SliderRow(
            icon: Icons.contrast,
            label: 'Kontrast',
            value: contrast,
            min: 0.5,
            max: 2.5,
            onChanged: onContrastChanged,
            locked: !isPro,
          ),
          const SizedBox(height: 4),
          // Brightness slider
          _SliderRow(
            icon: Icons.brightness_6,
            label: 'Jasność',
            value: brightness,
            min: -100,
            max: 100,
            onChanged: onBrightnessChanged,
            locked: !isPro,
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final bool locked;

  const _SliderRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: locked ? Colors.white24 : Colors.white,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: locked ? Colors.white24 : Colors.white,
                  overlayColor: Colors.white10,
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: locked ? null : onChanged,
                ),
              ),
              if (locked)
                const Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Icon(Icons.lock, color: Colors.white54, size: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          width: 42,
          child: Text(
            value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

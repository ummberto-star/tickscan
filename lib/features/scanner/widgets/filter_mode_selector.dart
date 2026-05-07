import 'package:flutter/material.dart';
import '../filter_matrix.dart';

/// Horizontal row of 3 pill-shaped buttons to switch between filter modes.
/// Free users can only use negative mode; Pro modes show a lock overlay.
class FilterModeSelector extends StatelessWidget {
  final FilterMode currentMode;
  final ValueChanged<FilterMode> onModeChanged;
  final bool isPro;

  const FilterModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
    required this.isPro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Pill(
            label: 'Negatyw',
            icon: null,
            isSelected: currentMode == FilterMode.negative,
            isLocked: false,
            onTap: () => onModeChanged(FilterMode.negative),
          ),
          _Pill(
            label: 'Kontrast',
            icon: isPro ? null : Icons.lock,
            isSelected: currentMode == FilterMode.highContrast,
            isLocked: !isPro,
            onTap: () {
              if (isPro) onModeChanged(FilterMode.highContrast);
            },
          ),
          _Pill(
            label: 'Mono Inv.',
            icon: isPro ? null : Icons.lock,
            isSelected: currentMode == FilterMode.monoInverted,
            isLocked: !isPro,
            onTap: () {
              if (isPro) onModeChanged(FilterMode.monoInverted);
            },
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white38, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isLocked ? Colors.white38 : color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

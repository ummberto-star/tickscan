import 'package:flutter/material.dart';
import '../filter_matrix.dart';

/// Horizontal row of 3 pill-shaped buttons to switch between filter modes.
class FilterModeSelector extends StatelessWidget {
  final FilterMode currentMode;
  final ValueChanged<FilterMode> onModeChanged;
  
  const FilterModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Pill(
            label: 'Negatyw',
            isSelected: currentMode == FilterMode.negative,
            onTap: () => onModeChanged(FilterMode.negative),
          ),
          _Pill(
            label: 'Kontrast',
            isSelected: currentMode == FilterMode.highContrast,
            onTap: () => onModeChanged(FilterMode.highContrast),
          ),
          _Pill(
            label: 'Mono Inv.',
            isSelected: currentMode == FilterMode.monoInverted,
            onTap: () => onModeChanged(FilterMode.monoInverted),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

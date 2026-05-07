/// Available filter modes for tick detection.
enum FilterMode {
  /// Color inversion — best for dark fur (default mode).
  negative,

  /// Boosted contrast without inversion — good for very light fur.
  highContrast,

  /// Luminance-based monochrome inversion — best for very dark fur (black lab, black cat).
  monoInverted,
}

/// Generates 4x5 color filter matrices for GPU-accelerated tick detection.
///
/// Each mode applies different transformations to make ticks visible:
/// - **negative**: full color inversion with adjustable contrast/brightness
/// - **highContrast**: boosted saturation contrast (1.6x multiplier)
/// - **monoInverted**: NTSC luminance weights, then invert — reveals details on black fur
class FilterMatrix {
  /// Build a 4x5 color filter matrix for the given mode.
  ///
  /// [contrast] range 0.5–2.5 (1.0 = neutral)
  /// [brightness] range -100 to +100 (0 = neutral)
  static List<double> build({
    required FilterMode mode,
    double contrast = 1.0,
    double brightness = 0.0,
  }) {
    switch (mode) {
      case FilterMode.negative:
        return _negative(contrast, brightness);
      case FilterMode.highContrast:
        return _highContrast(contrast, brightness);
      case FilterMode.monoInverted:
        return _monoInverted(contrast, brightness);
    }
  }

  /// Full color inversion: each channel is negated.
  static List<double> _negative(double c, double b) {
    final shift = 128 * (1 - c) + b;
    return [
      -c, 0, 0, 0, 255 - shift,
      0, -c, 0, 0, 255 - shift,
      0, 0, -c, 0, 255 - shift,
      0, 0, 0, 1, 0,
    ];
  }

  /// Boosted contrast without inversion — useful for very light fur.
  static List<double> _highContrast(double c, double b) {
    final boost = c * 1.6;
    final shift = 128 * (1 - boost) + b;
    return [
      boost, 0, 0, 0, shift,
      0, boost, 0, 0, shift,
      0, 0, boost, 0, shift,
      0, 0, 0, 1, 0,
    ];
  }

  /// Luminance-based monochrome + inversion — best for very dark fur.
  /// Uses NTSC weights: R=0.299, G=0.587, B=0.114
  static List<double> _monoInverted(double c, double b) {
    const r = 0.299;
    const g = 0.587;
    const blu = 0.114;
    final shift = 255 + b;
    return [
      -r * c, -g * c, -blu * c, 0, shift,
      -r * c, -g * c, -blu * c, 0, shift,
      -r * c, -g * c, -blu * c, 0, shift,
      0, 0, 0, 1, 0,
    ];
  }
}

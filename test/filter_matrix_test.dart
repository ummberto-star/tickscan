import 'package:flutter_test/flutter_test.dart';
import 'package:tickscan/features/scanner/filter_matrix.dart';

void main() {
  group('FilterMatrix', () {
    test('negative mode with default params produces exact matrix', () {
      final matrix = FilterMatrix.build(
        mode: FilterMode.negative,
        contrast: 1.0,
        brightness: 0.0,
      );

      expect(matrix, [
        -1, 0,  0,  0, 255,
         0, -1, 0,  0, 255,
         0,  0, -1, 0, 255,
         0,  0,  0, 1, 0,
      ]);
    });

    test('negative mode with contrast 2.0 shifts correctly', () {
      final matrix = FilterMatrix.build(
        mode: FilterMode.negative,
        contrast: 2.0,
        brightness: 0.0,
      );

      // shift = 128 * (1 - 2) + 0 = -128
      // R channel value = 255 - (-128) = 383
      expect(matrix[4], closeTo(383, 0.01));
    });

    test('highContrast mode uses 1.6x boost on diagonal', () {
      final matrix = FilterMatrix.build(
        mode: FilterMode.highContrast,
        contrast: 1.0,
        brightness: 0.0,
      );

      // boost = 1.0 * 1.6 = 1.6 on R, G, B diagonal positions
      // Matrix: [R_boost, 0, 0, 0, R_shift,
      //           0, G_boost, 0, 0, G_shift,
      //           0, 0, B_boost, 0, B_shift,
      //           0, 0, 0, 1, 0]
      expect(matrix[0], closeTo(1.6, 0.01)); // R boost
      expect(matrix[6], closeTo(1.6, 0.01)); // G boost (index 5+1)
      expect(matrix[12], closeTo(1.6, 0.01)); // B boost (index 10+2)
    });

    test('monoInverted uses NTSC weights', () {
      final matrix = FilterMatrix.build(
        mode: FilterMode.monoInverted,
        contrast: 1.0,
        brightness: 0.0,
      );

      // Row 0 uses R=0.299, G=0.587, B=0.114 (negated)
      expect(matrix[0], closeTo(-0.299, 0.001));
      expect(matrix[1], closeTo(-0.587, 0.001));
      expect(matrix[2], closeTo(-0.114, 0.001));
      // Shift = 255 + 0 = 255
      expect(matrix[4], closeTo(255, 0.01));
    });

    test('brightness affects shift values in negative mode', () {
      final brightMatrix = FilterMatrix.build(
        mode: FilterMode.negative,
        contrast: 1.0,
        brightness: 50.0,
      );

      final darkMatrix = FilterMatrix.build(
        mode: FilterMode.negative,
        contrast: 1.0,
        brightness: -50.0,
      );

      // shift = 128*(1-c)+b. For c=1: shift = b.
      // Channel = 255 - shift = 255 - b.
      // So positive brightness → lower channel value (darker output shift).
      // Negative brightness → higher channel value (brighter output shift).
      // Verify they differ from default (255) and from each other.
      expect(brightMatrix[4], lessThan(255)); // brightness +50 → 205
      expect(darkMatrix[4], greaterThan(255)); // brightness -50 → 305
      expect(brightMatrix[4], lessThan(darkMatrix[4]));
    });

    test('all modes return 20-element lists', () {
      for (final mode in FilterMode.values) {
        final matrix = FilterMatrix.build(mode: mode);
        expect(matrix.length, 20);
      }
    });

    test('last row always [0,0,0,1,0] for alpha passthrough', () {
      for (final mode in FilterMode.values) {
        final matrix = FilterMatrix.build(mode: mode);
        expect(matrix[15], 0);
        expect(matrix[16], 0);
        expect(matrix[17], 0);
        expect(matrix[18], 1);
        expect(matrix[19], 0);
      }
    });
  });
}

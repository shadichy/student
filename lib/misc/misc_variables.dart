import 'dart:math';

import 'package:flutter/material.dart';

Random random = Random();

List<Color> m3PrimeColor = Colors.primaries
    .map<Color>(
      (Color c) => ColorScheme.fromSeed(seedColor: c).primary.withAlpha(127),
    )
    .toList();

Color randomFromSeed(Color seed, {double delta = 1}) {
  List<int> rgb = [seed.red, seed.green, seed.blue];
  rgb = rgb.map<int>((int c) {
    return c + ((255 - c) * delta).floor();
  }).toList();
  return Color.fromARGB(255, rgb[0], rgb[1], rgb[2]);
}

Future<void> m3SeededColor(Color seed) async {
  M3SeededColor.colors = List.generate(
    Colors.primaries.length,
    (_) => randomFromSeed(
      seed,
      // delta: random.nextDouble() * .75,
      // delta: .16 * _,
      delta: (_ % 2) * .68 + (1 - 2 * (_ % 2)) * .16 * _,
    ),
  );
}

abstract final class M3SeededColor {
  static late final List<Color> colors;
}

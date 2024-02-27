import 'package:flutter/material.dart';

List<Color> m3PrimeColor = Colors.primaries
    .asMap()
    .map<int, Color>((int i, Color c) {
      ColorScheme c_ = ColorScheme.fromSeed(seedColor: c);
      return MapEntry(
        i,
        (i & 1 == 0) ? c_.primary : c_.secondary,
      );
    })
    .values
    .map<Color>((Color c) => c.withAlpha(127))
    .toList();

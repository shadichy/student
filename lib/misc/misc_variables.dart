import 'package:flutter/material.dart';

List<Color> m3PrimeColor = Colors.primaries
    .map<Color>(
      (Color c) => ColorScheme.fromSeed(seedColor: c).primary.withAlpha(127),
    )
    .toList();

import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';

class SchoolTopBar extends StatelessWidget {
  const SchoolTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Option(
          'drawer',
          const Icon(Symbols.sort),
          (context) => Scaffold.of(context).openDrawer(),
        ),
        Options.notifications,
      ].map((Option o) {
        return IconOption(
          o,
          iconColor: colorScheme.onPrimaryContainer,
          iconSize: 24,
          // padding: const EdgeInsets.all(8),
          // backgroundColor: colorScheme.primaryContainer,
        );
      }).toList(),
    );
  }
}

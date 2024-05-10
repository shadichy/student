import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';

class SchoolTopBar extends StatelessWidget {
  const SchoolTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Symbols.sort),
          onPressed: Scaffold.of(context).openDrawer,
          color: colorScheme.onPrimaryContainer,
          iconSize: 24,
        ),
        IconOption(
          'notif',
          color: colorScheme.onPrimaryContainer,
          iconSize: 24,
        )
      ],
    );
  }
}

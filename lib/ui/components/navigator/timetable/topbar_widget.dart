import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';

class TimetableTopBar extends StatelessWidget {
  const TimetableTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconOption(
          Option(
            'drawer',
            const Icon(Symbols.menu),
            (context) => Scaffold.of(context).openDrawer(),
          ),
          iconColor: colorScheme.onSurface,
          iconSize: 20,
          // padding: const EdgeInsets.all(8),
        ),
        Text(
          "Thời khoá biểu",
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        IconOption(
          Options.search,
          iconColor: colorScheme.onSurface,
          iconSize: 20,
          // backgroundColor: colorScheme.primaryContainer,
          // padding: const EdgeInsets.all(8),
        ),
      ],
    );
  }
}

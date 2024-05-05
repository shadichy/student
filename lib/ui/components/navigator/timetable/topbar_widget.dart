import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';

class TimetableTopBar extends StatelessWidget {
  const TimetableTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconOption(
          Option(
            const Icon(Icons.menu_outlined),
            "",
            (context) => Scaffold.of(context).openDrawer(),
          ),
          iconColor: colorScheme.onSurface,
          iconSize: 20,
          // padding: const EdgeInsets.all(8),
        ),
        Text(
          "Thời khoá biểu",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
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

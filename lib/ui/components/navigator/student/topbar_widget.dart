import 'package:flutter/material.dart';
import 'package:student/core/routing.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/pages/settings/svg_theme.dart';

class StudentTopBar extends StatelessWidget {
  const StudentTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: SvgIcon(
            primary: colorScheme.primaryContainer,
            container: colorScheme.primary,
            tertiary: colorScheme.tertiary,
            size: 24,
          ),
          onPressed: () => Routing.goto(context, Routing.themes),
          color: colorScheme.onPrimaryContainer,
          iconSize: 24,
          // padding: const EdgeInsets.all(8),
          // backgroundColor: colorScheme.primaryContainer,
        ),
        IconOption(
          'notif',
          color: colorScheme.onPrimaryContainer,
          iconSize: 24,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/pages/settings/svg_theme.dart';
import 'package:student/ui/pages/settings/themes.dart';

class StudentTopBar extends StatelessWidget {
  const StudentTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Option(
          'theme',
          SvgIcon(
            primary: colorScheme.primaryContainer,
            container: colorScheme.primary,
            tertiary: colorScheme.tertiary,
            size: 24,
          ),
          (context) {
            Options.goto(context, const SettingsThemesPage());
          },
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

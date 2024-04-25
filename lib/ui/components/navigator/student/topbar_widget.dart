import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/pages/settings/svg_theme.dart';

class StudentTopBar extends StatelessWidget {
  const StudentTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Option(
          SvgIcon(
            primary: colorScheme.primaryContainer,
            container: colorScheme.primary,
            tertiary: colorScheme.tertiary,
            size: 24,
          ),
          "",
          (context) {
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => target,
            // ));
          },
        ),
        Options.notifications,
      ]
          .map(
            (Option o) => IconOption(
              o,
              iconColor: colorScheme.onSecondaryContainer,
              iconSize: 24,
              // padding: const EdgeInsets.all(8),
              // backgroundColor: colorScheme.secondaryContainer,
            ),
          )
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';

class SchoolTopBar extends StatefulWidget {
  const SchoolTopBar({super.key});

  @override
  State<SchoolTopBar> createState() => _SchoolTopBarState();
}

class _SchoolTopBarState extends State<SchoolTopBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Option(Icons.sort, "", (context) => Scaffold.of(context).openDrawer),
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
      ),
    );
  }
}

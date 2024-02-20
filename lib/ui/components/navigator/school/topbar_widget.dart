import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/quick_option.dart';

class SchoolTopBar extends StatefulWidget {
  const SchoolTopBar({super.key});

  @override
  State<SchoolTopBar> createState() => _SchoolTopBarState();
}

class _SchoolTopBarState extends State<SchoolTopBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return IconOption(
      Option(Icons.sort, "", Scaffold.of(context).openDrawer),
      margin: const EdgeInsets.symmetric(vertical: 8),
      iconColor: colorScheme.onSecondaryContainer,
      iconSize: 28,
      padding: const EdgeInsets.all(8),
      // backgroundColor: colorScheme.secondaryContainer,
    );
  }
}

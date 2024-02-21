import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/quick_option.dart';

class TimetableTopBar extends StatefulWidget {
  const TimetableTopBar({ super.key });

  @override
  State<TimetableTopBar> createState() => _TimetableTopBarState();
}

class _TimetableTopBarState extends State<TimetableTopBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      title: Text(
        "Thời khoá biểu",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: colorScheme.onSecondaryContainer,
        ),
      ),
      leading: IconOption(
        Option(Icons.menu, "", Scaffold.of(context).openDrawer),
        iconColor: colorScheme.onSecondaryContainer,
        iconSize: 28,
        padding: const EdgeInsets.all(8),
      ),
      trailing: IconOption(
        Options.search,
        iconColor: colorScheme.onSecondaryContainer,
        iconSize: 28,
        backgroundColor: colorScheme.secondaryContainer,
        padding: const EdgeInsets.all(8),
      ),
      tileColor: colorScheme.background,
    );
  }
}
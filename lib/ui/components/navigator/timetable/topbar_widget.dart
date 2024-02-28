import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';

class TimetableTopBar extends StatefulWidget {
  const TimetableTopBar({super.key});

  @override
  State<TimetableTopBar> createState() => _TimetableTopBarState();
}

class _TimetableTopBarState extends State<TimetableTopBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        "Thời khoá biểu",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      leading: IconOption(
        Option(Icons.menu, "", (context) => Scaffold.of(context).openDrawer),
        iconColor: colorScheme.onSurface,
        iconSize: 20,
        // padding: const EdgeInsets.all(8),
      ),
      trailing: IconOption(
        Options.search,
        iconColor: colorScheme.onSurface,
        iconSize: 20,
        // backgroundColor: colorScheme.secondaryContainer,
        // padding: const EdgeInsets.all(8),
      ),
      tileColor: colorScheme.surface,
    );
  }
}

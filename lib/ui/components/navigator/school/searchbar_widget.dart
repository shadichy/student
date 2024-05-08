import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/ui/components/options.dart';

class SchoolSearchBar extends StatefulWidget {
  const SchoolSearchBar({super.key});

  @override
  State<SchoolSearchBar> createState() => _SchoolSearchBarState();
}

class _SchoolSearchBarState extends State<SchoolSearchBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        onTap: () => Options.search.target(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        tileColor: colorScheme.primary.withOpacity(0.1),
        leading: Icon(
          Symbols.search,
          color: colorScheme.onPrimaryContainer,
          size: 20,
        ),
        title: Text(
          "Search Documents...",
          style: textTheme.titleMedium?.apply(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

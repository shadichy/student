import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
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
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        bottom: 16,
        right: 8
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: Options.search.target,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: colorScheme.tertiaryContainer,
                elevation: 0,
              ),
              child: Text(
                "Search Documents...",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: colorScheme.onTertiaryContainer,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          IconOption(
            Options.search,
            padding: const EdgeInsets.all(8),
            iconSize: 28,
            iconColor: colorScheme.onTertiaryContainer,
            backgroundColor: colorScheme.tertiaryContainer,
          ),
        ],
      ),
    );
  }
}

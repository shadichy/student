import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/generator/db.dart';
import 'package:student/core/generator/generator.dart';

import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/tools/generated_instances.dart';

class ToolsBookmarkedSamplesPage extends StatefulWidget implements TypicalPage {
  const ToolsBookmarkedSamplesPage({super.key});

  @override
  State<ToolsBookmarkedSamplesPage> createState() =>
      _ToolsBookmarkedSamplesPageState();

  @override
  Icon get icon => const Icon(Symbols.calendar_add_on);

  @override
  String get title => "Bookmarked";
}

class _ToolsBookmarkedSamplesPageState
    extends State<ToolsBookmarkedSamplesPage> {
  late List<SampleTimetable> values;

  void setValue() => values = GenDB().values;

  @override
  void initState() {
    setValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GeneratedInstance(
      title: widget.title,
      actions: const [],
      results: GenResult.virtual(values),
      trigger: (data) => IconButton.filled(
        onPressed: () => GenDB().remove(data).then((_) {
          if (context.mounted) setState(setValue);
        }),
        icon: const Icon(Symbols.bookmark_remove),
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: colorScheme.errorContainer,
        ),
        color: colorScheme.error,
      ),
    );
  }
}

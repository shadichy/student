import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/generator/db.dart';
import 'package:student/core/generator/generator.dart';
import 'package:student/core/routing.dart';

import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/tools/generated_instances.dart';

class ToolsGeneratorInstancePage extends StatelessWidget
    implements TypicalPage {
  final GenResult results;
  const ToolsGeneratorInstancePage(this.results, {super.key});

  @override
  Icon get icon => const Icon(Symbols.calendar_add_on);

  @override
  String get title => "Generated";

  @override
  Widget build(BuildContext context) {
    return GeneratedInstance(
      title: title,
      actions: [
        IconButton(
          onPressed: () => Routing.goto(context, Routing.bookmarked_samples),
          icon: const Icon(Symbols.bookmark),
        ),
      ],
      trigger: (data) => IconButton.filled(
        onPressed: () => GenDB().add(data),
        icon: const Icon(Symbols.bookmark_add),
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(16),
        ),
      ),
      results: results,
    );
  }
}

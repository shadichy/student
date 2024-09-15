import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:student/core/generator/generator.dart';

import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/tools/timetable_preview.dart';

class ToolsGeneratorInstancePage extends StatefulWidget implements TypicalPage {
  final GenResult results;
  const ToolsGeneratorInstancePage(this.results, {super.key});

  @override
  State<ToolsGeneratorInstancePage> createState() =>
      _ToolsGeneratorInstancePageState();

  @override
  Icon get icon => const Icon(Symbols.calendar_add_on);

  @override
  String get title => "Preview";
}

class _ToolsGeneratorInstancePageState
    extends State<ToolsGeneratorInstancePage> {
  late final results = widget.results.output;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall,
          maxLines: 3,
        ),
      ),
      body: ScrollSnapList(
        itemBuilder: (_, i) => TimetablePreview(results[i]),
        itemCount: results.length,
        itemSize: MediaQuery.of(context).size.width,
        onItemFocus: (_) {},
        duration: 300,
        curve: Curves.easeOut,
      ),
    );
  }
}

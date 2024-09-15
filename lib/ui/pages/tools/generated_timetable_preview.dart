import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/core/timetable/semester_timetable.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/learning/timetable.dart';

class ToolsGeneratedTimetablePreview extends StatefulWidget
    implements TypicalPage {
  final WeekTimetable timetable;
  const ToolsGeneratedTimetablePreview(this.timetable, {super.key});

  @override
  State<ToolsGeneratedTimetablePreview> createState() =>
      _ToolsGeneratedTimetablePreviewState();

  @override
  Icon get icon => const Icon(Symbols.book);

  @override
  String get title => "Preview";
}

class _ToolsGeneratedTimetablePreviewState
    extends State<ToolsGeneratedTimetablePreview> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(bodyColor: colorScheme.onPrimaryContainer);
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
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        toolbarHeight: 72,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: TimetableBox(widget.timetable),
      ),
    );
  }
}

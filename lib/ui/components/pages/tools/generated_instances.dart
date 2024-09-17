import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:student/core/generator/generator.dart';

import 'package:student/ui/components/pages/tools/timetable_preview.dart';

class GeneratedInstance extends StatelessWidget {
  final String title;
  final GenResult results;
  final List<Widget> actions;
  final Widget Function(SampleTimetable data) trigger;
  const GeneratedInstance({
    super.key,
    required this.title,
    required this.actions,
    required this.results,
    required this.trigger,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    final ctl = ScrollController();
    void scrollTo(int index) =>
        ctl.jumpTo(index * MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: textTheme.headlineSmall,
          maxLines: 3,
        ),
        actions: actions,
      ),
      body: ScrollSnapList(
        listController: ctl,
        itemBuilder: (_, i) => TimetablePreview(
          results.output[i],
          scrollFunction: scrollTo,
          action: trigger,
          index: i,
        ),
        itemCount: results.length,
        itemSize: MediaQuery.of(context).size.width,
        onItemFocus: (_) {},
        duration: 300,
        curve: Curves.easeOut,
      ),
    );
  }
}

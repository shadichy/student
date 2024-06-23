import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/home/upcoming_event.dart';
import 'package:student/ui/components/pages/event.dart';

class HomeNextupClassWidget extends StatefulWidget {
  final SampleTimetableData timetableData;
  const HomeNextupClassWidget(this.timetableData, {super.key});

  @override
  State<HomeNextupClassWidget> createState() => _HomeNextupClassWidgetState();
}

class _HomeNextupClassWidgetState extends State<HomeNextupClassWidget> {
  final Iterable<UpcomingEvent> classStamps = Storage().upcomingEvents.map(
      (e) => e is CourseTimestamp
          ? NextupClassView(e)
          : UpcomingEvent.fromTimestamp(e));

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    List<Widget> content = [
      ...classStamps.map((c) => HomeNextupClassCard(c)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          Symbols.done,
          color: colorScheme.onSurface,
          size: 32,
        ),
      ),
    ];

    // return SingleChildScrollView(
    //       scrollDirection: Axis.horizontal,
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 8),
    //         child: Row(
    //           children: content,
    //         ),
    //       ),
    //     );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SectionLabel(
        //   "Next-up classes",
        //   Options.forward((BuildContext context) {}),
        //   fontWeight: FontWeight.w300,
        //   fontSize: 20,
        //   color: colorScheme.onSurface,
        // ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: content,
            ),
          ),
        ),
      ],
    );
  }
}

class NextupEventWidget extends StatefulWidget {
  const NextupEventWidget({super.key});

  @override
  State<NextupEventWidget> createState() => _NextupEventWidgetState();
}

class _NextupEventWidgetState extends State<NextupEventWidget> {
  late final Iterable<UpcomingEvent> _classStamps;
  Iterable<Widget> _content = [];

  @override
  void initState() {
    super.initState();
    try {
      _classStamps = Storage()
          .upcomingEvents
          .take(Storage().fetch<int>(Config.misc.maxUEventItems) ?? 3)
          .map((e) {
        return e is CourseTimestamp
            ? NextupClassView(e)
            : UpcomingEvent.fromTimestamp(e);
      });
    } catch (_) {
      _classStamps = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    if (_classStamps.isNotEmpty) {
      _content = _classStamps.indexed.map((e) {
        return NextupEventCard(
          e.$2,
          priority: Priority.values[e.$1 == 0 ? 0 : 1],
          borderType: BorderType.values.elementAt(
            _classStamps.length == 1
                ? 3
                : e.$1 == 0
                    ? 0
                    : e.$1 + 1 == _classStamps.length
                        ? 1
                        : 2,
          ),
        );
      });
    } else {
      _content = [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Symbols.done,
            color: colorScheme.onSurface,
            size: 32,
          ),
        )
      ];
    }
    return Column(
      children: List.generate(_content.length * 2 - 1, (i) {
        return i % 2 == 0 ? _content.elementAt(i ~/ 2) : MWds.divider();
      }),
    );
  }
}

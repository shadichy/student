import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/home/upcoming_event.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/upcoming.dart';

class HomeNextupClassWidget extends StatefulWidget {
  final SampleTimetableData timetableData;
  const HomeNextupClassWidget(this.timetableData, {super.key});

  @override
  State<HomeNextupClassWidget> createState() => _HomeNextupClassWidgetState();
}

class _HomeNextupClassWidgetState extends State<HomeNextupClassWidget> {
  List<UpcomingEvent> classStamps = UpcomingData.upcomingEvents
      .map((e) => e is CourseTimestamp
          ? NextupClassView(e)
          : UpcomingEvent.fromTimestamp(e))
      .toList();

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

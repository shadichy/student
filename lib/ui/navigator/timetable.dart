import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/navigator/timetable/upcoming_event_widget.dart';
import 'package:student/ui/components/navigator/timetable/timetable_widget.dart';
import 'package:student/ui/components/navigator/timetable/topbar_widget.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/upcoming.dart';

import 'package:student/ui/components/with_appbar.dart';

class TimetablePage extends StatelessWidget implements TypicalPage {
  TimetablePage({super.key});

  final List<UpcomingEvent> _classStamps = UpcomingData.upcomingEvents
      .map((e) => e is CourseTimestamp
          ? NextupClassView(e)
          : UpcomingEvent.fromTimestamp(e))
      .toList();

  bool get hasData => _classStamps.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    return WithAppbar(
      appBar: const TimetableTopBar(),
      body: [
        if (hasData) TimetableUpcomingWidget(_classStamps),
        const TimetableWidget(),
        // const ResultSummaryWidget(),
        // const MajorInfoWidget(),
        MWds.divider(16),
      ],
    );
  }

  @override
  Icon get icon => const Icon(Symbols.calendar_month);

  @override
  String get title => "Timetable";
}

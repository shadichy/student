import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/routing.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/navigator/timetable/timetable_widget.dart';
import 'package:student/ui/components/navigator/timetable/topbar_widget.dart';
import 'package:student/ui/components/navigator/timetable/upcoming_event_widget.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/with_appbar.dart';

class TimetablePage extends StatefulWidget implements TypicalPage {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();

  @override
  Icon get icon => const Icon(Symbols.calendar_month);

  @override
  String get title => "Timetable";
}

class _TimetablePageState extends State<TimetablePage> {
  final bool _isNewSemester = SPBasics().isNewSemester;

  @override
  void initState() {
    super.initState();
    if (_isNewSemester) {
      WidgetsBinding.instance.addPostFrameCallback((_) => gotoGenerator());
    }
  }

  void gotoGenerator() => Routing.goto(context, Routing.generator);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    final classStamps = Storage().upcomingEvents.map((e) => e is CourseTimestamp
        ? NextupClassView(e)
        : UpcomingEvent.fromTimestamp(e));
    return WithAppbar(
      appBar: const TimetableTopBar(),
      body: [
        if (_isNewSemester)
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: gotoGenerator,
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16)
              ),
              child: Text(
                "Go to Generator for new semester",
                style: textTheme.labelLarge?.apply(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        if (classStamps.isNotEmpty) TimetableUpcomingWidget(classStamps),
        const TimetableWidget(),
        // const ResultSummaryWidget(),
        // const MajorInfoWidget(),
        MWds.divider(16),
      ],
    );
  }
}

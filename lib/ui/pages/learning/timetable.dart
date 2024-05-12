import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/generator/generator.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/pages/learning/timetable.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class LearningTimetablePage extends StatelessWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.calendar_month);

  @override
  String get title => "Thời khoá biểu";

  const LearningTimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(bodyColor: colorScheme.onPrimaryContainer);

    DateTime now = DateTime.now();
    int weekday = now.weekday % 7;
    DateTime firstDoW = now.subtract(Duration(days: weekday));
    DateTime lastDoW = now.add(Duration(days: 6 - weekday));

    String dateFormat(DateTime date) {
      return MiscFns.timeFormat(date, format: "dd/MM");
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        title: Text(
          "${dateFormat(firstDoW)} - ${dateFormat(lastDoW)}",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Week 1 ",
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    Symbols.arrow_drop_down,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(
            width: 8,
            color: Colors.transparent,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Symbols.date_range,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const VerticalDivider(
            width: 8,
            color: Colors.transparent,
          )
        ],
        toolbarHeight: 72,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: TimetableBox(
          SampleTimetable(classes: [
            SubjectCourse(
              courseID: "classID1",
              subjectID: "subjectID1",
              timestamp: [
                CourseTimestamp(
                  intStamp: 123,
                  dayOfWeek: 4,
                  courseID: "classID1",
                  teacherID: "teacherID",
                  room: "A929",
                  timestampType: TimestampType.offline,
                )
              ],
            ),
            SubjectCourse(
              courseID: "classID2",
              subjectID: "subjectID2",
              timestamp: [
                CourseTimestamp(
                  intStamp: 132,
                  dayOfWeek: 5,
                  courseID: "classID2",
                  teacherID: "teacherID",
                  room: "B666",
                  timestampType: TimestampType.offline,
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

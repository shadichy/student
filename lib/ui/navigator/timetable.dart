import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/core/generator/generator.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/timetable/upcoming_event_widget.dart';
import 'package:student/ui/components/navigator/timetable/timetable_widget.dart';
import 'package:student/ui/components/navigator/timetable/topbar_widget.dart';

import 'package:student/ui/components/with_appbar.dart';

class TimetablePage extends StatelessWidget {
  TimetablePage({super.key});
  late final bool hasData = [].isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    return WithAppbar(
      appBar: const TimetableTopBar(),
      body: [
        TimetableUpcomingWidget(SampleTimetableData.from2dList([])),
        TimetableWidget(
          SampleTimetable(classes: [
            SubjectCourse(
              courseID: "classID1",
              subjectID: "subjectID1",
              timestamp: const [
                CourseTimeStamp(
                  intStamp: 123,
                  dayOfWeek: 4,
                  courseID: "classID1",
                  teacherID: "teacherID",
                  room: "A929",
                  timeStampType: TimeStampType.offline,
                )
              ],
            ),
            SubjectCourse(
              courseID: "classID2",
              subjectID: "subjectID2",
              timestamp: const [
                CourseTimeStamp(
                  intStamp: 132,
                  dayOfWeek: 5,
                  courseID: "classID2",
                  teacherID: "teacherID",
                  room: "B666",
                  timeStampType: TimeStampType.offline,
                )
              ],
            ),
          ]),
        ),
        // const ResultSummaryWidget(),
        // const MajorInfoWidget(),
        const Divider(
          color: Colors.transparent,
          height: 16,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:student/core/functions.dart';
import 'package:student/core/generator.dart';
import 'package:student/misc/parser.dart';
import 'package:student/ui/components/navigator/timetable/major_info_widget.dart';
import 'package:student/ui/components/navigator/timetable/nextup_class_widget.dart';
import 'package:student/ui/components/navigator/timetable/result_summary_widget.dart';
import 'package:student/ui/components/navigator/timetable/timetable_widget.dart';
import 'package:student/ui/components/navigator/timetable/topbar_widget.dart';

class TimetablePage extends StatelessWidget {
  TimetablePage({super.key});
  late final bool hasData = [].isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const TimetableTopBar(),
          TimetableNextupClassWidget(TimetableData.from2dList([])),
          TimetableWidget(
            BaseTimetable(classes: [
              SubjectCourse(
                classID: "classID1",
                subjectID: "subjectID1",
                timestamp: const [
                  CourseTimeStamp(
                    intStamp: 123,
                    dayOfWeek: 4,
                    classID: "classID1",
                    teacherID: "teacherID",
                    room: "room",
                    classType: ClassType.offline,
                  )
                ],
              ),
              SubjectCourse(
                classID: "classID2",
                subjectID: "subjectID2",
                timestamp: const [
                  CourseTimeStamp(
                    intStamp: 132,
                    dayOfWeek: 5,
                    classID: "classID2",
                    teacherID: "teacherID",
                    room: "room",
                    classType: ClassType.offline,
                  )
                ],
              ),
            ]),
          ),
          const ResultSummaryWidget(),
          const MajorInfoWidget(),
        ],
      ),
    );
  }
}

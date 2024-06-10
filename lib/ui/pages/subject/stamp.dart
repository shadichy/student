import 'package:bitcount/bitcount.dart';
import 'package:flutter/material.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/ui/components/pages/event_detail.dart';

import 'package:student/ui/components/navigator/navigator.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/pages/subject/course.dart';
import 'package:student/ui/pages/subject/subject.dart';

class SubjectStampPage extends StatefulWidget implements TypicalPage {
  static List<String> shortDayOfWeek = const [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];
  final String _title;
  final CourseTimestamp stamp;
  SubjectStampPage(this.stamp, {super.key})
      : _title =
            "${stamp.room} \u2022 ${shortDayOfWeek[stamp.dayOfWeek]} C${(() {
          int classStartsAt = 0;
          while (stamp.intStamp & (1 << classStartsAt) == 0) {
            classStartsAt++;
          }
          int classLength = stamp.intStamp.bitCount();
          return "${classStartsAt + 1}-${classStartsAt + classLength}";
        })()} ${stamp.courseID}${stamp.courseType == null ? "" : "_${stamp.courseType!.name}"}";

  @override
  State<SubjectStampPage> createState() => _SubjectStampPageState();

  @override
  Icon get icon => const Icon(Symbols.event);

  @override
  String get title => _title;
}

class _SubjectStampPageState extends State<SubjectStampPage> {
  late final courseID = widget.stamp.courseID;
  late BaseSubject subject = Storage().getSubjectAlt(courseID) ??
      Storage().getSubjectBaseAlt(courseID)!;
  late SubjectCourse course = Storage().getCourse(courseID)!;
  late String teacher = widget.stamp.teacherID;

  final List<String> dayOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    return EventPage(
      label: "Thông tin lớp học",
      title: widget.title,
      children: [
        SubPage(
          label: "Subject name",
          desc: subject.name,
          target: SubjectPage(subject),
        ),
        SubPage(
          label: "Course name",
          desc: courseID,
          target: SubjectCoursePage(course),
        ),
        SubPage(
          label: "Instructor/Teacher",
          desc: "($teacher) ${Storage().getTeacher(teacher)}",
        ),
        SubPage(
          label: "Week day",
          desc: dayOfWeek[widget.stamp.dayOfWeek],
        ),
        if (widget.stamp.timestampType == TimestampType.offline)
          SubPage(
            label: "Room",
            desc: widget.stamp.room,
          )
        else
          const SubPage(label: "Elearning"),
        SubPage(
          label: "Code",
          desc: "${widget.stamp.intStamp}",
        ),
      ],
    );
  }
}

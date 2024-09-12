import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/pages/event_detail.dart';
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
  final CourseTimestamp stamp;

  const SubjectStampPage(this.stamp, {super.key});

  @override
  State<SubjectStampPage> createState() => _SubjectStampPageState();

  @override
  Icon get icon => const Icon(Symbols.event);

  @override
  String get title =>
      "${stamp.room} ${stamp.dayOfWeek} ${stamp.intStamp} ${stamp.courseID}";
}

class _SubjectStampPageState extends State<SubjectStampPage> {
  late final courseID = widget.stamp.courseID;
  late BaseSubject subject = Storage().getSubjectAlt(courseID) ??
      Storage().getSubjectBaseAlt(courseID)!;
  late SubjectCourse course = Storage().getCourse(courseID)!;
  late String teacher = widget.stamp.teacherID;
  late final eventData = NextupClassView(widget.stamp, subject.name);

  late final String dayOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ][widget.stamp.dayOfWeek];

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    return EventPage(
      label: "Thông tin lớp học",
      title: subject.name,
      subtitle: "$courseID \u2022 $dayOfWeek",
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
          label: "Start time",
          desc: MiscFns.timeFormat(eventData.startTime),
        ),
        SubPage(
          label: "End time",
          desc: MiscFns.timeFormat(eventData.endTime),
        ),
        SubPage(
          label: "Week day",
          desc: dayOfWeek,
        ),
        SubPage(
          label: "Instructor/Teacher",
          desc: "($teacher) ${Storage().getTeacher(teacher)}",
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

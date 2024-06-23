import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/ui/components/interpolator.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/event_detail.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/pages/subject/stamp.dart';
import 'package:student/ui/pages/subject/subject.dart';

class SubjectCoursePage extends StatefulWidget implements TypicalPage {
  final SubjectCourse course;
  const SubjectCoursePage(this.course, {super.key});

  @override
  State<SubjectCoursePage> createState() => _SubjectCoursePageState();

  @override
  Icon get icon => const Icon(Symbols.library_books);

  @override
  String get title => course.courseID;
}

class _SubjectCoursePageState extends State<SubjectCoursePage> {
  late BaseSubject subject = Storage().getSubjectAlt(widget.title) ??
      Storage().getSubjectBaseAlt(widget.title)!;
  List<bool> expanded = [false, false];

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    return EventPage(
      label: "Thông tin khoá học",
      title: subject.name,
      subtitle: widget.title,
      children: [
        SubPage(
          label: "Subject name",
          desc: subject.name,
          target: SubjectPage(subject),
        ),
        ExpansionPanelList(
          materialGapSize: 0,
          expandedHeaderPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          elevation: 0,
          expansionCallback: (int index, bool isExpanded) {
            setState(() => expanded[index] = isExpanded);
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: expanded[0],
              headerBuilder: (context, b) =>
                  const SubPage(label: "Course instructors/teachers"),
              body: SimpleListBuilder(
                builder: (index) {
                  String id = widget.course.teachers[index];
                  return SubPage(
                    label: id,
                    desc: Storage().getTeacher(id),
                  );
                },
                itemCount: widget.course.teachers.length,
              ),
            ),
            ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: expanded[1],
              headerBuilder: (context, b) =>
                  const SubPage(label: "Course timestamps"),
              body: SimpleListBuilder(
                builder: (index) {
                  CourseTimestamp stamp = widget.course.timestamp[index];
                  SubjectStampPage stampPage = SubjectStampPage(stamp);
                  return SubPage(
                    label: stampPage.title,
                    desc: "(${stamp.intStamp}) ${stamp.courseID}",
                    target: stampPage,
                  );
                },
                itemCount: widget.course.timestamp.length,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

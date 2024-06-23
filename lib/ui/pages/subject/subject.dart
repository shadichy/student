import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/ui/components/interpolator.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/event_detail.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/pages/subject/course.dart';

class SubjectPage extends StatefulWidget implements TypicalPage {
  final BaseSubject subject;
  const SubjectPage(this.subject, {super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();

  @override
  Icon get icon => const Icon(Symbols.subject);

  @override
  String get title => subject.name;
}

class _SubjectPageState extends State<SubjectPage> {
  List<bool> expanded = [false, false];
  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    return EventPage(
      label: "Thông tin môn học",
      title: widget.title,
      children: [
        SubPage(
          label: "Subject code",
          desc: widget.subject.subjectID,
        ),
        if (widget.subject.subjectAltID != null)
          SubPage(
            label: "Subject acronym",
            desc: widget.subject.subjectAltID,
          ),
        SubPage(
          label: "Subject credit",
          desc: "${widget.subject.cred}",
        ),
        SubPage(
          label: "Subject coefficient",
          desc: "${widget.subject.coef}",
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
                  const SubPage(label: "Subject dependencies"),
              body: SimpleListBuilder(
                builder: (index) {
                  String id = widget.subject.dependencies[index];
                  BaseSubject s =
                      Storage().getSubject(id) ?? Storage().getSubjectBase(id)!;
                  return SubPage(
                    label: s.subjectID,
                    desc: s.name,
                    target: SubjectPage(s),
                  );
                },
                itemCount: widget.subject.dependencies.length,
              ),
            ),
            if (widget.subject is Subject)
              ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: expanded[1],
                headerBuilder: (context, b) =>
                    const SubPage(label: "Subject courses"),
                body: SimpleListBuilder(
                  builder: (index) {
                    SubjectCourse course = (widget.subject as Subject)
                        .courses
                        .values
                        .elementAt(index);
                    return SubPage(
                      label: course.courseID,
                      target: SubjectCoursePage(course),
                    );
                  },
                  itemCount: (widget.subject as Subject).courses.length,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

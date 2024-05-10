import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/ui/components/pages/event_detail.dart';

import 'package:student/ui/components/navigator/navigator.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SubjectCoursePage extends StatelessWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.library_books);

  @override
  String get title => course.courseID;

  final SubjectCourse course;
  const SubjectCoursePage(this.course, {super.key});

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    return EventPage(
      label: "Thông tin khoá học",
      title: title,
      children: const [],
    );
  }
}

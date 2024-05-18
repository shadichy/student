import 'package:flutter/material.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/subject_courses.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/routing.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class LabeledSection extends StatelessWidget {
  final UserGroup group;
  final UserSemester semester;
  final List<BaseSubject> subjects;
  const LabeledSection({
    super.key,
    required this.group,
    required this.semester,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "${group.name.toUpperCase()} ${semester.name.toUpperCase()}",
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        ...List.generate(subjects.length, (index) {
          TypicalPage t = Routing.subject(
            InStudyCourses().getSubject(subjects[index].name)!,
          );
          return SubPage(
            label: t.title,
            target: t,
            icon: Icon(t.icon.icon, size: 28),
            minVerticalPadding: 16,
          );
        }),
        MWds.divider(16),
      ],
    );
  }
}

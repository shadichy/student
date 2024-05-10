import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/ui/components/pages/event_detail.dart';

import 'package:student/ui/components/navigator/navigator.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SubjectPage extends StatelessWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.subject);

  @override
  String get title => subject.name;

  final Subject subject;
  const SubjectPage(this.subject, {super.key});

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // TextTheme textTheme = Theme.of(context).textTheme;
    return EventPage(
      label: "Thông tin môn học",
      title: title,
      children: const [],
    );
  }
}

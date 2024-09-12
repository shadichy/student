import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/ui/components/navigator/navigator.dart';

class SubjectUpcomingEventPage extends StatelessWidget implements TypicalPage {
  const SubjectUpcomingEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  Icon get icon => const Icon(Symbols.abc);

  @override
  String get title => "Upcoming event";
}

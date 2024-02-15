import 'package:flutter/material.dart';
import 'package:student/ui/components/options.dart';

abstract final class Options {
  static Option Function(void Function()) add =
      (void Function() f) => Option(Icons.add, f);

  static Option notifications = Option(Icons.notifications, () => {});

  static Option help = Option(Icons.help, () => {});

  static Option search = Option(Icons.search, () => {});

  static Option settings = Option(Icons.settings, () => {});

  static Option student_finance = Option(Icons.credit_card, () => {});

  static Option study_program = Option(Icons.book, () => {});

  static Option study_results = Option(Icons.assignment, () => {});

  static Option timetable = Option(Icons.calendar_month, () => {});

  static Option user = Option(Icons.manage_accounts, () => {});
}

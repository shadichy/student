import 'package:material_symbols_icons/material_symbols_icons.dart';
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/pages/help/mdviewer.dart';
import 'package:student/ui/pages/info/student.dart';
import 'package:student/ui/pages/learning/finance.dart';
import 'package:student/ui/pages/learning/timetable.dart';
import 'package:student/ui/pages/settings/settings.dart';

Map<String, String> optionDictionary = {
  'notif': "Thông báo",
  'help': "Hướng dẫn sử dụng app",
  'search': "Tìm kiếm",
  'settings': "Cài đặt",
  'finance': "Tài chính sinh viên",
  'program': "Chương trình đào tạo",
  'result': "Kết quả học tập",
  'timetable': "Thời khoá biểu",
  'user': "Thông tin sinh viên",
};
List<String> funcOptionDictionary = ['go', 'add'];

abstract class Options {
  static void goto(BuildContext context, Widget target) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => target,
    ));
  }

  static Option add(void Function(BuildContext context) f) =>
      Option('add', const Icon(Symbols.add), f);

  static Option forward(void Function(BuildContext context) f) =>
      Option('go', const Icon(Symbols.arrow_forward), f);

  static Option notifications = Option(
    'notif',
    const Icon(Symbols.notifications),
    (BuildContext context) {},
  );

  static Option help = Option(
    'help',
    const Icon(Symbols.help_outline),
    (BuildContext context) {
      goto(context, const HelpMDViewerPage());
    },
  );

  static Option search = Option(
    'search',
    const Icon(Symbols.search),
    (BuildContext context) {},
  );

  static Option settings = Option(
    'settings',
    const Icon(Symbols.settings),
    (BuildContext context) {
      goto(context, const SettingsPage());
    },
  );

  static Option student_finance = Option(
    'finance',
    const Icon(Symbols.credit_card),
    (BuildContext context) {
      goto(context, const LearningFinance());
    },
  );

  static Option study_program = Option(
    'program',
    const Icon(Symbols.book),
    (BuildContext context) {},
  );

  static Option study_results = Option(
    'result',
    const Icon(Symbols.assignment),
    (BuildContext context) {},
  );

  static Option timetable = Option(
    'timetable',
    const Icon(Symbols.calendar_month),
    (BuildContext context) {
      goto(context, const LearningTimetablePage());
    },
  );

  static Option user = Option(
    'user',
    const Icon(Symbols.manage_accounts),
    (BuildContext context) {
      goto(context, const InfoStudentPage());
    },
  );
}

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/pages/learning/finance.dart';

abstract final class Options {

  static void _goto(BuildContext context, Widget target) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => target,
    ));
  }

  static Option add(String label, void Function(BuildContext) f) =>
      Option(Icons.add, label, f);

  static Option notifications = Option(
    Icons.notifications,
    "Thông báo",
    (BuildContext context) {},
  );

  static Option help = Option(
    Icons.help,
    "Hướng dẫn sử dụng app",
    (BuildContext context) {},
  );

  static Option search = Option(
    Icons.search,
    "Tìm kiếm",
    (BuildContext context) {},
  );

  static Option settings = Option(
    Icons.settings,
    "Cài đặt",
    (BuildContext context) {},
  );

  static Option student_finance = Option(
    Icons.credit_card,
    "Tài chính sinh viên",
    (BuildContext context) {
      _goto(context, const Finance());
    },
  );

  static Option study_program = Option(
    Icons.book,
    "Chương trình đào tạo",
    (BuildContext context) {},
  );

  static Option study_results = Option(
    Icons.assignment,
    "Kết quả học tập",
    (BuildContext context) {},
  );

  static Option timetable = Option(
    Icons.calendar_month,
    "Thời khoá biểu",
    (BuildContext context) {},
  );

  static Option user = Option(
    Icons.manage_accounts,
    "Thông tin sinh viên",
    (BuildContext context) {},
  );
}

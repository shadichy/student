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
      Option(const Icon(Icons.add), label, f);

  static Option forward(String label, void Function(BuildContext) f) =>
      Option(const Icon(Icons.arrow_forward), label, f);

  static Option notifications = Option(
    const Icon(Icons.notifications),
    "Thông báo",
    (BuildContext context) {},
  );

  static Option help = Option(
    const Icon(Icons.help),
    "Hướng dẫn sử dụng app",
    (BuildContext context) {},
  );

  static Option search = Option(
    const Icon(Icons.search),
    "Tìm kiếm",
    (BuildContext context) {},
  );

  static Option settings = Option(
    const Icon(Icons.settings),
    "Cài đặt",
    (BuildContext context) {},
  );

  static Option student_finance = Option(
    const Icon(Icons.credit_card),
    "Tài chính sinh viên",
    (BuildContext context) {
      _goto(context, const Finance());
    },
  );

  static Option study_program = Option(
    const Icon(Icons.book),
    "Chương trình đào tạo",
    (BuildContext context) {},
  );

  static Option study_results = Option(
    const Icon(Icons.assignment),
    "Kết quả học tập",
    (BuildContext context) {},
  );

  static Option timetable = Option(
    const Icon(Icons.calendar_month),
    "Thời khoá biểu",
    (BuildContext context) {},
  );

  static Option user = Option(
    const Icon(Icons.manage_accounts),
    "Thông tin sinh viên",
    (BuildContext context) {},
  );
}

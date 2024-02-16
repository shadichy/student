// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';

abstract final class Options {
  static Option add(String label, void Function() f) => Option(Icons.add, label, f);

  static Option notifications = Option(Icons.notifications, "Thông báo", () {});

  static Option help = Option(Icons.help, "Hướng dẫn sử dụng app", () {});

  static Option search = Option(Icons.search, "Tìm kiếm", () {});

  static Option settings = Option(Icons.settings, "Cài đặt", () {});

  static Option student_finance = Option(Icons.credit_card, "Tài chính sinh viên", () {});

  static Option study_program = Option(Icons.book, "Chương trình đào tạo", () {});

  static Option study_results = Option(Icons.assignment, "Kết quả học tập", () {});

  static Option timetable = Option(Icons.calendar_month, "Thời khoá biểu", () {});

  static Option user = Option(Icons.manage_accounts, "Thông tin sinh viên", () {});
}

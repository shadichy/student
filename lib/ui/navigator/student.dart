import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/navigator/quick_navigators.dart';
import 'package:student/ui/components/navigator/student/glance_widget.dart';
import 'package:student/ui/components/navigator/student/topbar_widget.dart';

import 'package:student/ui/components/with_appbar.dart';

class StudentPage extends StatelessWidget implements TypicalPage {
  StudentPage({super.key});

  late final bool hasData = [].isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    return WithAppbar(
      appBar: const StudentTopBar(),
      body: [
        StudentGlance(
          studentCode: "A47548",
          studentFullName: "Shadashi Ken Ichi",
          studentPicture: Image.network(
            "https://picsum.photos/250?image=9",
            fit: BoxFit.cover,
          ),
          studentSchool: 'Trường Đại học Thăng Long',
          studentMajor: 'Trí tuệ nhân tạo',
          studentClass: 'TA3601',
          studentGPA: '1.1',
          studentCred: 24,
        ),
        OptionLabelWidgets(title, headingLabel: "Settings"),
      ],
    );
  }

  @override
  Icon get icon => const Icon(Symbols.person);

  @override
  String get title => "Student";
}

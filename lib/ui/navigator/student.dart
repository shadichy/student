import 'package:flutter/material.dart';
import 'package:student/ui/components/navigator/quick_navigations.dart';
import 'package:student/ui/components/navigator/student/glance_widget.dart';
import 'package:student/ui/components/navigator/student/topbar_widget.dart';
import 'package:student/ui/components/options.dart';

class StudentPage extends StatelessWidget {
  StudentPage({super.key});
  late final bool hasData = [].isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // const StudentTopBar(),
          StudentGlance(
            userCode: "A47548",
            userFullName: "Shadashi Ken Ichi",
            userPicture: Image.network(
              "https://picsum.photos/250?image=9",
              fit: BoxFit.cover,
            ),
          ),
          OptionLabelWidgets([
            Options.user,
            Options.student_finance,
            Options.study_program,
            Options.study_results,
            Options.settings,
            Options.help,
          ], headingLabel: "Settings"),
        ],
      ),
    );
  }
}

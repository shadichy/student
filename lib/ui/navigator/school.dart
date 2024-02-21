import 'package:flutter/material.dart';
import 'package:student/ui/components/navigator/school/glance_widget.dart';
import 'package:student/ui/components/navigator/school/searchbar_widget.dart';
import 'package:student/ui/components/navigator/school/topbar_widget.dart';
import 'package:student/ui/components/navigator/school/updated_news.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/quick_navigations.dart';
import 'package:student/ui/components/section_label.dart';

class School extends StatelessWidget {
  const School({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SchoolTopBar(),
          const SchoolGlance(AssetImage("assets/images/thanglonguni.png")),
          const SchoolSearchBar(),
          const UpdatedNews([]),
          OptionLabelWidgets([
            Options.notifications,
            Options.study_program,
            Options.study_results,
            Options.user,
            Options.help,
          ]),
        ],
      ),
    );
  }
}

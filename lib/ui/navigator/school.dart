import 'package:flutter/material.dart';
import 'package:student/ui/components/navigator/school/glance_widget.dart';
import 'package:student/ui/components/navigator/school/searchbar_widget.dart';
import 'package:student/ui/components/navigator/school/topbar_widget.dart';
import 'package:student/ui/components/navigator/school/updated_news.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/navigator/quick_navigations.dart';

class SchoolPage extends StatelessWidget {
  const SchoolPage({super.key});

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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Visit ",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "https://thanglong.edu.vn",
                    style: TextStyle(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

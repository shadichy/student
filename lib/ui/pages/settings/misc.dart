import 'package:flutter/material.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class SettingsMiscPage extends StatefulWidget {
  const SettingsMiscPage({super.key});

  @override
  State<SettingsMiscPage> createState() => _SettingsMiscPageState();
}

class _SettingsMiscPageState extends State<SettingsMiscPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const HeadLabel("Miscellaneous"),
          // timetable label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Timetable",
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // start day of week [0-6]
          Opt(
            label: "Start week on",
            desc: "Sunday",
            buttonType: ButtonType.select,
            action: ((context) {
              showDialog<int>(
                context: context,
                builder: (context) {
                  return SimpleDialog();
                },
              ).then((value) => null);
            }),
          )
        ]),
      ),
    );
  }
}

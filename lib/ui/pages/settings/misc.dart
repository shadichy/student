import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class SettingsMiscPage extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.tune);

  @override
  String get title => "Misc";

  const SettingsMiscPage({super.key});

  @override
  State<SettingsMiscPage> createState() => _SettingsMiscPageState();
}

class _SettingsMiscPageState extends State<SettingsMiscPage> {
  final List<String> dayOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  int startWeekday = Storage().fetch<int>(Config.misc.startWeekday) ??
      defaultConfig["misc.startWeekday"];
  void setStartWeekday(int day) {
    setState(() {
      startWeekday = day;
    });
    Storage().put(Config.misc.startWeekday, day);
  }

  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return SettingsBase(
      label: "Miscellaneous",
      children: [
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
          desc: dayOfWeek[startWeekday],
          buttonType: ButtonType.select,
          action: ((context) {
            showDialog<int>(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(
                    "Select day of week",
                    style: textTheme.bodyMedium,
                  ),
                  children: List.generate(7, (d) {
                    return SimpleDialogOption(
                      child: Text(
                        dayOfWeek[d],
                      ),
                      onPressed: () => Navigator.of(context).pop(d),
                    );
                  }),
                );
              },
            ).then((day) {
              if (day != null) setStartWeekday(day);
            });
          }),
        )
      ],
    );
  }
}

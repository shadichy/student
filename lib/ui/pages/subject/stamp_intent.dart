import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class SubjectStampIntent extends StatefulWidget {
  final AlarmSettings alarm;
  const SubjectStampIntent(this.alarm, {super.key});

  @override
  State<SubjectStampIntent> createState() => _SubjectStampIntentState();
}

class _SubjectStampIntentState extends State<SubjectStampIntent> {
  late final AlarmSettings alarm;
  late final EventTimestamp stamp;
  final Map<String, String> data = {};

  @override
  void initState() {
    super.initState();
    alarm = widget.alarm;
    List<String> title = alarm.notificationTitle.split(' \u2022 ');
    try {
      // if is a school class
      Subject subject = Storage().getSubjectAlt(title[2])!;
      stamp = subject.courses[title[2]]!.timestamp.firstWhere(
        (e) =>
            e.dayOfWeek == DateTime.now().weekday % 7 && e.location == title[0],
      );
      data["Subject Name"] = subject.name;
      data["Course Name"] = title[2];
      if ((stamp as CourseTimestamp).timestampType == TimestampType.offline) {
        data["Room"] = title[0];
      } else {
        data["Location"] = "Elearning";
      }
      data["Instructor/Teacher"] =
          "(${stamp.heldBy}) ${Storage().getTeacher(stamp.heldBy!)}";
    } catch (e, s) {
      // if is a custom event
      stamp = Storage().thisWeek.timestamps.firstWhere((e) =>
          e.dayOfWeek == DateTime.now().weekday % 7 && e.location == title[0]);
      data["Event name"] = title[2];
      if (stamp.location != null) data["Location"] = stamp.location!;
      if (stamp.heldBy != null) data["Held by"] = stamp.heldBy!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // design a site that looks similar to [SubjectStampPage], but without `appBar`, [SubPage] must not have `target` parameter and there must be a big `Got it!` button at the bottom
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              MWds.divider(32),
              // Big alarm icon
              Icon(
                Symbols.alarm,
                size: 128,
                color: colorScheme.primary,
              ),
              // Big text using MiscFns.durationLeft
              Text(
                MiscFns.durationLeft(alarm.dateTime.difference(DateTime.now())),
                style: textTheme.headlineLarge!.copyWith(
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              MWds.divider(16),
              ...data.entries.map(
                (e) => SubPage(
                  label: e.key,
                  desc: e.value,
                ),
              ),
            ]),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 160,
              padding: const EdgeInsets.all(20),
              child: TextButton(
                onPressed: () => Alarm.stop(alarm.id).then((_) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                }),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: colorScheme.primaryContainer,
                ),
                child: Text(
                  "Got it!",
                  style: textTheme.headlineMedium!.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

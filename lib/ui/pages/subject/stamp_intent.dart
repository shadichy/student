import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/notification/alarm.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class SubjectStampIntent extends StatefulWidget {
  final int alarmId;
  const SubjectStampIntent(this.alarmId, {super.key});

  @override
  State<SubjectStampIntent> createState() => _SubjectStampIntentState();
}

class _SubjectStampIntentState extends State<SubjectStampIntent> {
  late final int alarmId;
  late final int intStamp;
  late final int dayOfWeek;
  late final int scheduleDuration;
  late final EventTimestamp stamp;
  final Map<String, String?> data = {};

  @override
  void initState() {
    super.initState();
    alarmId = widget.alarmId;
    intStamp = alarmId & EventTimestamp.maxStamp;
    dayOfWeek = (alarmId >> SPBasics().classTimestamps.length) & 7;
    scheduleDuration = alarmId >> (SPBasics().classTimestamps.length + 3);

    stamp = Storage().thisWeek.timestamps.firstWhere((e) {
      return e.dayOfWeek == dayOfWeek && e.intStamp == intStamp;
    });
    try {
      // if is a school class
      Subject subject = Storage().getSubjectAlt(stamp.eventName)!;
      data["Subject Name"] = subject.name;
      data["Course Name"] = stamp.eventName;
      if ((stamp as CourseTimestamp).timestampType == TimestampType.offline) {
        data["Room"] = stamp.location;
      } else {
        data["Location"] = "Elearning";
      }
      data["Instructor/Teacher"] =
          "(${stamp.heldBy}) ${Storage().getTeacher(stamp.heldBy!)}";
    } catch (e) {
      // if is a custom event
      data["Event name"] = stamp.eventName;
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
                MiscFns.durationLeft(Duration(minutes: scheduleDuration)),
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
                onPressed: () => Alarm.stop(alarmId).then((_) {
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

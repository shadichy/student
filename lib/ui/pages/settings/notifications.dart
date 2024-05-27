import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/notification/alarm.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/interpolator.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/pages/settings/reminder.dart';

import 'package:student/ui/components/navigator/navigator.dart';

class SettingsNotificationsPage extends StatefulWidget implements TypicalPage {
  @override
  Icon get icon => const Icon(Symbols.alarm);

  @override
  String get title => "Notifications & Reminders";

  const SettingsNotificationsPage({super.key});

  @override
  State<SettingsNotificationsPage> createState() =>
      _SettingsNotificationsPageState();
}

class _SettingsNotificationsPageState extends State<SettingsNotificationsPage> {
  List<Map<String, dynamic>> reminders = MiscFns.list<Map<String, dynamic>>(
    Storage().fetch<List>("notif.reminders")!,
  );

  void reminderConf(void Function() fn) {
    setState(fn);
    Storage().put("notif.reminders", reminders);
  }

  void reminderChange(int index, Map<String, dynamic> value) {
    reminderConf(() {
      reminders[index] = value;
    });
  }

  void reminderAdd(Map<String, dynamic> value) {
    reminderConf(() {
      reminders.add(value);
    });
  }

  void reminderDelete(int index) {
    reminderConf(() {
      reminders.removeAt(index);
    });
  }

  bool notifPriorExpand = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<MapEntry<String, String>> expansionNotifPrior = {
      "reminder": "Next up classes reminders",
      "topEvents": "Upcoming important events",
      "miscEvents": "Other events",
      "impNotif": "Important school notifications",
      "clubNotif": "Club notifications",
      "miscNotif": "Other notifications",
      "appNotif": "Updates",
    }.entries.toList();
    return SettingsBase(
      label: "Notifications & reminders",
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reminders",
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Symbols.alarm_add),
                padding: EdgeInsets.zero,
                iconSize: 28,
                color: colorScheme.primary,
                onPressed: () => showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 0, minute: 0),
                ).then((time) {
                  if (time == null) return;
                  reminderAdd({
                    "duration": Duration(
                      hours: time.hour,
                      minutes: time.minute,
                    ).inMinutes
                  });
                }),
              )
            ],
          ),
        ),
        // list of reminders

        if (reminders.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Press the add button on the top right to add new reminder",
              style: textTheme.bodySmall?.apply(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemBuilder: ((context, index) {
              Map<String, dynamic> data = reminders[index];
              return ReminderCard(
                Duration(
                  minutes: data["duration"] is int
                      ? data["duration"]
                      : int.tryParse("${data['duration']}") ?? 0,
                ),
                disabled: data["disabled"] is bool
                    ? data["disabled"]
                    : bool.tryParse("${data['disabled']}") ?? false,
                vibrate: data["vibrate"] is bool
                    ? data["vibrate"]
                    : bool.tryParse("${data['vibrate']}") ?? true,
                alarmMode: AlarmMode.values[data["alarmMode"] is int
                    ? data["alarmMode"]
                    : int.tryParse("${data['alarmMode']}") ?? 0],
                audio: data["audio"] as String?,
                action: ((actionType, value) {
                  switch (actionType) {
                    case ActionType.change:
                      reminderChange(index, value!);
                      break;
                    case ActionType.delete:
                      reminderDelete(index);
                      break;
                  }
                }),
              );
            }),
            separatorBuilder: ((context, index) => MWds.divider(8)),
            itemCount: reminders.length,
            // scrollDirection: Axis.vertical,
            shrinkWrap: true,
          ),
        // ReminderCard(Duration(minutes: 30), action: (actionType) {}),
        //reminder default sound
        Opt(
          label: "Reminder alarm sound",
          desc: "Default", // notif.reminderSound
          buttonType: ButtonType.select,
          action: (context) {},
        ),
        // gradually increase volume
        // silence after
        // snooze length
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
            top: 32,
            bottom: 8,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            "Notification",
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // notification sound
        Opt(
          label: "Notification sound",
          desc: "Default", // notif.notificationSound
          buttonType: ButtonType.select,
          action: (context) {},
        ),
        // notification prior
        ExpansionPanelList(
          materialGapSize: 0,
          elevation: 0,
          expansionCallback: (int index, bool isExpanded) {
            setState(() => notifPriorExpand = !notifPriorExpand);
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: notifPriorExpand,
              headerBuilder: (context, b) =>
                  const SubPage(label: "Notification priority"),
              body: SimpleListBuilder(
                builder: (index) {
                  String dataID = "notif.${expansionNotifPrior[index].key}";
                  return Opt(
                    label: expansionNotifPrior[index].value,
                    buttonType: ButtonType.switcher,
                    switcherDefaultValue: Storage().fetch<bool>(dataID) ?? true,
                    switcherAction: (value) => Storage().put(dataID, value),
                  );
                },
                itemCount: expansionNotifPrior.length,
              ),
            )
          ],
        )
      ],
    );
  }
}

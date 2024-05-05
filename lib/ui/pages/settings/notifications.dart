import 'package:flutter/material.dart';
import 'package:student/core/configs.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/option.dart';
import 'package:student/ui/components/options.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/pages/settings/reminder.dart';

class SettingsNotificationsPage extends StatefulWidget {
  const SettingsNotificationsPage({super.key});

  @override
  State<SettingsNotificationsPage> createState() =>
      _SettingsNotificationsPageState();
}

class _SettingsNotificationsPageState extends State<SettingsNotificationsPage> {
  List<Map<String, dynamic>> reminders = MiscFns.listType<Map<String, dynamic>>(
    AppConfig().getConfig<List>("notif.reminders"),
  );

  void reminderConf(void Function() fn) {
    setState(fn);
    AppConfig().setConfig("notif.reminders", reminders);
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const HeadLabel("Notifications"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Reminders",
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconOption(
                  Options.add(
                    "Add",
                    (context) => showTimePicker(
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
                  ),
                  padding: EdgeInsets.zero,
                  iconSize: 24,
                  iconColor: colorScheme.primary,
                )
              ],
            ),
          ),
          // list of reminders
          ListView.separated(
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
                alarm: data["alarm"] as String?,
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
            separatorBuilder: ((context, index) {
              return const Divider(
                color: Colors.transparent,
                height: 8,
              );
            }),
            itemCount: reminders.length,
            // scrollDirection: Axis.vertical,
            shrinkWrap: true,
          ),
          // ReminderCard(Duration(minutes: 30), action: (actionType) {}),
          //reminder default sound
          Opt(
            label: "Reminder alarm sound",
            desc: "Default",
            buttonType: ButtonType.select,
            action: (context) {},
          ),
          // gradually increase volume
          // silence after
          // snooze length
          Container(
            padding: const EdgeInsets.all(16).copyWith(top: 32),
            alignment: Alignment.centerLeft,
            child: Text(
              "Notification",
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          // notification sound
          Opt(
            label: "Notification sound",
            desc: "Default",
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
                body: ListView.builder(
                  itemBuilder: (context, index) {
                    String dataID = "notif.${expansionNotifPrior[index].key}";
                    return Opt(
                      label: expansionNotifPrior[index].value,
                      buttonType: ButtonType.switcher,
                      switcherDefaultValue:
                          AppConfig().getConfig<bool>(dataID) ?? true,
                      switcherAction: (value) =>
                          AppConfig().setConfig(dataID, value),
                    );
                  },
                  itemCount: expansionNotifPrior.length,
                  shrinkWrap: true,
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}

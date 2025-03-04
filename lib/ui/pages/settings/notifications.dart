import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/core/notification/reminder.dart';
import 'package:student/core/routing.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/interpolator.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/components/pages/settings/reminder.dart';

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
  List<Reminder> reminders = Storage().reminders.toList();

  void reminderConf(void Function() fn) {
    setState(fn);
    Storage().put(Config.notif.reminders, reminders);
  }

  void reminderChange(int index, Map<String, dynamic> value) {
    reminderConf(() {
      reminders[index]
          .editFromJson(value)
          .then((_) => Storage().reminderUpdate(reminders[index]));
    });
  }

  void reminderAdd(Reminder value) {
    Storage()
        .reminderAdd(value)
        .then((_) => reminderConf(() => reminders.add(value)));
  }

  void reminderDelete(int index) {
    Storage()
        .reminderRemove(reminders[index].scheduleDuration.inMinutes)
        .then((_) => reminderConf(() => reminders.removeAt(index)));
  }

  bool notifPriorExpand = false;

  @override
  void initState() {
    super.initState();
    reminders.sort((a, b) => a.scheduleDuration.compareTo(b.scheduleDuration));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<MapEntry<String, String>> expansionNotifPrior = {
      Config.notif.reminder: "Next up classes reminders",
      Config.notif.topEvents: "Upcoming important events",
      Config.notif.miscEvents: "Other events",
      Config.notif.impNotif: "Important school notifications",
      Config.notif.clubNotif: "Club notifications",
      Config.notif.miscNotif: "Other notifications",
      Config.notif.appNotif: "Updates",
    }.entries.toList();

    reminders.sort((a, b) => a.scheduleDuration.compareTo(b.scheduleDuration));
    List<Widget> reminderItems = List.generate(
      reminders.length > 2 ? 4 : reminders.length * 2,
      (index) {
        if ((index % 2 == 0)) {
          int i = index ~/ 2;
          return ReminderCard(
            reminders[i],
            action: ((actionType, value) {
              switch (actionType) {
                case ActionType.change:
                  reminderChange(i, value!);
                  break;
                case ActionType.delete:
                  reminderDelete(i);
                  break;
              }
            }),
          );
        } else {
          return MWds.divider();
        }
      },
      growable: true,
    );
    reminderItems.add((reminders.isEmpty)
        ? Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Press the add button on the top right to add new reminder",
              style: textTheme.bodySmall?.apply(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: InkWell(
              onTap: () => Routing.goto(context, Routing.reminders),
              child: Text(
                "Show more...",
                style: textTheme.bodyLarge?.apply(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ));
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
                  int scheduleDuration = time.hour * 60 + time.minute;
                  reminderAdd(Reminder(scheduleDuration));
                }),
              )
            ],
          ),
        ),

        // list of reminders
        ...reminderItems,

        // if (reminders.isEmpty)
        //   Padding(
        //     padding: const EdgeInsets.all(16),
        //     child: Text(
        //       "Press the add button on the top right to add new reminder",
        //       style: textTheme.bodySmall?.apply(
        //         color: colorScheme.onSurface.withOpacity(0.5),
        //       ),
        //     ),
        //   )
        // else
        //   ListView.separated(
        //     physics: const NeverScrollableScrollPhysics(),
        //     padding: const EdgeInsets.symmetric(vertical: 16),
        //     itemBuilder: ((context, index) {
        //       return ReminderCard(
        //         reminders[index],
        //         action: ((actionType, value) {
        //           switch (actionType) {
        //             case ActionType.change:
        //               reminderChange(index, value!);
        //               break;
        //             case ActionType.delete:
        //               reminderDelete(index);
        //               break;
        //           }
        //         }),
        //       );
        //     }),
        //     separatorBuilder: ((context, index) => MWds.divider(8)),
        //     itemCount: reminders.length > 2 ? 2 : reminders.length,
        //     // scrollDirection: Axis.vertical,
        //     shrinkWrap: true,
        //   ),
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
          expandedHeaderPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          elevation: 0,
          expansionCallback: (int index, bool isExpanded) {
            setState(() => notifPriorExpand = !notifPriorExpand);
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: notifPriorExpand,
              headerBuilder: (context, b) => const SubPage(
                label: "Notification priority",
              ),
              body: SimpleListBuilder(
                builder: (index) {
                  String dataID = expansionNotifPrior[index].key;
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

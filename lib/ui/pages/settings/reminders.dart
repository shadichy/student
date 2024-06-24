import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/core/notification/reminder.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/settings/reminder.dart';

class SettingsRemindersPage extends StatefulWidget implements TypicalPage {
  const SettingsRemindersPage({super.key});

  @override
  State<SettingsRemindersPage> createState() => _SettingsRemindersPageState();

  @override
  Icon get icon => const Icon(Symbols.reminder);

  @override
  String get title => "Reminders";
}

class _SettingsRemindersPageState extends State<SettingsRemindersPage> {
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

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    List<MapEntry<IconData, void Function()>> actions = ({
      Symbols.alarm_add: () => showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 0, minute: 0),
          ).then((time) {
            if (time == null) return;
            int scheduleDuration = time.hour * 60 + time.minute;
            reminderAdd(Reminder(scheduleDuration));
          }),
    }).entries.toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Symbols.arrow_back, size: 28),
        ),
        title: Text(
          widget.title,
          style: textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        actions: List.generate(actions.length, (i) {
          return [
            IconButton(
              onPressed: actions[i].value,
              icon: Icon(
                actions[i].key,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const VerticalDivider(
              width: 8,
              color: Colors.transparent,
            ),
          ];
        }).fold<List<Widget>>([], (p, n) => p + n),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: (reminders.isEmpty)
              ? <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Press the add button on the top right to add new reminder",
                      style: textTheme.bodySmall?.apply(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  )
                ]
              : List.generate(
                  reminders.length * 2,
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
                ),
        ),
      ),
    );
  }
}

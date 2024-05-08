import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/ui/components/option.dart';

enum AlarmMode { follow, silent, custom }

enum ActionType { change, delete }

double _iconSize = 24;

class ReminderCard extends StatefulWidget {
  final Duration duration;
  final void Function(ActionType actionType, Map<String, dynamic>? value)
      action;
  final bool disabled;
  final bool vibrate;
  final AlarmMode alarmMode;
  final String? alarm;
  const ReminderCard(
    this.duration, {
    super.key,
    required this.action,
    this.disabled = false,
    this.vibrate = true,
    this.alarmMode = AlarmMode.follow,
    this.alarm,
  }) : assert(alarmMode != AlarmMode.custom || alarm != null,
            'Missing custom alarm');

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  late Duration duration = widget.duration;
  late bool disabled = widget.disabled;
  late bool vibrate = widget.vibrate;
  late AlarmMode alarmMode = widget.alarmMode;
  late String? alarm = widget.alarm;

  Map<String, dynamic> get toObject {
    return {
      "duration": duration.inMinutes,
      "disabled": disabled,
      "vibrate": vibrate,
      "alarmMode": alarmMode.index,
      "alarm": alarm,
    };
  }

  void changeState(void Function() fn) {
    setState(fn);
    widget.action(ActionType.change, toObject);
  }

  void switcherChangeState(bool newState) {
    changeState(() {
      disabled = !newState;
    });
  }

  void changeDuration(Duration newDuration) {
    changeState(() {
      duration = newDuration;
    });
  }

  void vibrateChangeState(bool newState) {
    changeState(() {
      vibrate = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme.apply(
          displayColor: colorScheme.onPrimaryContainer,
          bodyColor: colorScheme.onPrimaryContainer,
        );

    List<TextSpan> boxText(String big, String small) {
      return [
        TextSpan(
          text: big,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: "$small ",
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
    }

    Widget durationText = InkWell(
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 0, minute: 0),
        ).then((time) {
          if (time == null) return;
          changeDuration(Duration(
            hours: time.hour,
            minutes: time.minute,
          ));
        });
      },
      child: Text.rich(
        TextSpan(children: [
          if (duration.inHours > 0) ...boxText("${duration.inHours}", "h"),
          ...boxText("${duration.inMinutes % 60}", "m"),
        ]),
      ),
    );

    return Card.filled(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              durationText,
              SizedBox(
                width: _iconSize + 8,
                height: _iconSize + 8,
                child: IconOption(
                  Option(
                    'delete',
                    const Icon(Symbols.delete),
                    (context) => widget.action(ActionType.delete, null),
                  ),
                  padding: EdgeInsets.zero,
                  iconSize: _iconSize,
                  iconColor: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(children: [
                SizedBox(
                  width: _iconSize + 8,
                  height: _iconSize + 8,
                  child: IconOption(
                    Option(
                      'vibrate',
                      const Icon(Symbols.vibration),
                      (context) => vibrateChangeState(!vibrate),
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: _iconSize,
                    iconColor: vibrate
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
                const VerticalDivider(
                  width: 4,
                  color: Colors.transparent,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {},
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2,
                    ),
                    padding: const EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width / 2,
                    height: _iconSize + 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Symbols.notifications_active,
                          size: _iconSize,
                          color: alarmMode != AlarmMode.silent
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface.withOpacity(0.1),
                        ),
                        const VerticalDivider(
                          width: 2,
                          color: Colors.transparent,
                        ),
                        Text(
                          ["Default", "Silent", alarm ?? ""][alarmMode.index],
                          style: textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  width: 32,
                  color: Colors.transparent,
                ),
              ]),
              Switch(value: !disabled, onChanged: switcherChangeState)
            ],
          )
        ]),
      ),
    );
  }
}

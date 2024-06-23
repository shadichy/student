import 'package:flutter/material.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/bottom_sheet.dart';
// import 'package:sheet/sheet.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/pages/settings/components.dart';
import 'package:student/ui/pages/subject/stamp.dart';

class UpcomingEventSheet extends StatefulWidget {
  final UpcomingEvent upcomingEvent;
  const UpcomingEventSheet(this.upcomingEvent, {super.key});

  @override
  State<UpcomingEventSheet> createState() => _UpcomingEventSheetState();
}

class _UpcomingEventSheetState extends State<UpcomingEventSheet> {
  late final UpcomingEvent eventData = widget.upcomingEvent;
  late final EventTimestamp stamp = eventData.event;

  Map<String, String?> data = {};
  late List<MapEntry<String, String>> rowFields;
  late Widget? target;

  bool dismissed = false;

  @override
  void initState() {
    super.initState();
    String locKey = "Location";
    if (eventData is NextupClassView) {
      data[stamp.eventName] = eventData.eventLabel;
      data["Start time"] = MiscFns.timeFormat(eventData.startTime);
      if ((stamp as CourseTimestamp).timestampType == TimestampType.offline) {
        locKey = "Room";
        data[locKey] = stamp.location;
      } else {
        data[locKey] = "Elearning";
      }
      data["Instructor/Teacher"] =
          "(${stamp.heldBy}) ${Storage().getTeacher(stamp.heldBy!)}";
      target = SubjectStampPage(stamp as CourseTimestamp);
    } else {
      data["Event name"] = stamp.eventName;
      data["Start time"] = MiscFns.timeFormat(eventData.startTime);
      if (stamp.location != null) data[locKey] = stamp.location!;
      if (stamp.heldBy != null) data["Held by"] = stamp.heldBy!;
      target = null;
    }
    rowFields = {
      "Start time": MiscFns.timeFormat(eventData.startTime),
      "End time": MiscFns.timeFormat(eventData.endTime),
      locKey: "${data[locKey]}",
    }.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    Widget rowBox(MapEntry<String, String> entry, bool dismissed) {
      Color boxColor;
      Color textColor;
      Color borderColor;
      TextDecoration? decoration;
      if (dismissed) {
        boxColor = Colors.transparent;
        textColor = colorScheme.onSurfaceVariant;
        borderColor = colorScheme.outline;
        decoration = TextDecoration.lineThrough;
      } else {
        boxColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        borderColor = Colors.transparent;
        decoration = null;
      }
      return Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: [
          Text(
            entry.value,
            style: textTheme.headlineLarge?.copyWith(
              color: textColor,
              decoration: decoration,
            ),
          ),
          Text(
            entry.key,
            style: textTheme.labelLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ]),
      );
    }

    return Column(children: [
      Text(
        eventData.eventLabel,
        style: textTheme.headlineMedium?.apply(color: colorScheme.onSurface),
      ),
      MWds.divider(4),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stamp.eventName,
            style: textTheme.labelLarge?.apply(color: colorScheme.onSurface),
          ),
          AnimatedCrossFade(
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeIn,
            sizeCurve: Curves.easeOut,
            firstChild: const SizedBox(),
            secondChild: Text(
              " - Dismissed",
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontStyle: FontStyle.italic,
              ),
            ),
            crossFadeState: dismissed
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
      MWds.divider(16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(rowFields.length * 2 - 1, (index) {
          if (index % 2 == 0) {
            int i = index ~/ 2;
            return AnimatedCrossFade(
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
              firstChild: rowBox(rowFields[i], dismissed),
              secondChild: rowBox(rowFields[i], dismissed),
              crossFadeState: dismissed
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
            );
          } else {
            return MWds.vDivider();
          }
        }),
      ),
      MWds.divider(16),
      Opt(
        label: "Dismiss",
        desc: "Do not show notifications for this class",
        buttonType: ButtonType.switcher,
        switcherDefaultValue: false,
        switcherAction: (b) => {
          setState(() {
            dismissed = b;
            (b)
                ? Storage().reminderUpdateForEvent(stamp)
                : Storage().reminderRemoveForEvent(stamp);
          })
        },
      ),
      SubPage(
        label: "More details",
        desc: "Show details about this class",
        target: target,
      ),
    ]);
  }
}

Future<T> showEventPreview<T>({
  required BuildContext context,
  required UpcomingEvent eventData,
}) async {
  return await showM3ModalBottomSheet(
    context: context,
    child: UpcomingEventSheet(eventData),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';
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
  late final UpcomingEvent event = widget.upcomingEvent;
  @override
  Widget build(BuildContext context) {
    // ColorScheme colorScheme = Theme.of(context).colorScheme;
    // return Sheet(
    //   resizable: true,
    //   initialExtent: 200,
    //   minExtent: 100,
    //   maxExtent: 400,
    //   child: Container(),
    // );
    return Container(
      padding: EdgeInsets.zero,
      child: SubPage(
        label: event.eventLabel,
        desc: "",
        target: (() {
          if (event is NextupClassView) {
            return SubjectStampPage((event as NextupClassView).stamp);
          }
        })(),
      ),
    );
  }
}

Future<T> showEventPreview<T>({
  required BuildContext context,
  required UpcomingEvent eventData,
}) async {
  Map<String, String?> data = {};
  EventTimestamp stamp = eventData.event;
  Widget? target;
  if (eventData is NextupClassView) {
    stamp as CourseTimestamp;
    data[stamp.eventName] = eventData.eventLabel;
    data["Start time"] = MiscFns.timeFormat(eventData.startTime);
    if (stamp.timestampType == TimestampType.offline) {
      data["Room"] = stamp.room;
    } else {
      data["Location"] = "Elearning";
    }
    data["Instructor/Teacher"] =
        "(${stamp.heldBy}) ${Storage().getTeacher(stamp.heldBy!)}";
    target = SubjectStampPage(stamp);
  } else {
    data["Event name"] = stamp.eventName;
    data["Start time"] = MiscFns.timeFormat(eventData.startTime);
    if (stamp.location != null) data["Location"] = stamp.location!;
    if (stamp.heldBy != null) data["Held by"] = stamp.heldBy!;
    target = null;
  }
  return await showM3ModalBottomSheet(
    context: context,
    child: Column(
      children: [
        ...data.entries.map(
          (e) => SubPage(
            label: e.key,
            desc: e.value,
          ),
        ),
        SubPage(
          label: "More details",
          target: target,
        )
      ],
    ),
  );
}

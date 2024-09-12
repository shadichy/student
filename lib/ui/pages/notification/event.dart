import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/navigator/navigator.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/pages/event_detail.dart';
import 'package:student/ui/components/pages/settings/components.dart';

class NotificationEventPage extends StatefulWidget implements TypicalPage {
  final EventTimestamp stamp;

  const NotificationEventPage(this.stamp, {super.key});

  @override
  State<NotificationEventPage> createState() => _NotificationEventPageState();

  @override
  Icon get icon => const Icon(Symbols.abc);

  @override
  String get title =>
      "${stamp.location} ${stamp.dayOfWeek} ${stamp.intStamp} ${stamp.eventName}";
}

class _NotificationEventPageState extends State<NotificationEventPage> {
  late final eventData = UpcomingEvent.fromTimestamp(widget.stamp);

  late final String dayOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ][widget.stamp.dayOfWeek];

  @override
  Widget build(BuildContext context) {
    return EventPage(
      label: "Thông tin sự kiện",
      title: widget.stamp.eventName,
      children: [
        SubPage(
          label: "Event details",
          desc: widget.stamp.eventName,
        ),
        SubPage(
          label: "Start time",
          desc: MiscFns.timeFormat(eventData.startTime),
        ),
        SubPage(
          label: "End time",
          desc: MiscFns.timeFormat(eventData.endTime),
        ),
        SubPage(
          label: "Week day",
          desc: dayOfWeek,
        ),
        if (widget.stamp.location != null)
          SubPage(
            label: "Location",
            desc: widget.stamp.location,
          ),
        if (widget.stamp.heldBy != null)
          SubPage(
            label: "Held by",
            desc: widget.stamp.heldBy,
          )
      ],
    );
  }
}

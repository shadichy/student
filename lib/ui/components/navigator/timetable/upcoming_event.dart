import 'dart:async';

import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/navigator/clickable_card.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/pages/event_preview.dart';

class TimetableUpcomingCardAlt extends StatefulWidget {
  final UpcomingEvent upcomingEvent;
  const TimetableUpcomingCardAlt(this.upcomingEvent, {super.key});

  @override
  State<TimetableUpcomingCardAlt> createState() =>
      _TimetableUpcomingCardAltState();
}

class _TimetableUpcomingCardAltState extends State<TimetableUpcomingCardAlt> {
  String _timeString = "";

  @override
  void initState() {
    _timeString = MiscFns.timeLeft(
      widget.upcomingEvent.startTime,
      widget.upcomingEvent.endTime,
    );
    Timer.periodic(const Duration(minutes: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    setState(() {
      _timeString = MiscFns.timeLeft(
        widget.upcomingEvent.startTime,
        widget.upcomingEvent.endTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme.apply(
          bodyColor: colorScheme.onPrimaryContainer,
          displayColor: colorScheme.onPrimary,
        );
    return ClickableCard(
      target: () {},
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onPrimaryContainer.withAlpha(160),
              // border: Border.all(
              //   width: 1,
              // ),
            ),
            alignment: Alignment.center,
            child: Text(
              "C",
              style: textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const VerticalDivider(
            color: Colors.transparent,
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.upcomingEvent.eventLabel,
                style: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(children: [
                if (widget.upcomingEvent.location is String)
                  Text(
                    "${widget.upcomingEvent.location} \u2022 ",
                    style: textTheme.titleMedium,
                  ),
                Text(
                  _timeString,
                  style: textTheme.titleMedium,
                ),
              ])
            ],
          ),
        ]),
      ),
    );
  }
}

class TimetableUpcomingCard extends StatefulWidget {
  final NextupClassView upcomingEvent;
  const TimetableUpcomingCard(this.upcomingEvent, {super.key});

  @override
  State<TimetableUpcomingCard> createState() => _TimetableUpcomingCardState();
}

class _TimetableUpcomingCardState extends State<TimetableUpcomingCard> {
  // static String timeLeft(DateTime startTime, DateTime endTime) {
  //   Duration diffEnd = endTime.difference(DateTime.now());
  //   if (diffEnd.inMinutes < 0) return "ended";
  //   Duration diffStart = startTime.difference(DateTime.now());
  //   String hour = "";
  //   if (diffStart.inHours > 0) hour += "${diffStart.inHours}h";
  //   if (diffStart.inMinutes < 0) return "now";
  //   return "$hour${diffStart.inMinutes}m";
  // }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Widget textTile(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              // margin: const EdgeInsets.all(0),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              "$label: ",
              // textAlign: TextAlign.start,
              // overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                // fontStyle: FontStyle.normal,
                fontSize: 15,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Expanded(
              child: Text(
                value,
                // textAlign: TextAlign.start,
                // overflow: TextOverflow.clip,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  // fontWeight: FontWeight.w600,
                  // fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Card.outlined(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.primaryContainer,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          showBottomSheet(
            context: context,
            builder: ((BuildContext context) {
              return UpcomingEventSheet(widget.upcomingEvent);
            }),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: ,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Text(
                widget.upcomingEvent.courseId,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 8, left: 16, bottom: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.upcomingEvent.classDesc,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  textTile(
                    Symbols.meeting_room,
                    "Room",
                    widget.upcomingEvent.room,
                  ),
                  textTile(
                    Symbols.alarm,
                    "Time",
                    "${MiscFns.timeFormat(widget.upcomingEvent.startTime)} - ${MiscFns.timeFormat(widget.upcomingEvent.endTime)}",
                  ),
                  textTile(
                    Symbols.event,
                    "Date",
                    MiscFns.timeFormat(widget.upcomingEvent.startTime),
                  ),
                  textTile(
                    Symbols.person,
                    "Teacher",
                    widget.upcomingEvent.teacher,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/misc/misc_widget.dart';
import 'package:student/ui/components/pages/event.dart';
import 'package:student/ui/components/pages/event_preview.dart';

enum CardState { ring, silent }

enum Priority { high, low }

enum BorderType { first, last, mid, full }

class HomeNextupClassCard extends StatefulWidget {
  final UpcomingEvent nextupClass;
  final CardState state;
  const HomeNextupClassCard(
    this.nextupClass, {
    super.key,
    this.state = CardState.ring,
  });

  @override
  State<HomeNextupClassCard> createState() => _HomeNextupClassCardState();
}

class _HomeNextupClassCardState extends State<HomeNextupClassCard>
    with SingleTickerProviderStateMixin {
  late bool state = widget.state == CardState.ring;
  String _timeString = "";
  late final EventTimestamp event;

  @override
  void initState() {
    event = widget.nextupClass.event;
    _getTime();
    Timer.periodic(const Duration(minutes: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _switchState(newState) {
    setState(() {
      state = newState;
    });
    if (newState) {
      Storage().reminderUpdateForEvent(event);
    } else {
      Storage().reminderRemoveForEvent(event);
    }
  }

  void _getTime() {
    if (!mounted) return;
    setState(() {
      _timeString = MiscFns.timeLeft(
        widget.nextupClass.startTime,
        widget.nextupClass.endTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme.apply(
      bodyColor: colorScheme.onPrimaryContainer,
    );
    // state = widget.state == CardState.ring;

    // Text textTile(
    //   String text, {
    //   @Deprecated("") double? fontSize,
    //   TextStyle? textStyle,
    //   FontWeight? fontWeight,
    //   TextOverflow? overflow,
    // }) {
    //   return Text(
    //     text,
    //     overflow: overflow,
    //     style: textStyle!.copyWith(
    //       fontWeight: fontWeight,
    //     ),
    //   );
    // }

    UpcomingEvent event = widget.nextupClass;
    return Card.outlined(
      elevation: 0,
      // color: colorScheme.primaryContainer,
      color: colorScheme.primaryContainer,
      // color: Colors.transparent,
      margin: const EdgeInsets.only(left: 16),
      shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.zero,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () async =>
            await showEventPreview(context: context, eventData: event),
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: MediaQuery.of(context).size.width * .612,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${widget.nextupClass.location} \u2022 ",
                        style: textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Symbols.alarm,
                        color: colorScheme.onPrimaryContainer,
                        size: 18,
                      ),
                      Text(
                        _timeString,
                        style: textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    event is NextupClassView
                        ? event.courseID
                        : event.eventLabel,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Text("${widget.nextupClass.classDesc} ${widget.nextupClass.classId.replaceFirst(RegExp(r"^[A-Z]+(\([A-Z]+\))?\."), '')}",
                  //   overflow: TextOverflow.ellipsis,
                  //   style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
                  // ),
                  Text(
                    event is NextupClassView
                        ? event.classDesc
                        : "${event.eventDesc}",
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Time: ${MiscFns.timeFormat(widget.nextupClass.startTime)} - ${MiscFns.timeFormat(widget.nextupClass.endTime)}",
                    style: textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // textTile(
                  //   "Teacher: ${widget.nextupClass.teacher}",
                  //   fontSize: 14,
                  // ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _switchState(!state),
              padding: const EdgeInsets.all(8),
              icon: Icon(
                  state ? Symbols.notifications_active : Symbols.notifications),
            )
          ],
        ),
      ),
    );
  }
}

class NextupEventCard extends StatefulWidget {
  final UpcomingEvent nextupClass;
  final CardState state;
  final Priority priority;
  final BorderType borderType;

  const NextupEventCard(
    this.nextupClass, {
    super.key,
    this.state = CardState.ring,
    this.priority = Priority.low,
    this.borderType = BorderType.mid,
  });

  @override
  State<NextupEventCard> createState() => _NextupEventCardState();
}

class _NextupEventCardState extends State<NextupEventCard>
    with SingleTickerProviderStateMixin {
  late bool state = widget.state == CardState.ring;
  String _timeString = "";
  late final UpcomingEvent eventData;
  late final EventTimestamp event;

  @override
  void initState() {
    eventData = widget.nextupClass;
    event = eventData.event;
    _getTime();
    Timer.periodic(const Duration(minutes: 1), (Timer t) {
      try {
        _getTime();
      } catch (e) {
        //
      }
    });
    super.initState();
  }

  void _switchState(newState) {
    setState(() {
      state = newState;
    });
    if (newState) {
      Storage().reminderUpdateForEvent(event);
    } else {
      Storage().reminderRemoveForEvent(event);
    }
  }

  void _getTime() {
    setState(() {
      _timeString = MiscFns.timeLeft(
        widget.nextupClass.startTime,
        widget.nextupClass.endTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme.apply(
      bodyColor: colorScheme.onPrimaryContainer,
      displayColor: colorScheme.onPrimaryContainer,
    );
    // state = widget.state == CardState.ring;

    // Text textTile(
    //   String text, {
    //   @Deprecated("") double? fontSize,
    //   TextStyle? textStyle,
    //   FontWeight? fontWeight,
    //   TextOverflow? overflow,
    // }) {
    //   return Text(
    //     text,
    //     overflow: overflow,
    //     style: textStyle!.copyWith(
    //       fontWeight: fontWeight,
    //     ),
    //   );
    // }

    UpcomingEvent event = widget.nextupClass;
    return Card.outlined(
      elevation: 0,
      // color: colorScheme.primaryContainer,
      color: widget.priority == Priority.high
          ? colorScheme.primaryContainer
          : colorScheme.surface,
      // color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.zero,
        side: widget.priority == Priority.high
            ? BorderSide.none
            : BorderSide(width: 1, color: colorScheme.outlineVariant),
        borderRadius: switch (widget.borderType) {
          BorderType.first => const BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(8.0),
            ),
          BorderType.mid => BorderRadius.circular(8.0),
          BorderType.last => const BorderRadius.vertical(
              bottom: Radius.circular(16),
              top: Radius.circular(8.0),
            ),
          BorderType.full => BorderRadius.circular(16),
        },
      ),
      child: InkWell(
        onTap: () async =>
            await showEventPreview(context: context, eventData: event),
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventLabel,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  MWds.divider(12),
                  Text(
                    "${event.location} - ${widget.priority == Priority.high ? event.eventDesc : "$_timeString from now"}",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.priority == Priority.high)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(children: [
                        Icon(
                          Symbols.calendar_month,
                          size: 32,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        MWds.vDivider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MiscFns.timeFormat(
                                eventData.startTime,
                                format: "HH:mm - E, d M",
                              ),
                              style: textTheme.titleMedium,
                            ),
                            Text(
                              "Starting in $_timeString",
                              style: textTheme.titleMedium,
                            )
                          ],
                        )
                      ]),
                    )
                ],
              ),
            ),
            IconButton(
              onPressed: () => _switchState(!state),
              padding: const EdgeInsets.all(8),
              icon: Icon(
                state ? Symbols.notifications_active : Symbols.notifications,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/pages/event.dart';

enum CardState { ring, silent }

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

class _HomeNextupClassCardState extends State<HomeNextupClassCard> {
  late bool state = widget.state == CardState.ring;
  String _timeString = "";

  @override
  void initState() {
    _timeString = MiscFns.timeLeft(
      widget.nextupClass.startTime,
      widget.nextupClass.endTime,
    );
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _switchState(newState) {
    setState(() {
      state = newState;
    });
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
        onTap: () {
          // showBottomSheet(
          //   context: context,
          //   builder: ((BuildContext context) {
          //     return UpcomingEventSheet(widget.nextupClass);
          //   }),
          // );
        },
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
                        ? event.courseId
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

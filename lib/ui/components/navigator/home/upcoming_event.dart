import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/pages/event.dart';

enum CardState { ring, silent }

class HomeNextupClassCard extends StatefulWidget {
  final NextupClassView nextupClass;
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

  void switchState(newState) {
    setState(() {
      state = newState;
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
                        "${widget.nextupClass.room} \u2022 ",
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
                        MiscFns.timeLeft(
                          widget.nextupClass.startTime,
                          widget.nextupClass.endTime,
                        ),
                        style: textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.nextupClass.courseId,
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
                    widget.nextupClass.classDesc,
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
              onPressed: () => switchState(!state),
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

import 'package:flutter/material.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/components/navigator/upcoming_event_preview.dart';
import 'package:student/ui/components/navigator/upcoming_event.dart';

class HomeNextupClassCard extends StatefulWidget {
  final NextupClassView nextupClass;
  const HomeNextupClassCard(this.nextupClass, {super.key});

  @override
  State<HomeNextupClassCard> createState() => _HomeNextupClassCardState();
}

class _HomeNextupClassCardState extends State<HomeNextupClassCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme.apply(
      bodyColor: colorScheme.onPrimaryContainer,
    );
    Text textTile(
      String text, {
      double? fontSize,
      FontWeight? fontWeight,
      TextOverflow? overflow,
    }) {
      return Text(
        text,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize,
          color: colorScheme.onPrimaryContainer,
          fontWeight: fontWeight,
        ),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Card.outlined(
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
            showBottomSheet(
              context: context,
              builder: ((BuildContext context) {
                return NextupClassSheet(widget.nextupClass);
              }),
            );
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    textTile(
                      "${widget.nextupClass.room} \u2022 ",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.alarm_outlined,
                      color: colorScheme.onPrimaryContainer,
                      size: 18,
                    ),
                    textTile(
                      MiscFns.timeLeft(
                        widget.nextupClass.startTime,
                        widget.nextupClass.endTime,
                      ),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                textTile(
                  widget.nextupClass.classId,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                // Text("${widget.nextupClass.classDesc} ${widget.nextupClass.classId.replaceFirst(RegExp(r"^[A-Z]+(\([A-Z]+\))?\."), '')}",
                //   overflow: TextOverflow.ellipsis,
                //   style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
                // ),
                textTile(
                  widget.nextupClass.classDesc,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                textTile(
                  "Time: ${MiscFns.timeFormat(widget.nextupClass.startTime)} - ${MiscFns.timeFormat(widget.nextupClass.endTime)}",
                  fontSize: 14,
                ),
                // textTile(
                //   "Teacher: ${widget.nextupClass.teacher}",
                //   fontSize: 14,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

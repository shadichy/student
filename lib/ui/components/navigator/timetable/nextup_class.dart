import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student/ui/components/navigator/nextup_class.dart';
import 'package:student/ui/components/navigator/nextup_class_preview.dart';

class TimetableNextupClassCard extends StatefulWidget {
  final NextupClassView nextupClass;
  const TimetableNextupClassCard(this.nextupClass, {super.key});

  @override
  State<TimetableNextupClassCard> createState() =>
      _TimetableNextupClassCardState();
}

class _TimetableNextupClassCardState extends State<TimetableNextupClassCard> {
  String timeLeft(DateTime startTime, DateTime endTime) {
    Duration diffEnd = endTime.difference(DateTime.now());
    if (diffEnd.inMinutes < 0) return "ended";
    Duration diffStart = startTime.difference(DateTime.now());
    String hour = "";
    if (diffStart.inHours > 0) hour += "${diffStart.inHours}h";
    if (diffStart.inMinutes < 0) return "now";
    return "$hour${diffStart.inMinutes}m";
  }

  String hmFormat(DateTime time) => DateFormat("HH:mm").format(time);

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
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              return NextupClassSheet(widget.nextupClass);
            }),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: ,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Text(
                widget.nextupClass.classId,
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
                    widget.nextupClass.classDesc,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  textTile(
                    Icons.meeting_room,
                    "Room",
                    widget.nextupClass.room,
                  ),
                  textTile(
                    Icons.alarm,
                    "Time",
                    "${hmFormat(widget.nextupClass.startTime)} - ${hmFormat(widget.nextupClass.endTime)}",
                  ),
                  textTile(
                    Icons.event,
                    "Date",
                    DateFormat("EEEE, dd/MM/yyyy")
                        .format(widget.nextupClass.startTime),
                  ),
                  textTile(
                    Icons.person,
                    "Teacher",
                    widget.nextupClass.teacher,
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

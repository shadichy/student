import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableNextupClassCard extends StatefulWidget {
  final String classId;
  final String classDesc;
  final String teacher;
  final DateTime startTime;
  final DateTime endTime;
  final String room;
  const TimetableNextupClassCard({
    super.key,
    required this.classId,
    required this.classDesc,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

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
                color: colorScheme.tertiaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: colorScheme.onTertiaryContainer,
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
                color: colorScheme.onTertiaryContainer,
              ),
            ),
            Expanded(
              child: Text(
                value,
                // textAlign: TextAlign.start,
                // overflow: TextOverflow.clip,
                style: TextStyle(
                  // fontWeight: FontWeight.w600,
                  // fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: colorScheme.onTertiaryContainer,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.background,
          shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.zero,
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: colorScheme.tertiaryContainer,
                width: 1,
              )),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: ,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Text(
                widget.classId,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  color: colorScheme.onTertiaryContainer,
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
                    widget.classDesc,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                  textTile(
                    Icons.meeting_room,
                    "Room",
                    widget.room,
                  ),
                  textTile(
                    Icons.alarm,
                    "Time",
                    "${hmFormat(widget.startTime)} - ${hmFormat(widget.endTime)}",
                  ),
                  textTile(
                    Icons.event,
                    "Date",
                    DateFormat("EEEE, dd/MM/yyyy").format(widget.startTime),
                  ),
                  textTile(
                    Icons.person,
                    "Teacher",
                    widget.teacher,
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

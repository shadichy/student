import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeNextupClassCard extends StatefulWidget {
  final String classId;
  final String classDesc;
  final String teacher;
  final DateTime startTime;
  final DateTime endTime;
  final String room;
  const HomeNextupClassCard({
    super.key,
    required this.classId,
    required this.classDesc,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  @override
  State<HomeNextupClassCard> createState() => _HomeNextupClassCardState();
}

class _HomeNextupClassCardState extends State<HomeNextupClassCard> {
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
    Text textTile(
      String text, {
      double? fontSize,
      FontWeight? fontWeight,
      TextOverflow? overflow,
    }) =>
        Text(
          text,
          overflow: overflow,
          style: TextStyle(
            fontSize: fontSize,
            color: colorScheme.onBackground,
            fontWeight: fontWeight,
          ),
        );
    return SizedBox(
      width: 280,
      child: Card.filled(
        elevation: 0,
        // color: colorScheme.primaryContainer,
        color: Colors.transparent,
        margin: const EdgeInsets.only(left: 16),
        shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.zero,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            backgroundColor: colorScheme.primary.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.zero,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  textTile(
                    "${widget.room} - ",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  Icon(
                    Icons.alarm,
                    color: colorScheme.onBackground,
                    size: 18,
                  ),
                  textTile(
                    timeLeft(widget.startTime, widget.endTime),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              textTile(
                widget.classId,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
              textTile(
                widget.classDesc,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textTile(
                "Time: ${hmFormat(widget.startTime)} - ${hmFormat(widget.endTime)}",
                fontSize: 14,
              ),
              textTile(
                "Teacher: ${widget.teacher}",
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

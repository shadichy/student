import 'package:flutter/material.dart';
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

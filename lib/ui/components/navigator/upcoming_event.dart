// import 'package:flutter/material.dart';
import 'package:student/core/semester/functions.dart';

// class NextupClass {
//   late final ClassTimeStamp stamp;
//   late final String room;
//   NextupClass(this.stamp) {
//     room = stamp.room;
//   }

// }

// class NextupClass extends StatefulWidget {
//   const NextupClass({ super.key });

//   @override
//   State<NextupClass> createState() => _NextupClassState();
// }

// class _NextupClassState extends State<NextupClass> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: const Color(0xFFFFE306));
//   }
// }
class UpcomingEvent {
  final String eventLabel;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String? heldBy;

  UpcomingEvent({
    required this.eventLabel,
    required this.startTime,
    required this.endTime,
    this.location,
    this.heldBy,
  });
}

class NextupClassView extends UpcomingEvent {
  final String classId;
  final String classDesc;
  final String teacher;
  final String room;
  // more info required, including ca, teacher id, subject id, kì học, tuần thứ n

  NextupClassView({
    required this.classId,
    required this.classDesc,
    required this.teacher,
    required super.startTime,
    required super.endTime,
    required this.room,
  }) : super(
          eventLabel: classDesc,
          location: room,
          heldBy: teacher,
        );

  NextupClassView.fromStamp(CourseTimeStamp stamp)
      : this(
          classId: stamp.courseID,
          classDesc: "",
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          room: stamp.room,
          teacher: '',
        );
}

  //  {
  //   startStamp = 0;
  //   if (onlineClass.contains(room)) {
  //     endStamp = 0;
  //     // startStampUnix = 0;
  //     // endStampUnix = 0;
  //     // day = "";
  //     return;
  //   }
  //   endStamp = 13;
  //   int tmpDint = intMatrix;
  //   while (tmpDint != 0) {
  //     if ((intMatrix & 1) == 0) {
  //       endStamp--;
  //     } else {
  //       startStamp++;
  //     }
  //     tmpDint >>= 1;
  //  }
  // startStampUnix = classTimeStamps[startStamp][0];
  // endStampUnix = classTimeStamps[endStamp][1];
  // day = dates[dayOfWeek];
  // }
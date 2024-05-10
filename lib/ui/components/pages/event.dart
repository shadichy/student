// import 'package:flutter/material.dart';
import 'package:student/core/databases/subjects.dart';
import 'package:student/core/databases/teachers.dart';
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
  final String? eventDesc;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String? heldBy;

  UpcomingEvent({
    required this.eventLabel,
    this.eventDesc,
    required this.startTime,
    required this.endTime,
    this.location,
    this.heldBy,
  });
}

class NextupClassView extends UpcomingEvent {
  final CourseTimestamp stamp;
  final String courseId;

  String get classDesc => eventLabel;
  String get teacher => heldBy!;
  String get room => location!;
  // more info required, including ca, teacher id, subject id, kì học, tuần thứ n

  // should be init'd like
  NextupClassView(this.stamp)
      : courseId = stamp.courseID,
        super(
          eventLabel: Subjects().getSubjectAlt(stamp.courseID)!.name,
          location: stamp.room,
          heldBy: Teachers().getTeacher(stamp.teacherID)!,
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        );

  NextupClassView.manual({
    required this.courseId,
    required String classDesc,
    required String teacher,
    required super.startTime,
    required super.endTime,
    required String room,
  })  : stamp = CourseTimestamp(
          intStamp: 0,
          dayOfWeek: 0,
          courseID: courseId,
          teacherID: teacher,
          room: room,
          timestampType: TimeStampType.offline,
        ),
        super(
          eventLabel: classDesc,
          location: room,
          heldBy: teacher,
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
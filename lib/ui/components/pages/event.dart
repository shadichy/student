// import 'package:flutter/material.dart';
import 'package:bitcount/bitcount.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/semester/functions.dart';

// class NextupClass {
//   late final ClassTimestamp stamp;
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

  static final DateTime _now = DateTime.now();
  static final DateTime _today = DateTime(_now.year, _now.month, _now.day);

  static int _getStartStamp(int timestamp) {
    if (timestamp == 0) return -1;
    int classStartsAt = 0;
    while (timestamp & (1 << classStartsAt) == 0) {
      classStartsAt++;
    }
    return classStartsAt;
  }

  static DateTime _getStart(int timestamp) {
    return _today.add(
      Duration(
        seconds: SPBasics().classTimestamps[_getStartStamp(timestamp)][0],
      ),
    );
  }

  static DateTime _getEnd(int timestamp) {
    return _today.add(
      Duration(
        seconds: SPBasics().classTimestamps[
            _getStartStamp(timestamp) + timestamp.bitCount() - 1][1],
      ),
    );
  }

  UpcomingEvent.fromTimestamp(EventTimestamp event)
      : this(
          eventLabel: event.eventName,
          eventDesc: "",
          startTime: _getStart(event.intStamp),
          endTime: _getEnd(event.intStamp),
          location: event.location,
          heldBy: event.heldBy,
        );
}

class NextupClassView extends UpcomingEvent {
  final CourseTimestamp stamp;
  final String courseID;

  String get classDesc => eventLabel;
  String get teacher => heldBy!;
  String get room => location!;
  // more info required, including ca, teacher id, subject id, kì học, tuần thứ n

  // should be init'd like
  NextupClassView(this.stamp, [String? subjectName])
      : courseID = stamp.courseID,
        super(
          eventLabel: subjectName ??
              Storage().getSubjectBaseAlt(stamp.courseID)?.name ??
              Storage().getSubjectAlt(stamp.courseID)?.name ??
              "Unknown",
          location: stamp.room,
          heldBy: Storage().getTeacher(stamp.teacherID) ?? "Unknown",
          startTime: UpcomingEvent._getStart(stamp.intStamp),
          endTime: UpcomingEvent._getEnd(stamp.intStamp),
        );

  NextupClassView.manual({
    required this.courseID,
    required String classDesc,
    required String teacher,
    required super.startTime,
    required super.endTime,
    required String room,
  })  : stamp = CourseTimestamp(
          intStamp: 0,
          dayOfWeek: 0,
          courseID: courseID,
          teacherID: teacher,
          room: room,
          timestampType: TimestampType.offline,
        ),
        super(
          eventLabel: classDesc,
          location: room,
          heldBy: teacher,
        );
}

  //  {
  //   startStamp = 0;
  //   if (SPBasics().onlineClass.contains(room)) {
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
  // startStampUnix = SPBasics().classTimestamps[startStamp][0];
  // endStampUnix = SPBasics().classTimestamps[endStamp][1];
  // day = dates[dayOfWeek];
  // }

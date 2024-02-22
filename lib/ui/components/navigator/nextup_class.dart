// import 'package:flutter/material.dart';
// import 'package:student/core/functions.dart';

// class NextupClass {
//   final ClassTimeStamp stamp;
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

class NextupClassView {
  final String classId;
  final String classDesc;
  final String teacher;
  final DateTime startTime;
  final DateTime endTime;
  final String room;
  // more info required, including ca, teacher id, subject id, kì học, tuần thứ n

  NextupClassView({
    required this.classId,
    required this.classDesc,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    required this.room,
  });
}
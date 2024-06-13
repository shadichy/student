import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:student/core/databases/shared_prefs.dart.disabled';
import 'package:student/core/semester/functions.dart';
part 'semester_timetable.g.dart';

@HiveType(typeId: 9)
class WeekTimetable extends HiveObject {
  @HiveField(0)
  final DateTime startDate; // must be start of week
  List<EventTimestamp> _timestamps;
  @HiveField(1)
  List<EventTimestamp> get timestamps => _timestamps;
  @HiveField(2)
  final int? weekNo;
  WeekTimetable(List<EventTimestamp> timestamps,
      {required this.startDate, this.weekNo})
      : _timestamps = timestamps;

  Future<void> addStamps(Iterable<EventTimestamp> timestamp) async {
    _timestamps.addAll(timestamp);
    await save();
  }

  Future<void> setStamps(List<EventTimestamp> timestamp) async {
    _timestamps = timestamp;
    await save();
  }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() => {
        'startDate': (startDate.millisecondsSinceEpoch / 1000).floor(),
        'timestamps': _timestamps,
        'weekNo': weekNo,
      };

  @override
  String toString() => jsonEncode(toMap());
}

// @Deprecated("moving to Hive")
// final class SemesterTimetable {
//   SemesterTimetable._instance();
//   static final _semesterTimetableInstance = SemesterTimetable._instance();
//   factory SemesterTimetable() {
//     return _semesterTimetableInstance;
//   }

//   late List<WeekTimetable> _timetable;
//   final UserSemester _currentSemester = User().semester;
//   late final DateTime _startDate;

//   List<WeekTimetable> get timetable => _timetable;
//   UserSemester get currentSemester => _currentSemester;
//   DateTime get startDate => _startDate;

//   SemesterPlan currentPlan = StudyPlan().table.elementAt(User().semester.index);

//   WeekTimetable getWeek(DateTime startDate) {
//     int daysDiff = startDate.difference(_startDate).inDays.abs();
//     int week = (daysDiff / 7).floor();
//     int startDay = daysDiff % 7;
//     List<EventTimestamp> timestamps = [];
//     if (week < _timetable.length) {
//       timestamps.addAll(startDay == 0
//           ? _timetable[week]._timestamps
//           : [
//               ..._timetable[week]
//                   ._timestamps
//                   .where((t) => t.dayOfWeek >= startDay),
//               if (week + 1 < _timetable.length)
//                 ..._timetable[week + 1]
//                     ._timestamps
//                     .where((t) => t.dayOfWeek < startDay)
//             ]);
//     }
//     if (currentPlan.studyWeeks.contains(week)) {
//       week = currentPlan.studyWeeks.indexOf(week);
//     } else {
//       week = -1;
//     }
//     return WeekTimetable(
//       timestamps,
//       startDate: startDate,
//       weekNo: startDay == 0 ? week : (week + 1),
//     );
//   }

//   void _modify(
//       List<EventTimestamp> timestamp,
//       List<DateTime> days,
//       void Function(
//         WeekTimetable currentWeek,
//         Iterable<EventTimestamp> targetEvents,
//       ) modifier) {
//     for (DateTime day in days) {
//       int daysDiff = day.difference(_startDate).inDays;
//       int week = (daysDiff / 7).floor();
//       int doW = daysDiff % 7;
//       while (_timetable.length < week + 1) {
//         _timetable.add(
//           WeekTimetable([], startDate: startDate.add(Duration(days: 7 * week))),
//         );
//       }
//       Iterable<EventTimestamp> matchEvents =
//           timestamp.where((t) => t.dayOfWeek == doW);
//       WeekTimetable targetWeek = _timetable[week];
//       modifier(targetWeek, matchEvents);
//       // _timetable[week] = WeekTimetable(
//       //   startDate: targetWeek.startDate,
//       // );
//     }
//   }

//   void _overwrite(List<EventTimestamp> timestamp, List<DateTime> days) {
//     _modify(
//       timestamp,
//       days,
//       (c, t) => c.setStamps([
//         ...c._timestamps.where((i) {
//           for (EventTimestamp event in t) {
//             if (event.intStamp | i.intStamp != 0) return false;
//           }
//           return true;
//         }),
//         ...t,
//       ]),
//     );
//   }

//   void _addByDays(List<EventTimestamp> timestamp, List<DateTime> days) {
//     _modify(timestamp, days, (c, t) => c.addStamps(t));
//   }

//   void _addAll(List<EventTimestamp> timestamp) {
//     void add(WeekTimetable w) => w.addStamps(timestamp);
//     _timetable.forEach(add);
//   }

//   Future<void> update(EventTimeline event,
//       {bool override = false, List<DateTime>? days}) async {
//     if (event is CourseTimestamp) {
//       assert(!override || days != null,
//           '"days" must be specified for Course update');
//       if (override) {
//         _overwrite(event.timestamp, days!);
//       } else {
//         if (days != null) {
//           _addByDays(event.timestamp, days);
//         } else {
//           _addAll(event.timestamp);
//         }
//       }
//       // else add for everyday
//     } else if (event is SchoolEvent) {
//       days ??= event.days;
//       (override ? _overwrite : _addByDays)(event.timestamp, days);
//     } else {
//       return;
//     }
//     await _write();
//   }

//   Future<void> _write() async {
//     await SharedPrefs.setString("userTimetable", _timetable);
//   }

//   Future<void> initialize() async {
//     List? rawInfo = SharedPrefs.getString("userTimetable");

//     _startDate = currentPlan.startDate;

//     if (rawInfo is List) {
//       Iterable<Map<String, dynamic>> parsedInfo =
//           MiscFns.list<Map<String, dynamic>>(rawInfo);
//       _timetable = parsedInfo.map((w) {
//         return WeekTimetable(
//           MiscFns.list<Map<String, dynamic>>(
//             w["timestamps"] as List,
//           ).map((s) {
//             return s["courseID"] != null
//                 ? CourseTimestamp.fromJson(s)
//                 : EventTimestamp.fromJson(s);
//           }).toList(),
//           startDate: MiscFns.epoch(w["startDate"] as int),
//           weekNo: w["weekNo"] as int?,
//         );
//       }).toList();
//       return;
//     }

//     List<SubjectCourse> registeredCourses = [];
//     for (var id
//         in User().learningCourses[SPBasics().currentYear - User().schoolYear]
//             [User().semester]!) {
//       try {
//         registeredCourses.add(InStudyCourses().getCourse(id)!);
//       } catch (e) {
//         // invalid course
//       }
//     }

//     _timetable = currentPlan.timetable
//         .toList()
//         .asMap()
//         .map<int, WeekTimetable>((w, p) {
//           List<CourseTimestamp> stamps = [];
//           for (SubjectCourse course in registeredCourses) {
//             for (CourseTimestamp stamp in course.timestamp) {
//               DayType d = p.elementAt(stamp.dayOfWeek);
//               if (d != DayType.H && d != DayType.B) continue;
//               stamps.add(stamp);
//             }
//           }
//           return MapEntry(
//             w,
//             WeekTimetable(
//               stamps,
//               startDate: _startDate.add(Duration(days: 7 * w)),
//               weekNo: currentPlan.studyWeeks.indexOf(w),
//             ),
//           );
//         })
//         .values
//         .toList();
//     await _write();
//   }
// }

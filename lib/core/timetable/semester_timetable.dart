import 'dart:convert';

import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/study_plan.dart';
import 'package:student/core/databases/subject_courses.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';

class WeekTimetable {
  final DateTime startDate; // must be start of week
  final List<EventTimestamp> timestamps;
  final int? weekNo;
  WeekTimetable(this.timestamps, {required this.startDate, this.weekNo});

  @override
  String toString() => ({
        'startDate': (startDate.millisecondsSinceEpoch / 1000).floor(),
        'timestamps': timestamps,
        'weekNo': weekNo,
      }).toString();
}

final class SemesterTimetable {
  SemesterTimetable._instance();
  static final _semesterTimetableInstance = SemesterTimetable._instance();
  factory SemesterTimetable() {
    return _semesterTimetableInstance;
  }

  late List<WeekTimetable> _timetable;
  final TLUSemester _currentSemester = User().semester;
  late final DateTime _startDate;

  List<WeekTimetable> get timetable => _timetable;
  TLUSemester get currentSemester => _currentSemester;
  DateTime get startDate => _startDate;

  WeekTimetable getWeek(DateTime startDate) {
    int daysDiff = startDate.difference(_startDate).inDays;
    int week = (daysDiff / 7).floor();
    int startDay = daysDiff % 7;
    List<EventTimestamp> timestamps = [];
    if (week < _timetable.length) {
      timestamps.addAll(startDay == 0
          ? _timetable[week].timestamps
          : [
              ..._timetable[week]
                  .timestamps
                  .where((_) => _.dayOfWeek >= startDay),
              if (week + 1 < _timetable.length)
                ..._timetable[week + 1]
                    .timestamps
                    .where((_) => _.dayOfWeek < startDay)
            ]);
    }
    return WeekTimetable(
      timestamps,
      startDate: startDate,
      weekNo: startDay == 0 ? week : (week + 1),
    );
  }

  Future<void> update(dynamic info) async {
    await _write();
  }

  Future<void> _write() async {
    String rawInfo = json.encode(_timetable);
    await SharedPrefs.setString("userTimetable", rawInfo);
  }

  Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("userTimetable");
    SemesterPlan currentPlan =
        StudyPlan().table.toList()[_currentSemester.index];
    _startDate = currentPlan.startDate;
    if (rawInfo is String) {
      Iterable<Map<String, dynamic>> parsedInfo = jsonDecode(rawInfo);
      _timetable = parsedInfo.map((w) {
        return WeekTimetable(
          MiscFns.listType<Map<String, dynamic>>(
            w["timetable"] as List,
          ).map((s) {
            return s["courseID"] != null
                ? CourseTimestamp(
                    intStamp: s["intStamp"] as int,
                    dayOfWeek: s["dayOfWeek"] as int,
                    courseID: s["courseID"] as String,
                    teacherID: s["teacherID"] as String,
                    room: s["room"] as String,
                    timestampType:
                        TimeStampType.values[s["timestampType"] as int],
                    courseType: s["courseType"] == null
                        ? null
                        : CourseType.values[s["courseType"] as int])
                : EventTimestamp(
                    eventName: s["eventName"] as String,
                    intStamp: s["intStamp"] as int,
                    dayOfWeek: s["dayOfWeek"] as int,
                    location: s["location"],
                    heldBy: s["heldBy"],
                  );
          }).toList(),
          startDate: MiscFns.epoch(w["startDate"] as int),
          weekNo: w["weekNo"] as int?,
        );
      }).toList();
      return;
    }

    Iterable<SubjectCourse> registeredCourses =
        User().learningCourseIDs.map((id) => InStudyCourses().getCourse(id)!);

    _timetable = currentPlan.timetable
        .asMap()
        .map<int, WeekTimetable>((w, p) {
          List<CourseTimestamp> stamps = [];
          for (SubjectCourse course in registeredCourses) {
            for (CourseTimestamp stamp in course.timestamp) {
              if (p[stamp.dayOfWeek] != DayType.H) continue;
              stamps.add(stamp);
            }
          }
          return MapEntry(
            w,
            WeekTimetable(
              stamps,
              startDate: _startDate.add(Duration(days: 7 * w)),
              weekNo: currentPlan.studyWeeks.indexOf(w),
            ),
          );
        })
        .values
        .toList();
    await _write();
  }
}

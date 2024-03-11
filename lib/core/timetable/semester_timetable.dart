import 'dart:convert';

import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/study_plan.dart';
import 'package:student/core/databases/subject_courses.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/semester/functions.dart';

class WeekTimetable {
  final DateTime startDate; // must be start of week
  final List<CourseTimeStamp> timestamps;
  final int? weekNo;
  WeekTimetable(this.timestamps, {required this.startDate, this.weekNo});
}

final class SemesterTimetable {
  static late List<WeekTimetable> timetable;
  static final TLUSemester currentSemester = User.semester;
  static late final DateTime startDate;

  static DateTime epoch(int s) => DateTime.fromMillisecondsSinceEpoch(s * 1000);

  static Future<void> update(dynamic info) async {
    await _write();
  }

  static Future<void> _write() async {
    String rawInfo = json.encode(timetable);
    await SharedPrefs.setString("userTimetable", rawInfo);
  }

  static Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("userTimetable");
    SemesterPlan currentPlan = StudyPlan.table[currentSemester.index];
    startDate = currentPlan.startDate;
    if (rawInfo is String) {
      List<Map<String, dynamic>> parsedInfo = jsonDecode(rawInfo);
      timetable = parsedInfo.map((w) {
        return WeekTimetable(
          (w["timetable"] as List<Map<String, dynamic>>).map((s) {
            return CourseTimeStamp(
              intStamp: s["intStamp"] as int,
              dayOfWeek: s["dayOfWeek"] as int,
              courseID: s["courseID"] as String,
              teacherID: s["teacherID"] as String,
              room: s["room"] as String,
              timeStampType: TimeStampType.values[s["timeStampType"] as int],
            );
          }).toList(),
          startDate: epoch(w["startDate"] as int),
          weekNo: w["weekNo"] as int?,
        );
      }).toList();
      return;
    }

    List<SubjectCourse> registeredCourses = User.learningCourseIDs
        .map((id) => InStudyCourses.getCourse(id)!)
        .toList();
    timetable = currentPlan.timetable
        .asMap()
        .map<int, WeekTimetable>((w, p) {
          List<CourseTimeStamp> stamps = [];
          for (SubjectCourse course in registeredCourses) {
            for (CourseTimeStamp stamp in course.timestamp) {
              if (p[stamp.dayOfWeek] != DayType.H) continue;
              stamps.add(stamp);
            }
          }
          return MapEntry(
            w,
            WeekTimetable(
              stamps,
              startDate: startDate.add(Duration(days: 7 * w)),
              weekNo: currentPlan.studyWeeks.indexOf(w),
            ),
          );
        })
        .values
        .toList();
    await _write();
  }
}

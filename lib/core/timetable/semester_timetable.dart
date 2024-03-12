import 'dart:convert';

import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/study_plan.dart';
import 'package:student/core/databases/subject_courses.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';

class WeekTimetable {
  final DateTime startDate; // must be start of week
  final List<CourseTimeStamp> timestamps;
  final int? weekNo;
  WeekTimetable(this.timestamps, {required this.startDate, this.weekNo});
}

final class SemesterTimetable {
  SemesterTimetable._instance();
  static final _semesterTimetableInstance = SemesterTimetable._instance();
  factory SemesterTimetable() {
    return _semesterTimetableInstance;
  }

  late List<WeekTimetable> timetable;
  final TLUSemester currentSemester = User().semester;
  late final DateTime startDate;

  Future<void> update(dynamic info) async {
    await _write();
  }

  Future<void> _write() async {
    String rawInfo = json.encode(timetable);
    await SharedPrefs.setString("userTimetable", rawInfo);
  }

  Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("userTimetable");
    SemesterPlan currentPlan = StudyPlan().table[currentSemester.index];
    startDate = currentPlan.startDate;
    if (rawInfo is String) {
      List<Map<String, dynamic>> parsedInfo = jsonDecode(rawInfo);
      timetable = parsedInfo.map((w) {
        return WeekTimetable(
          MiscFns.listType<Map<String, dynamic>>(
            w["timetable"] as List,
          ).map((s) {
            return CourseTimeStamp(
              intStamp: s["intStamp"] as int,
              dayOfWeek: s["dayOfWeek"] as int,
              courseID: s["courseID"] as String,
              teacherID: s["teacherID"] as String,
              room: s["room"] as String,
              timeStampType: TimeStampType.values[s["timeStampType"] as int],
            );
          }).toList(),
          startDate: MiscFns.epoch(w["startDate"] as int),
          weekNo: w["weekNo"] as int?,
        );
      }).toList();
      return;
    }

    List<SubjectCourse> registeredCourses = User()
        .learningCourseIDs
        .map((id) => InStudyCourses().getCourse(id)!)
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

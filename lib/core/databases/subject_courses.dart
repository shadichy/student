import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/subjects.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/routing.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/iterable_extensions.dart';

final class InStudyCourses {
  InStudyCourses._instance();
  static final _inStudyCoursesInstance = InStudyCourses._instance();
  factory InStudyCourses() {
    return _inStudyCoursesInstance;
  }

  late final Iterable<Subject> _inStudyCourses;
  final RegExp _getCourseID = RegExp(r'(^[A-Z]+(\([A-Z]\))?)');

  Subject? getSubject(String id) =>
      _inStudyCourses.firstWhereIf((_) => _.subjectID == id);

  Subject? getSubjectAlt(String id) =>
      _inStudyCourses.firstWhereIf((_) => _.subjectAltID == id);

  SubjectCourse? getCourse(String id) =>
      getSubjectAlt(_getCourseID.firstMatch(id).toString())?.getCourse(id);

  Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("inStudyCourses");
    if (rawInfo is! String) {
      rawInfo = await Server.getSemester(User().group, User().semester);
      await SharedPrefs.setString("inStudyCourses", rawInfo);
    }

    Map<String, List<Map<String, dynamic>>> parsedInfo = {};

    try {
      parsedInfo = jsonDecode(rawInfo);
    } catch (e) {
      throw Exception(
          "Failed to parse inStudyCourses info JSON from cache! $e");
    }

    _inStudyCourses = parsedInfo.map<String, Subject>((key, value) {
      BaseSubject? s = Subjects().getSubject(key);
      if (s! is Subject) {
        throw Exception(
            "Failed to parse inStudyCourses info JSON: $key is invalid!");
      }

      Iterable<SubjectCourse> map = value.map<SubjectCourse>((c) {
        String courseID = c["courseID"] as String;

        SubjectCourse course = SubjectCourse(
          courseID: courseID,
          subjectID: s.subjectID,
          timestamp: (c["timestamp"] as List).map<CourseTimeStamp>(
            (s) {
              CourseTimeStamp stamp = CourseTimeStamp(
                courseID: courseID,
                intStamp: s["intStamp"] as int,
                dayOfWeek: s["dayOfWeek"] as int,
                teacherID: s["teacherID"] as String,
                room: s["room"] as String,
                timeStampType: TimeStampType.values[s["timeStampType"] as int],
              );

              Routing.addRoute(
                "stamp_${courseID}_${stamp.dayOfWeek}_${stamp.intStamp}",
                Routing.stamp(stamp),
              );

              return stamp;
            },
          ).toList(),
        );

        Routing.addRoute("course_$courseID", Routing.course(course));

        return course;
      });

      Subject subject = Subject.fromBase(
        s,
        map.toList(),
      );

      Routing.addRoute("subject_$s", Routing.subject(subject));

      return MapEntry(key, subject);
    }).values;
  }
}

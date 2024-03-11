import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/subjects.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/semester/functions.dart';

final class InStudyCourses {
  static late final List<Subject> _inStudyCourses;
  static final RegExp _getCourseID = RegExp(r'(^[A-Z]+(\([A-Z]\))?)');

  static Subject? getSubject(String id) =>
      _inStudyCourses.firstWhere((Subject s) => s.subjectID == id);

  static Subject? getSubjectAlt(String id) =>
      _inStudyCourses.firstWhere((Subject s) => s.subjectAltID == id);

  static SubjectCourse? getCourse(String id) =>
      getSubjectAlt(_getCourseID.firstMatch(id).toString())?.getCourse(id);

  static Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("inStudyCourses");
    if (rawInfo is! String) {
      rawInfo = await Server.getSemester(User.group, User.semester);
      await SharedPrefs.setString("inStudyCourses", rawInfo);
    }

    Map<String, List<Map<String, dynamic>>> parsedInfo = {};

    try {
      parsedInfo = jsonDecode(rawInfo);
    } catch (e) {
      throw Exception(
          "Failed to parse inStudyCourses info JSON from cache! $e");
    }

    _inStudyCourses = parsedInfo
        .map<String, Subject>(
          (key, value) {
            BaseSubject? s = Subjects.getSubject(key);
            if (s is! Subject) {
              throw Exception(
                  "Failed to parse inStudyCourses info JSON: $key is invalid!");
            }
            return MapEntry(
              key,
              Subject(
                subjectID: s.subjectID,
                subjectAltID: s.subjectAltID,
                name: s.name,
                tin: s.tin,
                dependencies: s.dependencies,
                courses: value.map<SubjectCourse>((c) {
                  return SubjectCourse(
                    courseID: c["courseID"] as String,
                    subjectID: s.subjectID,
                    timestamp: (c["timestamp"] as List).map<CourseTimeStamp>(
                      (s) {
                        return CourseTimeStamp(
                          courseID: c["courseID"] as String,
                          intStamp: s["intStamp"] as int,
                          dayOfWeek: s["dayOfWeek"] as int,
                          teacherID: s["teacherID"] as String,
                          room: s["room"] as String,
                          timeStampType:
                              TimeStampType.values[s["timeStampType"] as int],
                        );
                      },
                    ).toList(),
                  );
                }).toList(),
              ),
            );
          },
        )
        .values
        .toList();
  }
}

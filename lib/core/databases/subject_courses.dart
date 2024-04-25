import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/subjects.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/semester/functions.dart';

final class InStudyCourses {
  InStudyCourses._instance();
  static final _inStudyCoursesInstance = InStudyCourses._instance();
  factory InStudyCourses() {
    return _inStudyCoursesInstance;
  }

  late final List<Subject> _inStudyCourses;
  final RegExp _getCourseID = RegExp(r'(^[A-Z]+(\([A-Z]\))?)');

  Subject? getSubject(String id) =>
      _inStudyCourses.firstWhere((Subject s) => s.subjectID == id);

  Subject? getSubjectAlt(String id) =>
      _inStudyCourses.firstWhere((Subject s) => s.subjectAltID == id);

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

    _inStudyCourses = parsedInfo
        .map<String, Subject>(
          (key, value) {
            BaseSubject? s = Subjects().getSubject(key);
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
                cred: s.cred,
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

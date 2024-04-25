import 'package:student/core/presets.dart';
import 'package:student/core/databases/subject.dart';

enum TimeStampType { offline, online }

class CourseTimeStamp {
  final int intStamp;
  // late int startStamp;
  // late final int startStampUnix;
  // late int endStamp;
  // late final int endStampUnix;
  final int dayOfWeek;
  // late final String day;
  final String courseID;
  final String teacherID;
  final String room;
  final TimeStampType timeStampType;
  const CourseTimeStamp({
    required this.intStamp,
    required this.dayOfWeek,
    required this.courseID,
    required this.teacherID,
    required this.room,
    required this.timeStampType,
  });
}

class SubjectCourse {
  final String courseID;
  final String subjectID;
  final List<CourseTimeStamp> timestamp;
  late final BigInt intCourse;
  late final int length;
  late final List<String> teachers;
  late final List<String> rooms;
  SubjectCourse({
    required this.courseID,
    required this.subjectID,
    required this.timestamp,
  }) {
    length = timestamp.length;
    teachers = timestamp.map((m) => m.teacherID).toList();
    rooms = timestamp.map((m) => m.room).toList();
    intCourse = matrixIterate(timestamp);
  }

  static BigInt matrixIterate(List<CourseTimeStamp> stamps) {
    BigInt foldedStamp = BigInt.zero;
    for (CourseTimeStamp stamp in stamps) {
      foldedStamp |= (BigInt.from(stamp.intStamp) <<
          (stamp.dayOfWeek * classTimeStamps.length));
    }
    return foldedStamp;
  }
}

class Subject extends BaseSubject {
  final List<SubjectCourse> courses;
  Subject({
    required super.subjectID,
    required super.subjectAltID,
    required super.name,
    required super.cred,
    required super.dependencies,
    required this.courses,
  });

  SubjectCourse? getCourse(String courseID) {
    return courses.firstWhere(
      (SubjectCourse course) => course.courseID == courseID,
    );
  }
}

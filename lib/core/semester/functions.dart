import 'package:student/core/presets.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/misc/iterable_extensions.dart';

enum TimeStampType { offline, online }

enum CourseType { course, subcourse }

class CourseTimeStamp {
  final int intStamp;
  // late int startStamp;
  // late final int startStampUnix;
  // late int endStamp;
  // late final int endStampUnix;
  // late final String day;
  final int dayOfWeek;
  final String courseID;
  final String teacherID;
  final String room;
  final TimeStampType timeStampType;
  final CourseType? courseType; // LT and BT
  const CourseTimeStamp({
    required this.intStamp,
    required this.dayOfWeek,
    required this.courseID,
    required this.teacherID,
    required this.room,
    required this.timeStampType,
    this.courseType,
  });
}

class SubjectCourse {
  final String courseID;
  final String subjectID;
  final List<CourseTimeStamp> timestamp;
  // ignore: prefer_final_fields
  final BigInt intCourse;
  final int length;
  final List<String> teachers;
  final List<String> rooms;
  SubjectCourse({
    required this.courseID,
    required this.subjectID,
    required this.timestamp,
  })  : length = timestamp.length,
        teachers = timestamp.map((_) => _.teacherID).toList(),
        rooms = timestamp.map((_) => _.room).toList(),
        intCourse = timestamp.fold(BigInt.zero, (f, _) {
          return f |
              (BigInt.from(_.intStamp) <<
                  (_.dayOfWeek * classTimeStamps.length));
        });

  // static BigInt matrixIterate(List<CourseTimeStamp> stamps) {
  //   BigInt foldedStamp = BigInt.zero;
  //   for (CourseTimeStamp stamp in stamps) {
  //     foldedStamp |= (BigInt.from(stamp.intStamp) <<
  //         (stamp.dayOfWeek * classTimeStamps.length));
  //   }
  //   return foldedStamp;
  // }
}

class Subject extends BaseSubject {
  final List<SubjectCourse> courses;
  const Subject({
    required super.subjectID,
    required super.subjectAltID,
    required super.name,
    required super.cred,
    required super.dependencies,
    required this.courses,
  });
  Subject.fromBase(BaseSubject base, this.courses)
      : super(
          subjectID: base.subjectID,
          subjectAltID: base.subjectAltID,
          name: base.name,
          cred: base.cred,
          dependencies: base.dependencies,
        );

  SubjectCourse? getCourse(String courseID) {
    return courses.firstWhereIf((_) => _.courseID == courseID);
  }
}

extension BaseSubjectExtension on BaseSubject {
  Subject toSubject(List<SubjectCourse> courses) =>
      Subject.fromBase(this, courses);
}

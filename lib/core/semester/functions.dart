import 'package:student/core/presets.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/misc/iterable_extensions.dart';

enum TimeStampType { offline, online }

enum CourseType { course, subcourse }

class EventTimestamp {
  final String eventName;
  final int intStamp;
  final int dayOfWeek; // for one single event open-close time at a day
  final String? location;
  final String? heldBy;

  const EventTimestamp({
    required this.eventName,
    this.intStamp = -1, // all day
    required this.dayOfWeek,
    this.location,
    this.heldBy,
  });

  @override
  String toString() => ({
        'eventName': eventName,
        'intStamp': intStamp,
        'dayOfWeek': dayOfWeek,
        'location': location,
        'heldBy': heldBy,
      }).toString();
}

class CourseTimestamp extends EventTimestamp {
  // final int intStamp;
  // late int startStamp;
  // late final int startStampUnix;
  // late int endStamp;
  // late final int endStampUnix;
  // late final String day;
  // final int dayOfWeek;
  String get courseID => eventName;
  String get teacherID => heldBy!;
  String get room => location!;
  final TimeStampType timestampType;
  final CourseType? courseType; // LT and BT
  const CourseTimestamp({
    required super.intStamp,
    required super.dayOfWeek,
    required String courseID,
    required String teacherID,
    required String room,
    required this.timestampType,
    this.courseType,
  }) : super(
          eventName: courseID,
          location: room,
          heldBy: teacherID,
        );

  @override
  String toString() => ({
        'intStamp': intStamp,
        'dayOfWeek': dayOfWeek,
        'courseID': courseID,
        'teacherID': teacherID,
        'room': room,
        'timestampType': timestampType.index,
        'courseType': courseType?.index,
      }).toString();
}

class EventTimeline {
  final String label;
  final List<EventTimestamp> timestamp;
  final BigInt intEvent;
  final List<String> heldBy;
  final List<String> locations;

  EventTimeline({
    required this.label,
    required this.timestamp,
  })  : heldBy = timestamp
            .where((_) => _.heldBy != null)
            .map((_) => _.heldBy!)
            .toList(),
        locations = timestamp
            .where((_) => _.location != null)
            .map((_) => _.location!)
            .toList(),
        intEvent = timestamp.fold(BigInt.zero, (f, _) {
          return f |
              (BigInt.from(_.intStamp) <<
                  (_.dayOfWeek * classTimeStamps.length));
        });

  int get length => timestamp.length;
}

class SchoolEvent extends EventTimeline {
  final String? title;
  final String? desc;
  final DateTime startDate;

  SchoolEvent({
    required super.label,
    required super.timestamp,
    String? title,
    this.desc,
    required this.startDate,
  }) : title = title ?? label;
}

class SubjectCourse extends EventTimeline {
  final String subjectID;
  final List<CourseTimestamp> _timestamp;

  String get courseID => label;
  BigInt get intCourse => intEvent;
  List<String> get teachers => heldBy;
  List<String> get rooms => locations;

  @override
  List<CourseTimestamp> get timestamp => _timestamp;

  SubjectCourse({
    required String courseID,
    required this.subjectID,
    required List<CourseTimestamp> timestamp,
  })  : _timestamp = timestamp,
        super(label: courseID, timestamp: []);
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

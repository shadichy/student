import 'dart:convert';

import 'package:bitcount/bitcount.dart';
import 'package:hive/hive.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/misc/misc_functions.dart';

part 'functions.g.reserved.dart';

enum TimestampType { offline, online }

enum CourseType { course, subcourse }

@HiveType(typeId: 1)
class EventTimestamp {
  static int get maxStamp => (-1).toUnsigned(SPBasics().classTimestamps.length);

  @HiveField(0)
  final String eventName;
  @HiveField(1)
  final int intStamp;
  @HiveField(2)
  final int dayOfWeek; // for one single event open-close time at a day
  @HiveField(3)
  final String? location;
  @HiveField(4)
  final String? heldBy;

  EventTimestamp({
    required this.eventName,
    int intStamp = -1, // all day
    required this.dayOfWeek,
    this.location,
    this.heldBy,
  }) : intStamp = intStamp.toUnsigned(SPBasics().classTimestamps.length);

  EventTimestamp.fromJson(Map<String, dynamic> jsonData)
      : this(
          eventName: jsonData["eventName"] as String,
          intStamp: jsonData["intStamp"] as int,
          dayOfWeek: jsonData["dayOfWeek"] as int,
          heldBy: jsonData["heldBy"],
          location: jsonData["location"],
        );

  int operator &(Object other) {
    if (other is! EventTimestamp) {
      throw Exception("Can only operate with EventTimestamp");
    }
    return intStamp & other.intStamp;
  }

  int operator |(Object other) {
    if (other is! EventTimestamp) {
      throw Exception("Can only operate with EventTimestamp");
    }
    return intStamp | other.intStamp;
  }

  @override
  bool operator ==(Object other) {
    if (other is! EventTimestamp) {
      throw Exception("Can only operate with EventTimestamp");
    }
    return intStamp == other.intStamp &&
        eventName == other.eventName &&
        dayOfWeek == other.dayOfWeek &&
        location == other.location &&
        heldBy == other.heldBy;
  }

  int get startStamp {
    if (intStamp == 0) return SPBasics().classTimestamps.length;
    int classStartsAt = 0;
    while (intStamp & (1 << classStartsAt) == 0) {
      classStartsAt++;
    }
    return classStartsAt;
  }

  int get stampLength => intStamp.bitCount();

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() => {
        'eventName': eventName,
        'intStamp': intStamp,
        'dayOfWeek': dayOfWeek,
        'location': location,
        'heldBy': heldBy,
      };

  @override
  String toString() => jsonEncode(toMap());

  @override
  int get hashCode =>
      Object.hash(eventName, intStamp, dayOfWeek, location, heldBy);
}

@HiveType(typeId: 2)
final class CourseTimestamp extends EventTimestamp {
  // final int intStamp;
  // late int startStamp;
  // late final int startStampUnix;
  // late int endStamp;
  // late final int endStampUnix;
  // late final String day;
  // final int dayOfWeek;
  @HiveField(5)
  final int timestampTypeInt;
  final TimestampType timestampType;
  @HiveField(6)
  final int? courseTypeInt;
  final CourseType? courseType; // LT and BT

  String get courseID => eventName;
  String get teacherID => heldBy!;
  String get room => location!;

  bool get isOnlineClass => timestampType == TimestampType.online;

  CourseTimestamp({
    required super.intStamp,
    required super.dayOfWeek,
    required String courseID,
    required String teacherID,
    required String room,
    required this.timestampType,
    this.courseType,
  })  : timestampTypeInt = timestampType.index,
        courseTypeInt = courseType?.index,
        super(
          eventName: courseID,
          location: room,
          heldBy: teacherID,
        );
  CourseTimestamp.fromHive({
    required super.intStamp,
    required super.dayOfWeek,
    required String courseID,
    required String teacherID,
    required String room,
    required this.timestampTypeInt,
    this.courseTypeInt,
  })  : timestampType = TimestampType.values[timestampTypeInt],
        courseType =
            courseTypeInt == null ? null : CourseType.values[courseTypeInt],
        super(
          eventName: courseID,
          location: room,
          heldBy: teacherID,
        );

  CourseTimestamp.fromJson(Map<String, dynamic> jsonData, [String? courseID])
      : this(
          courseID: courseID ?? (jsonData["courseID"] as String),
          intStamp: jsonData["intStamp"] as int,
          dayOfWeek: jsonData["dayOfWeek"] as int,
          teacherID: jsonData["teacherID"] as String,
          room: jsonData["room"] as String,
          timestampType: TimestampType.values[jsonData["timestampType"] as int],
          courseType: jsonData["courseType"] == null
              ? null
              : CourseType.values[jsonData["courseType"]],
        );

  @override
  Map<String, dynamic> toMap() => {
        'intStamp': intStamp,
        'dayOfWeek': dayOfWeek,
        'courseID': courseID,
        'teacherID': teacherID,
        'room': room,
        'timestampType': timestampType.index,
        'courseType': courseType?.index,
      };
}

@HiveType(typeId: 3)
class EventTimeline {
  @HiveField(0)
  final String label;
  @HiveField(1)
  final List<EventTimestamp> timestamp;
  final BigInt intEvent;
  final List<String> heldBy;
  final List<String> locations;

  EventTimeline({
    required this.label,
    required this.timestamp,
  })  : heldBy = _unique(timestamp, (t) => t.heldBy),
        locations = _unique(timestamp, (t) => t.location),
        intEvent = timestamp.fold(BigInt.zero, (f, i) {
          return f |
              (BigInt.from(i.intStamp) <<
                  (i.dayOfWeek * SPBasics().classTimestamps.length));
        });

  static List<T> _unique<T, E>(Iterable<E> l, T? Function(E) cb) =>
      l.where((t) => cb(t) != null).map((t) => cb(t)!).toSet().toList();

  int get length => timestamp.length;

  BigInt operator &(Object other) {
    if (other is! EventTimeline) {
      throw ArgumentError("Can only operate with EventTimeline");
    }
    return intEvent & other.intEvent;
  }

  BigInt operator |(Object other) {
    if (other is! EventTimeline) {
      throw ArgumentError("Can only operate with EventTimeline");
    }
    return intEvent | other.intEvent;
  }

  @override
  bool operator ==(Object other) {
    if (other is! EventTimeline) {
      throw ArgumentError("Can only operate with EventTimeline");
    }
    if (label != other.label) return false;
    if (timestamp.length != other.timestamp.length) return false;

    for (var i = 0; i < timestamp.length; i++) {
      if (timestamp[i] != other.timestamp[i]) return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() => {
        'label': label,
        'timestamp': timestamp,
        'heldBy': heldBy,
        'locations': locations,
      };

  @override
  String toString() => jsonEncode(toMap());

  @override
  int get hashCode => Object.hashAll([label, ...timestamp]);
}

@HiveType(typeId: 4)
final class SchoolEvent extends EventTimeline {
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? desc;
  @HiveField(4)
  final List<DateTime> days;

  SchoolEvent({
    required super.label,
    required super.timestamp,
    String? title,
    this.desc,
    required this.days,
  }) : title = title ?? label;
}

@HiveType(typeId: 5)
final class SubjectCourse extends EventTimeline {
  @HiveField(2)
  final String subjectID;
  @HiveField(3)
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
        super(
          label: courseID,
          timestamp: timestamp,
        );

  SubjectCourse.fromJson(Map<String, dynamic> jsonData,
      [String? courseID, String? subjectID])
      : this(
          courseID: courseID ?? (jsonData["courseID"] as String),
          subjectID: subjectID ??
              Storage()
                  .getSubjectAlt(courseID ?? (jsonData["courseID"] as String))
                  ?.subjectID ??
              (jsonData["subjectID"] as String),
          timestamp:
              MiscFns.list<Map<String, dynamic>>(jsonData["timestamp"] as List)
                  .map((t) => CourseTimestamp.fromJson(t, courseID))
                  .toList(),
        );
  SubjectCourse.fromList(Iterable timestamp, String courseID,
      [String? subjectID])
      : this(
          courseID: courseID,
          subjectID: subjectID ??
              Storage().getSubjectBaseAlt(courseID)?.subjectID ??
              Storage().getSubjectAlt(courseID)?.subjectID ??
              "Unknown",
          timestamp: timestamp
              .cast<Map<String, dynamic>>()
              .map((t) => CourseTimestamp.fromJson(t, courseID))
              .toList(),
        );

  @override
  Map<String, dynamic> toMap() => {
        'subjectID': subjectID,
        'courseID': courseID,
        'teachers': teachers,
        'rooms': rooms,
        'timestamp': timestamp,
      };
}

@HiveType(typeId: 10)
final class Subject extends BaseSubject {
  @HiveField(6)
  final Map<String, SubjectCourse> courses;

  const Subject({
    required super.subjectID,
    required super.subjectAltID,
    required super.name,
    required super.cred,
    required super.coef,
    required super.dependencies,
    required this.courses,
  });

  Subject.fromBase(BaseSubject base, this.courses)
      : super(
          subjectID: base.subjectID,
          subjectAltID: base.subjectAltID ??
              RegExp(r'([^.]+)').firstMatch(courses.values.first.courseID)?[0],
          name: base.name,
          cred: base.cred,
          coef: base.coef,
          dependencies: base.dependencies,
        );

  SubjectCourse? getCourse(String courseID) {
    try {
      return courses["courseID"];
    } catch (e) {
      return null;
    }
  }

  BaseSubject toBase() => BaseSubject(
      subjectID: subjectID,
      subjectAltID: subjectAltID,
      name: name,
      cred: cred,
      coef: coef,
      dependencies: dependencies);

  @override
  Map<String, dynamic> toMap() => {
        'subjectID': subjectID,
        'subjectAltID': subjectAltID,
        'name': name,
        'cred': cred,
        'dependencies': dependencies,
        'courses': courses,
      };

  @override
  bool operator ==(Object other) {
    if (other is! Subject) {
      throw ArgumentError("Can only operate with Subject");
    }
    if (subjectID != other.subjectID) return false;
    if (courses.length != other.courses.length) return false;
    for (var entry in courses.entries) {
      if (other.courses[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll([subjectID, ...courses.values]);
}

extension BaseSubjectExtension on BaseSubject {
  Subject toSubject(Map<String, SubjectCourse> courses) =>
      Subject.fromBase(this, courses);
}

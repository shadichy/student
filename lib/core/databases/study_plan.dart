// import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:student/core/databases/user.dart';

part 'study_plan.g.dart';

enum DayType { H, T, N, B, Q, O, S, X }

@HiveType(typeId: 8)
class SemesterPlan {
  @HiveField(0)
  final int semester;
  final UserSemester currentSemester;
  @HiveField(1)
  final Iterable<Iterable<int>> timetableInt;
  final Iterable<Iterable<DayType>> timetable;
  @HiveField(2)
  final List<int> studyWeeks;
  @HiveField(3)
  final DateTime startDate;
  SemesterPlan({
    required this.semester,
    required this.timetableInt,
    required this.studyWeeks,
    required this.startDate,
  })  : currentSemester = UserSemester.values[semester],
        timetable = timetableInt.map(
          (w) => w.map((e) => DayType.values[e]),
        );

  Map<String, dynamic> toMap() => {
        'semester': semester,
        'timetableInt': timetableInt.toList(),
        'studyWeeks': studyWeeks,
        'startDate': startDate,
      };

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() => toMap().toString();
}

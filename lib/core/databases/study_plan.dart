import 'package:flutter/widgets.dart';
import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/misc/iterable_extensions.dart';
import 'package:student/misc/misc_functions.dart';

enum DayType { H, T, N, B, Q, O, S, X }

class SemesterPlan {
  final UserSemester currentSemester;
  final List<List<DayType>> timetable;
  final List<int> studyWeeks;
  final DateTime startDate;
  const SemesterPlan({
    required this.currentSemester,
    required this.timetable,
    required this.studyWeeks,
    required this.startDate,
  });
}

final class StudyPlan {
  StudyPlan._instance();
  static final _studyPlanInstance = StudyPlan._instance();
  factory StudyPlan() {
    return _studyPlanInstance;
  }

  late final DateTime startDate; // must be start of week
  late final Iterable<SemesterPlan> table;

  // static List<DayType> _full(DayType type) => List.generate(7, (_) => type);

  Future<void> initialize() async {
    Map<String, dynamic> parsedInfo = await Server.getStudyPlan(User().group);

    int startDateInt = parsedInfo["startDate"];

    startDate = MiscFns.epoch(startDateInt);

    int prevWeeks = 0;

    table = MiscFns.listType<String>(parsedInfo["plan"] as List)
        .asMap()
        .map((l, s) {
      List<List<DayType>> chunkedWeek = (s)
          .characters
          .map((d) => DayType.values[int.parse(d)])
          .chunked(7)
          .toList();
      List<int> studyWeek = [];

      chunkedWeek.asMap().forEach((key, value) {
        if (!value.contains(DayType.H)) return;
        studyWeek.add(key);
      });

      int startDate = prevWeeks * 7 * 24 * 3600 + startDateInt;
      prevWeeks += chunkedWeek.length;

      return MapEntry(
        l,
        SemesterPlan(
          currentSemester: UserSemester.values[l],
          timetable: chunkedWeek,
          studyWeeks: studyWeek,
          startDate: MiscFns.epoch(startDate),
        ),
      );
    }).values;
  }
}

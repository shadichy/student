// import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
import 'package:characters/characters.dart';
import 'package:hive/hive.dart';
import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/misc/iterable_extensions.dart';
import 'package:student/misc/misc_functions.dart';
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
}

@Deprecated("moving to Hive")
final class StudyPlan {
  StudyPlan._instance();
  static final _studyPlanInstance = StudyPlan._instance();
  factory StudyPlan() {
    return _studyPlanInstance;
  }

  late final DateTime startDate; // must be start of week
  final List<SemesterPlan> table = [];

  // static List<DayType> _full(DayType type) => List.generate(7, (_) => type);

  void setPlan(DateTime startDate, Iterable<SemesterPlan> table) {
    this.startDate = startDate;
    this.table.addAll(table);
  }

  Future<void> initialize() async {
    Map<String, dynamic> parsedInfo = await Server.getStudyPlan(User().group);

    int startDateInt = parsedInfo["startDate"];

    startDate = MiscFns.epoch(startDateInt);

    int prevWeeks = 0;
    int prev = 0;

    (parsedInfo["plan"] as List).cast<String>().forEach((s) {
      List<int> studyWeek = [];
      List<Iterable<int>> chunkedWeek =
          (s).characters.map((d) => int.parse(d)).chunked(7).toList();

      chunkedWeek.asMap().forEach((key, value) {
        if (!value.contains(DayType.H.index)) return;
        studyWeek.add(key);
      });

      int startDate = prevWeeks * 7 * 24 * 3600 + startDateInt;
      prevWeeks += chunkedWeek.length;
      prev++;

      table.add(SemesterPlan(
        semester: prev - 1,
        timetableInt: chunkedWeek,
        studyWeeks: studyWeek,
        startDate: MiscFns.epoch(startDate),
      ));
    });
  }
}

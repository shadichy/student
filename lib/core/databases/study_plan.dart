import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/misc/misc_functions.dart';

enum DayType { H, T, N, B, Q }

class SemesterPlan {
  final TLUSemester currentSemester;
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
  late final List<SemesterPlan> table;

  // static List<DayType> _full(DayType type) => List.generate(7, (_) => type);

  Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("studyPlan");
    if (rawInfo is! String) {
      rawInfo = await Server.getStudyPlan(User().group);
      await SharedPrefs.setString("studyPlan", rawInfo);
    }

    Map<String, dynamic> parsedInfo = {};

    try {
      parsedInfo = jsonDecode(rawInfo);
    } catch (e) {
      throw Exception("Failed to parse studyPlan info JSON from cache! $e");
    }

    startDate = MiscFns.epoch(parsedInfo["startDate"] as int);

    table = MiscFns.listType<Map<String, dynamic>>(parsedInfo["plan"] as List)
        .asMap()
        .map((l, s) {
          return MapEntry(
            l,
            SemesterPlan(
              currentSemester: TLUSemester.values[l],
              timetable: MiscFns.listType<List>(s["week"] as List).map((w) {
                return MiscFns.listType<int>(w)
                    .map((i) => DayType.values[i])
                    .toList();
              }).toList(),
              studyWeeks: MiscFns.listType<int>(s["studyWeek"] as List),
              startDate: MiscFns.epoch(s["startDate"] as int),
            ),
          );
        })
        .values
        .toList();
  }
}

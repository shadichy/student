import 'dart:convert';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/user.dart';

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
  static late final DateTime startDate; // must be start of week
  static late final List<SemesterPlan> table;

  // static List<DayType> _full(DayType type) => List.generate(7, (_) => type);

  static DateTime epoch(int s) => DateTime.fromMillisecondsSinceEpoch(s * 1000);

  static Future<void> initialize() async {
    String? rawInfo = SharedPrefs.getString("studyPlan");
    if (rawInfo is! String) {
      rawInfo = await Server.getStudyPlan(User.group);
      await SharedPrefs.setString("studyPlan", rawInfo);
    }

    Map<String, dynamic> parsedInfo = {};

    try {
      parsedInfo = jsonDecode(rawInfo);
    } catch (e) {
      throw Exception("Failed to parse studyPlan info JSON from cache! $e");
    }

    startDate = epoch(parsedInfo["startDate"] as int);

    table = (parsedInfo["plan"] as List<Map<String, dynamic>>)
        .asMap()
        .map((l, s) {
          return MapEntry(
            l,
            SemesterPlan(
              currentSemester: TLUSemester.values[l],
              timetable: (s["week"] as List<List<int>>).map((w) {
                return w.map((i) => DayType.values[i]).toList();
              }).toList(),
              studyWeeks: s["studyWeek"] as List<int>,
              startDate: epoch(s["startDate"] as int),
            ),
          );
        })
        .values
        .toList();
  }
}

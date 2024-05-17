import 'package:student/core/configs.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/default_configs.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/core/timetable/semester_timetable.dart';

abstract final class UpcomingData {
  static final int _fullStamp =
      (-1).toUnsigned(SPBasics().classTimestamps.length);
  static final DateTime _now = DateTime.now();
  static final int _weekday = _now.weekday % 7;

  static int get weekdayStart =>
      AppConfig().getConfig<int>("misc.startWeekday") ??
      defaultConfig["misc.startWeekday"];

  static DateTime get weekStart => _now.subtract(
        Duration(days: _weekday - weekdayStart),
      );

  static WeekTimetable get thisWeek => SemesterTimetable().getWeek(weekStart);

  static Iterable<EventTimestamp> get upcomingEvents =>
      thisWeek.timestamps.where((e) {
        if (e.dayOfWeek != _weekday) return false;
        int current = _now
            .difference(DateTime(_now.year, _now.month, _now.day))
            .inSeconds;
        if (current >
            SPBasics().classTimestamps[SPBasics().classTimestamps.length - 1]
                [1]) {
          return false;
        }
        int startAt = 0;
        while (current > SPBasics().classTimestamps[startAt][0]) {
          startAt++;
          if (startAt == SPBasics().classTimestamps.length) {
            break;
          }
        }
        if (startAt > 0) startAt--;
        return e.intStamp & (_fullStamp << startAt) != 0;
      });
}

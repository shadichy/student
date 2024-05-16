import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/study_plan.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/databases/subject_courses.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';

class WeekTimetable {
  final DateTime startDate; // must be start of week
  List<EventTimestamp> _timestamps;
  List<EventTimestamp> get timestamps => _timestamps;
  final int? weekNo;
  WeekTimetable(List<EventTimestamp> timestamps,
      {required this.startDate, this.weekNo})
      : _timestamps = timestamps;

  void addStamps(Iterable<EventTimestamp> timestamp) {
    _timestamps.addAll(timestamp);
  }

  void setStamps(List<EventTimestamp> timestamp) {
    _timestamps = timestamp;
  }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() => {
        'startDate': (startDate.millisecondsSinceEpoch / 1000).floor(),
        'timestamps': _timestamps,
        'weekNo': weekNo,
      };

  @override
  String toString() => toMap.toString();
}

final class SemesterTimetable {
  SemesterTimetable._instance();
  static final _semesterTimetableInstance = SemesterTimetable._instance();
  factory SemesterTimetable() {
    return _semesterTimetableInstance;
  }

  late List<WeekTimetable> _timetable;
  final TLUSemester _currentSemester = User().semester;
  late final DateTime _startDate;

  List<WeekTimetable> get timetable => _timetable;
  TLUSemester get currentSemester => _currentSemester;
  DateTime get startDate => _startDate;

  SemesterPlan currentPlan = StudyPlan().table.toList()[User().semester.index];

  WeekTimetable getWeek(DateTime startDate) {
    int daysDiff = startDate.difference(_startDate).inDays.abs();
    int week = (daysDiff / 7).floor();
    int startDay = daysDiff % 7;
    List<EventTimestamp> timestamps = [];
    if (week < _timetable.length) {
      timestamps.addAll(startDay == 0
          ? _timetable[week]._timestamps
          : [
              ..._timetable[week]
                  ._timestamps
                  .where((_) => _.dayOfWeek >= startDay),
              if (week + 1 < _timetable.length)
                ..._timetable[week + 1]
                    ._timestamps
                    .where((_) => _.dayOfWeek < startDay)
            ]);
    }
    print(currentPlan.studyWeeks);
    if (currentPlan.studyWeeks.contains(week)) {
      week = currentPlan.studyWeeks.indexOf(week);
    } else {
      week = -1;
    }
    return WeekTimetable(
      timestamps,
      startDate: startDate,
      weekNo: startDay == 0 ? week : (week + 1),
    );
  }

  void _modify(
      List<EventTimestamp> timestamp,
      List<DateTime> days,
      void Function(
        WeekTimetable currentWeek,
        Iterable<EventTimestamp> targetEvents,
      ) modifier) {
    for (DateTime day in days) {
      int daysDiff = day.difference(_startDate).inDays;
      int week = (daysDiff / 7).floor();
      int doW = daysDiff % 7;
      while (_timetable.length < week + 1) {
        _timetable.add(
          WeekTimetable([], startDate: startDate.add(Duration(days: 7 * week))),
        );
      }
      Iterable<EventTimestamp> matchEvents =
          timestamp.where((_) => _.dayOfWeek == doW);
      WeekTimetable targetWeek = _timetable[week];
      modifier(targetWeek, matchEvents);
      // _timetable[week] = WeekTimetable(
      //   startDate: targetWeek.startDate,
      // );
    }
  }

  void _overwrite(List<EventTimestamp> timestamp, List<DateTime> days) {
    _modify(
      timestamp,
      days,
      (c, t) => c.setStamps([
        ...c._timestamps.where((_) {
          for (EventTimestamp event in t) {
            if (event.intStamp | _.intStamp != 0) return false;
          }
          return true;
        }),
        ...t,
      ]),
    );
  }

  void _addByDays(List<EventTimestamp> timestamp, List<DateTime> days) {
    _modify(timestamp, days, (c, t) => c.addStamps(t));
  }

  void _addAll(List<EventTimestamp> timestamp) {
    void add(WeekTimetable _) => _.addStamps(timestamp);
    _timetable.forEach(add);
  }

  Future<void> update(EventTimeline event,
      {bool override = false, List<DateTime>? days}) async {
    if (event is CourseTimestamp) {
      assert(!override || days != null,
          '"days" must be specified for Course update');
      if (override) {
        _overwrite(event.timestamp, days!);
      } else {
        if (days != null) {
          _addByDays(event.timestamp, days);
        } else {
          _addAll(event.timestamp);
        }
      }
      // else add for everyday
    } else if (event is SchoolEvent) {
      days ??= event.days;
      (override ? _overwrite : _addByDays)(event.timestamp, days);
    } else {
      return;
    }
    await _write();
  }

  Future<void> _write() async {
    await SharedPrefs.setString("userTimetable", _timetable);
  }

  Future<void> initialize() async {
    List? rawInfo = SharedPrefs.getString("userTimetable");

    _startDate = currentPlan.startDate;

    if (rawInfo is List) {
      Iterable<Map<String, dynamic>> parsedInfo =
          MiscFns.listType<Map<String, dynamic>>(rawInfo);
      _timetable = parsedInfo.map((w) {
        return WeekTimetable(
          MiscFns.listType<Map<String, dynamic>>(
            w["timestamps"] as List,
          ).map((s) {
            return s["courseID"] != null
                ? CourseTimestamp.fromJson(s)
                : EventTimestamp.fromJson(s);
          }).toList(),
          startDate: MiscFns.epoch(w["startDate"] as int),
          weekNo: w["weekNo"] as int?,
        );
      }).toList();
      return;
    }

    Iterable<SubjectCourse> registeredCourses = User()
        .learningCourses[SPBasics().currentYear - User().schoolYear]
            [User().semester]!
        .map((id) => InStudyCourses().getCourse(id)!);

    _timetable = currentPlan.timetable
        .asMap()
        .map<int, WeekTimetable>((w, p) {
          List<CourseTimestamp> stamps = [];
          for (SubjectCourse course in registeredCourses) {
            for (CourseTimestamp stamp in course.timestamp) {
              if (p[stamp.dayOfWeek] != DayType.H &&
                  p[stamp.dayOfWeek] != DayType.B) continue;
              stamps.add(stamp);
            }
          }
          return MapEntry(
            w,
            WeekTimetable(
              stamps,
              startDate: _startDate.add(Duration(days: 7 * w)),
              weekNo: currentPlan.studyWeeks.indexOf(w),
            ),
          );
        })
        .values
        .toList();
    await _write();
  }
}

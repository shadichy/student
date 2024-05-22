import 'package:characters/characters.dart';
import 'package:hive/hive.dart';
import 'package:student/core/databases/study_plan.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/notification/alarm.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/core/timetable/semester_timetable.dart';
import 'package:student/misc/iterable_extensions.dart';
import 'package:student/misc/misc_functions.dart';

final class Storage {
  Storage._instance();
  static final _notifInstance = Storage._instance();
  factory Storage() {
    return _notifInstance;
  }

  late final Box _generic;
  late final Box<BaseSubject> _subjects;
  late final Box<String> _teachers;
  late final Box<Subject> _learning;
  late final Box<SemesterPlan> _plan;
  late final Box<WeekTimetable> _week;
  late final Box<Reminder> _reminders;
  late final Box<Notif> _notifications;

  bool _notificationInitialized = false;

  Future<void> initialize() async {
    Hive.registerAdapter(BaseSubjectAdapter());
    Hive.registerAdapter(EventTimestampAdapter());
    Hive.registerAdapter(CourseTimestampAdapter());
    Hive.registerAdapter(EventTimelineAdapter());
    Hive.registerAdapter(SchoolEventAdapter());
    Hive.registerAdapter(SubjectCourseAdapter());
    Hive.registerAdapter(SubjectAdapter());
    Hive.registerAdapter(SemesterPlanAdapter());
    Hive.registerAdapter(WeekTimetableAdapter());
    Hive.registerAdapter(ReminderAdapter());
    Hive.registerAdapter(NotifAdapter());

    _generic = await Hive.openBox("base");
    _subjects = await Hive.openBox<BaseSubject>("subjects");
    _teachers = await Hive.openBox<String>("teachers");
    _learning = await Hive.openBox<Subject>("courses");
    _plan = await Hive.openBox<SemesterPlan>("plan");
    _week = await Hive.openBox<WeekTimetable>("week");
    _reminders = await Hive.openBox<Reminder>("alarms");
    _notifications = await Hive.openBox<Notif>("notifications");

    await initBasics();
    await initTeacher();
    await initSubjects();
    await initCourses();
    await initPlan();
    await initTimetable();
    initNotifications();
  }

  // TODO: implement download method
  Future<T> download<T>(String endpoint) async {
    throw UnimplementedError();
  }

  T? fetch<T>(String key) => _generic.get(key) as T?;

  Future<void> put(String key, dynamic value) async =>
      await _generic.put(key, value);

  Future<void> setUser() async => await put("user", User().toJson());

  Map<String, dynamic>? getUser() => fetch<Map<String, dynamic>>("user");

  Future<void> setBasics() async => await put("basics", SPBasics().toJson());

  Future<void> initBasics() async {
    Map<String, dynamic>? basics = fetch<Map<String, dynamic>>("basics");
    if (basics != null) return SPBasics().setBasics(basics);
    await SPBasics().initialize();
    await setBasics();
  }

  Future<void> initTeacher() async {
    if (_teachers.isNotEmpty) return;
    await _teachers.putAll(await download<Map<String, String>>("teachers"));
  }

  Future<void> initSubjects() async {
    if (_subjects.isNotEmpty) return;
    await _subjects.putAll(
      (await download<Map<String, dynamic>>("${User().group.name}/subjects"))
          .map(
        (k, v) => MapEntry(k, BaseSubject.fromJson(v as Map<String, dynamic>)),
      ),
    );
  }

  Future<void> initPlan() async {
    DateTime? startDate = fetch("plan.startDate");
    if (planTable.isNotEmpty && startDate != null) return;

    Map<String, dynamic> parsedInfo =
        await download("${User().group.name}/study_plan");

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

      _plan.add(SemesterPlan(
        currentSemester: prev - 1,
        timetable: chunkedWeek,
        studyWeeks: studyWeek,
        startDate: MiscFns.epoch(startDate),
      ));
    });

    await put("plan.startDate", startDate);
  }

  Future<void> initCourses() async {
    if (_learning.isNotEmpty) return;
    (await download<Map<String, dynamic>>(
            "${User().group.name}/${User().semester.name}/semester"))
        .forEach(
      (k, v) async {
        try {
          BaseSubject base = getSubjectBase(k)!;
          await _learning.put(
            k,
            Subject.fromBase(
              base,
              (v as Map<String, dynamic>).map(
                (c, t) => MapEntry(
                  c,
                  SubjectCourse.fromList(t as List, c, base.subjectID),
                ),
              ),
            ),
          );
        } catch (e) {
          // database is not correctly set up
        }
      },
    );
  }

  Future<void> initTimetable() async {
    DateTime? startDate = fetch("week.startDate");
    if (_week.isNotEmpty && startDate != null) return;

    SemesterPlan plan = currentPlan;
    startDate = plan.startDate;

    List<SubjectCourse> registeredCourses = [];
    for (String id
        in User().learningCourses[SPBasics().currentYear - User().schoolYear]
            [User().semester]!) {
      try {
        registeredCourses.add(getCourse(id)!);
      } catch (e) {
        // invalid course
      }
    }

    int prev = 0;

    for (Iterable<DayType> e in plan.timetable) {
      List<CourseTimestamp> stamps = [];
      for (SubjectCourse course in registeredCourses) {
        for (CourseTimestamp stamp in course.timestamp) {
          DayType d = e.elementAt(stamp.dayOfWeek);
          if (d != DayType.H && d != DayType.B) continue;
          stamps.add(stamp);
        }
      }
      _week.add(WeekTimetable(
        stamps,
        startDate: startDate.add(Duration(days: 7 * prev)),
        weekNo: currentPlan.studyWeeks.indexOf(prev),
      ));
    }

    await put("week.startDate", startDate);
  }

  Future<void> initNotifications() async {
    int lastUpdated = notificationLastUpdated;
    try {
      List<int> newNs =
          (await download<List>("notifications/timestamps")).cast();
      if (lastUpdated >= newNs.first) return;
      for (int n in newNs.take(newNs.indexOf((lastUpdated)))) {
        (await download<List>("notifications/$n"))
            .cast<Map<String, dynamic>>()
            .forEach((e) {
          _notifications.add(Notif.fromJson(e));
        });
      }
    } catch (e) {
      return;
    }
  }

  Future<void> awaitNotificationInitialized() async {
    if (_notificationInitialized) return;
    await Future.delayed(const Duration(seconds: 1), () async {
      await awaitNotificationInitialized();
    });
  }

  String _getCourseID(String id) => RegExp(r'([^.]+)').firstMatch(id)![0]!;

  BaseSubject? getSubjectBase(String id) => _subjects.get(id);
  BaseSubject? getSubjectBaseAlt(String id) =>
      _subjects.values.firstWhereIf((s) => s.subjectAltID == _getCourseID(id));
  Subject? getSubject(String id) => _learning.get(id);
  Subject? getSubjectAlt(String id) =>
      _learning.values.firstWhereIf((s) => s.subjectAltID == _getCourseID(id));
  SubjectCourse? getCourse(String id) =>
      getSubjectAlt(_getCourseID(id))?.getCourse(id);
  String? getTeacher(String id) => _teachers.get(id);
  Iterable<SemesterPlan> get planTable => _plan.values;
  SemesterPlan get currentPlan => _plan.getAt(User().semester.index)!;
  DateTime get planStartDate => fetch("plan.startDate");
  DateTime get semesterStartDate => fetch("week.startDate");

  WeekTimetable getWeek(DateTime startDate) {
    int daysDiff = startDate.difference(semesterStartDate).inDays.abs();
    int week = (daysDiff / 7).floor();
    int startDay = daysDiff % 7;
    List<EventTimestamp> timestamps = [];
    if (week < _week.length) {
      timestamps.addAll(startDay == 0
          ? _week.getAt(week)!.timestamps
          : [
              ..._week
                  .getAt(week)!
                  .timestamps
                  .where((t) => t.dayOfWeek >= startDay),
              if (week + 1 < _week.length)
                ..._week
                    .getAt(week + 1)!
                    .timestamps
                    .where((t) => t.dayOfWeek < startDay)
            ]);
    }
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
      int daysDiff = day.difference(semesterStartDate).inDays;
      int week = (daysDiff / 7).floor();
      int doW = daysDiff % 7;
      while (_week.length < week + 1) {
        _week.add(WeekTimetable(
          [],
          startDate: semesterStartDate.add(Duration(days: 7 * week)),
        ));
      }
      Iterable<EventTimestamp> matchEvents =
          timestamp.where((t) => t.dayOfWeek == doW);
      WeekTimetable targetWeek = _week.getAt(week)!;
      modifier(targetWeek, matchEvents);
    }
  }

  void _overwrite(List<EventTimestamp> timestamp, List<DateTime> days) {
    _modify(
      timestamp,
      days,
      (c, t) => c.setStamps([
        ...c.timestamps.where((i) {
          for (EventTimestamp event in t) {
            if (event.intStamp | i.intStamp != 0) return false;
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
    void add(WeekTimetable w) => w.addStamps(timestamp);
    _week.values.forEach(add);
  }

  Future<void> updateWeekTimetable(EventTimeline event,
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
  }

  Iterable<Reminder> get reminders => _reminders.values;

  int get notificationLastUpdated => fetch("notifications.lastUpdated") ?? 0;
  Iterable<Notif> get notifications => _notifications.values;
  Future<void> clearNotifications() async => await _notifications.clear();
}

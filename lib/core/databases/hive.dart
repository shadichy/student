import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:characters/characters.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:restart_app/restart_app.dart';
import 'package:student/core/databases/study_plan.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/default_configs.dart' as conf;
import 'package:student/core/notification/alarm.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/core/timetable/semester_timetable.dart';
import 'package:student/misc/iterable_extensions.dart';
import 'package:student/misc/misc_functions.dart';

final class Storage {
  Storage._instance();
  static final _storage = Storage._instance();
  factory Storage() {
    return _storage;
  }

  late final Box _env;
  late final Box _generic;
  late final Box<BaseSubject> _subjects;
  late final Box<String> _teachers;
  late final Box<Subject> _learning;
  late final Box<SemesterPlan> _plan;
  late final Box<WeekTimetable> _week;
  late final Box<Reminder> _reminders;
  late final Box<Notif> _notifications;

  bool _notificationInitialized = false;
  late final String _domain;
  late final String _prefix;

  late final int fullStamp;
  final DateTime _now = DateTime.now();
  late final int _weekday = _now.weekday % 7;
  late WeekTimetable _thisWeek;

  late final int _weekStartInt;
  late final List<List<int>> _cList;
  late final Iterable<EventTimestamp> _tList;

  late final dynamic defaultAlarmSound;
  late final dynamic defaultRingtoneSound;
  late final dynamic defaultNotificationSound;

  static const platform = MethodChannel("dev.tlu.student.methods");

  int _getStartStamp(int timestamp) {
    if (timestamp == 0) return -1;
    int classStartsAt = 0;
    while (timestamp & (1 << classStartsAt) == 0) {
      classStartsAt++;
    }
    return classStartsAt;
  }

  int get weekdayStart => fetch<int>("misc.startWeekday")!;

  DateTime get _weekStart => _now.subtract(Duration(
        days: (_weekday - weekdayStart + 7) % 7,
        hours: _now.timeZoneOffset.inHours,
        microseconds: _now.microsecondsSinceEpoch % 86400000000,
      ));
  DateTime get _unshiftedWeekStart => _now.subtract(Duration(
        days: _weekday,
        hours: _now.timeZoneOffset.inHours,
        microseconds: _now.microsecondsSinceEpoch % 86400000000,
      ));

  WeekTimetable get thisWeek => _thisWeek;
  List<EventTimestamp> get upcomingEvents {
    List<EventTimestamp> unsorted = thisWeek.timestamps.where((e) {
      if (e.dayOfWeek != _weekday) return false;
      int current =
          _now.difference(DateTime(_now.year, _now.month, _now.day)).inSeconds;
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
      return e.intStamp & (fullStamp << startAt) != 0;
    }).toList();
    unsorted.sort((a, b) => a.intStamp.compareTo(b.intStamp));
    return unsorted;
  }

  Future<void> register() async {
    await Hive.initFlutter();
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
    if (_generic.isEmpty) await _generic.putAll(conf.defaultConfig);
    _env = await Hive.openBox("env");
    if (_env.isEmpty) await _env.putAll(conf.env);
  }

  Future<void> initialize() async {
    _domain = _env.get("fetchDomain")!;
    _prefix = _env.get("apiPrefix") ?? "";

    await _initBasics();

    _teachers = await Hive.openBox<String>("teachers");
    _subjects = await Hive.openBox<BaseSubject>("subjects");
    _learning = await Hive.openBox<Subject>("courses");
    _plan = await Hive.openBox<SemesterPlan>("plan");
    _week = await Hive.openBox<WeekTimetable>("week");
    _reminders = await Hive.openBox<Reminder>("alarms");
    _notifications = await Hive.openBox<Notif>("notifications");

    await _initTeacher();
    await _initSubjects();
    await _initCourses();
    await _initPlan();
    await _initTimetable();
    await _initReminders();
    _initNotifications().then((_) => _notificationInitialized = true);
    // if (await platform.invokeMethod("getEntrypointName") != "main") return;
    try {
      defaultAlarmSound = await platform.invokeMethod("defaultAlarmSound");
      defaultRingtoneSound =
          await platform.invokeMethod("defaultRingtoneSound");
      defaultNotificationSound =
          await platform.invokeMethod("defaultNotificationSound");
    } catch (e) {
      //   do nothing
    }
  }

  Future<T> download<T>(Uri uri, [Map<String, String>? headers]) async {
    final res = await http.get(uri, headers: headers);

    if (res.statusCode != 200) {
      throw http.ClientException("Failed to fetch from $_domain/$endpoint! ");
    }
    try {
      return jsonDecode(res.body) as T;
    } catch (e) {
      throw FormatException("Failed to parse body from ${uri.toString()}: $e");
    }
  }

  Future<T> endpoint<T>(String endpoint) async => await download<T>(
      Uri.https(_domain, "$_prefix/$endpoint.json"), _env.get("headers"));

  T? fetch<T>(String key) => _generic.get(key) as T?;

  Future<void> put(String key, dynamic value) async =>
      await _generic.put(key, value);

  Future<void> setUser(Map<String, dynamic> value) async =>
      await put("user", value);

  Map<String, dynamic>? getUser() => fetch<Map<dynamic, dynamic>>("user")
      ?.map((key, value) => MapEntry(key.toString(), value));

  Future<void> setEnv<T>(String key, T value) async =>
      await _env.put(key, value);

  Future<void> _initBasics() async {
    Map<String, dynamic>? basics = fetch<Map<dynamic, dynamic>>("basics")
        ?.map((key, value) => MapEntry(key.toString(), value));
    if (basics != null) return SPBasics().setBasics(basics);
    basics = await endpoint<Map<String, dynamic>>("basics");
    await put("basics", basics);
    SPBasics().setBasics(basics);
  }

  Future<void> _initTeacher() async {
    if (_teachers.isNotEmpty) return;
    await _teachers.putAll(
      await endpoint<Map<String, dynamic>>("teachers").then(
        (map) => map.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      ),
    );
  }

  Future<void> _initSubjects() async {
    if (_subjects.isNotEmpty) return;
    await _subjects.putAll(
      (await endpoint<Map<String, dynamic>>("${User().group.name}/subjects"))
          .map(
        (k, v) =>
            MapEntry(k, BaseSubject.fromJson(v as Map<String, dynamic>, k)),
      ),
    );
  }

  Future<void> _initPlan() async {
    DateTime? startDate = fetch("plan.startDate");
    if (planTable.isNotEmpty && startDate != null) return;

    Map<String, dynamic> parsedInfo =
        await endpoint("${User().group.name}/study_plan");

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
        semester: prev - 1,
        timetableInt: chunkedWeek,
        studyWeeks: studyWeek,
        startDate: MiscFns.epoch(startDate),
      ));
    });

    await put("plan.startDate", startDate);
  }

  Future<void> _initCourses() async {
    if (_learning.isNotEmpty) return;
    (await endpoint<Map<String, dynamic>>(
            "${User().group.name}/${User().semester.name}/semester"))
        .forEach((k, v) async {
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
    });
  }

  Future<void> _initTimetable() async {
    DateTime? startDate = fetch("week.startDate");
    await _week.clear();
    if (_week.isNotEmpty && startDate != null) return;

    SemesterPlan plan = currentPlan;
    startDate = plan.startDate;

    List<SubjectCourse> registeredCourses = [];
    // why is _learning empty?
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
      prev++;
    }

    await put("week.startDate", startDate);
  }

  Future<void> _initReminders() async {
    await _reminderFirstRun();
    await Alarm.init();
    fullStamp = (-1).toUnsigned(SPBasics().classTimestamps.length);

    _thisWeek = getWeek(_weekStart);
    _weekStartInt = _unshiftedWeekStart.millisecondsSinceEpoch ~/ 1000;
    _cList = SPBasics().classTimestamps;
    _tList = getWeek(_unshiftedWeekStart).timestamps.where((e) {
      return e.dayOfWeek % 7 >= _weekday;
    });
    for (Reminder r in reminders) {
      reminderUpdate(r);
    }
  }

  Future<void> _reminderFirstRun() async {
    if (fetch<bool>("alarm.firstRun") == true) return;
    _reminders.addAll((conf.defaultConfig['notif.reminders'] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => Reminder.fromJson(e)));
    await put("alarm.firstRun", true);
  }

  Future<void> reminderUpdate(Reminder reminder) async {
    if (reminder.disabled) return;
    String left = MiscFns.durationLeft(reminder.duration);
    int rId = _weekStartInt - reminder.duration.inSeconds;
    for (EventTimestamp t in _tList) {
      if (t.intStamp == 0) continue;
      int id = rId +
          86400 * (t.dayOfWeek % 7) +
          _cList[_getStartStamp(t.intStamp)][0];

      if (id < _now.millisecondsSinceEpoch ~/ 1000) {
        if (Alarm.getAlarm(id) != null) await Alarm.stop(id);
        continue;
      }

      if (Alarm.getAlarm(id) != null) continue;
      await Alarm.set(
          alarmSettings: AlarmSettings(
        id: id,
        dateTime: MiscFns.epoch(id),
        assetAudioPath: reminder.audio ?? "",
        notificationTitle: "${t.location} \u2022 $left \u2022 ${t.eventName}",
        notificationBody: "${t.eventName} will be started in $left!",
        vibrate: reminder.vibrate,
      ));
    }
  }

  Future<void> reminderRemove(int index) async {
    Reminder? reminder = _reminders.getAt(index);
    if (reminder == null || reminder.disabled) return;
    for (EventTimestamp t in _tList) {
      if (t.intStamp == 0) continue;
      int id = _weekStartInt -
          reminder.duration.inSeconds +
          86400 * (t.dayOfWeek % 7) +
          _cList[_getStartStamp(t.intStamp)][0];
      if (Alarm.getAlarm(id) != null) await Alarm.stop(id);
    }
    _reminders.deleteAt(index);
  }

  Future<void> _initNotifications() async {
    int lastUpdated = notificationLastUpdated;
    try {
      List<int> newNs =
          (await endpoint<List>("notifications/timestamps")).cast();
      if (lastUpdated >= newNs.first) return;
      for (int n in newNs.take(newNs.indexOf((lastUpdated)))) {
        (await endpoint<List>("notifications/$n"))
            .cast<Map<String, dynamic>>()
            .forEach((e) async {
          Notif notif = Notif.fromJson(e);
          if (notif.applyEvent != null) await notif.apply();
          _notifications.add(notif);
        });
      }
      put("notifications.lastUpdated", newNs.first);
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

  Future<void> clear() async {
    await _env.clear();
    await _generic.clear();
    await _subjects.clear();
    await _teachers.clear();
    await _learning.clear();
    await _plan.clear();
    await _week.clear();
    await _reminders.clear();
    await _notifications.clear();
    await Alarm.stopAll();
    await Restart.restartApp();
  }

  Map<String, dynamic> get env =>
      _env.toMap().map((key, value) => MapEntry(key.toString(), value));

  String _getCourseID(String id) => RegExp(r'([^.]+)').firstMatch(id)![0]!;

  BaseSubject? getSubjectBase(String id) => _subjects.get(id);
  BaseSubject? getSubjectBaseAlt(String id) =>
      _subjects.values.firstWhereIf((s) => s.subjectAltID == _getCourseID(id));
  Subject? getSubject(String id) => _learning.get(id);
  Subject? getSubjectAlt(String id) =>
      _learning.values.firstWhereIf((s) => s.subjectAltID == _getCourseID(id));
  SubjectCourse? getCourse(String id) => getSubjectAlt(id)?.courses[id];
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
  Future<void> addReminder(Reminder reminder) async {
    await reminderUpdate(reminder);
    await _reminders.add(reminder);
  }

  int get notificationLastUpdated => fetch("notifications.lastUpdated") ?? 0;
  Iterable<Notif> get notifications => _notifications.values;
  Future<void> clearNotifications() async => await _notifications.clear();
}

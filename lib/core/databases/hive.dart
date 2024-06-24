import 'dart:convert';

import 'package:characters/characters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:restart_app/restart_app.dart';
import 'package:student/core/databases/study_plan.dart';
import 'package:student/core/databases/study_program_basics.dart';
import 'package:student/core/databases/subject.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/default_configs.dart' as conf;
import 'package:student/core/notification/alarm.dart';
import 'package:student/core/notification/model/alarm_settings.dart';
import 'package:student/core/notification/notification.dart';
import 'package:student/core/notification/reminder.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/core/timetable/semester_timetable.dart';
import 'package:student/misc/iterable_extensions.dart';
import 'package:student/misc/misc_functions.dart';
import 'package:student/ui/connect.dart';
import 'package:student/ui/pages/subject/stamp_intent.dart';

final class _Boxes {
  final base = "base";
  final env = "env";
  final intent = "intent";
  final teachers = "teachers";
  final subjects = "subjects";
  final courses = "courses";
  final plan = "plan";
  final week = "week";
  final alarms = "alarms";
  final reminders = "reminders";
  final notifications = "notifications";
}

final class _Vars {
  final user = "user";
  final basics = "basics";
  final planStartDate = "plan.startDate";
  final weekStartDate = "week.startDate";
  final alarmFirstRun = "alarm.firstRun";
  final notificationsLastUpdated = "notifications.lastUpdated";
  final alarmNTitle = "alarmNTitle";
  final alarmNBody = "alarmNBody";
}

final class Storage {
  Storage._();

  static final _storage = Storage._();
  factory Storage() {
    return _storage;
  }

  static final _boxes = _Boxes();
  static final _vars = _Vars();

  late final Box _env;
  late final Box _generic;
  late final Box _intent;
  late final Box<BaseSubject> _subjects;
  late final Box<String> _teachers;
  late final Box<Subject> _learning;
  late final Box<SemesterPlan> _plan;
  late final Box<WeekTimetable> _week;
  late final Box<AlarmSettings> _alarms;
  late final Box<Reminder> _reminders;
  late final Box<Notif> _notifications;

  bool _notificationInitialized = false;
  late final String _domain;
  late final String _prefix;

  late final int _fullStamp;
  final DateTime _now = DateTime.now();
  late final int _weekday = _now.weekday % 7;
  late WeekTimetable _thisWeek;

  late final int _weekStartInt;
  late final List<List<int>> _cList;
  late final Iterable<EventTimestamp> _tList;

  // late final dynamic defaultAlarmSound;
  // late final dynamic defaultRingtoneSound;
  // late final dynamic defaultNotificationSound;
  // late final RootIsolateToken token;

  static const platform = StudentApp.methodChannel;
  bool _initialized = false;

  bool get initialized => _initialized;

  int get weekdayStart => fetch<int>(conf.Config.misc.startWeekday)!;

  late final DateTime _dayStart = _now.subtract(Duration(
    hours: _now.hour,
    microseconds: _now.microsecondsSinceEpoch % 3600000000,
  ));

  DateTime get _weekStart =>
      _dayStart.subtract(Duration(days: (_weekday - weekdayStart + 7) % 7));

  DateTime get _unshiftedWeekStart =>
      _dayStart.subtract(Duration(days: _weekday));

  WeekTimetable get thisWeek => _thisWeek;
  List<EventTimestamp> get upcomingEvents {
    List<EventTimestamp> unsorted = thisWeek.timestamps.where((e) {
      if (e.dayOfWeek != _weekday) return false;
      int current =
          _now.difference(DateTime(_now.year, _now.month, _now.day)).inSeconds;
      if (current > _cList[_cList.length - 1][1]) return false;
      int startAt = 0;
      while (current > _cList[startAt][0]) {
        startAt++;
        if (startAt == _cList.length) break;
      }
      if (startAt > 0) startAt--;
      return e.intStamp & (_fullStamp << startAt) != 0;
    }).toList();
    unsorted.sort((a, b) => a.intStamp.compareTo(b.intStamp));
    return unsorted;
  }

  Future<void> register() async {
    // this.token = token;
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
    Hive.registerAdapter(AlarmSettingsAdapter());
    Hive.registerAdapter(ReminderAdapter());
    Hive.registerAdapter(NotifAdapter());

    _generic = await Hive.openBox(_boxes.base);
    if (_generic.isEmpty) await _generic.putAll(conf.defaultConfig);
    _env = await Hive.openBox(_boxes.env);
    if (_env.isEmpty) await _env.putAll(conf.env);
    _intent = await Hive.openBox(_boxes.intent);
  }

  Future<void> initializeAlarm() async {
    _alarms = await Hive.openBox<AlarmSettings>(_boxes.alarms);

    for (var alarm in alarms) {
      var dateTime = alarm.dateTime;
      if ((alarm.id >> (SPBasics().classTimestamps.length + 3) == 0
              ? dateTime.add(alarm.timeout)
              : dateTime)
          .isBefore(_now)) {
        await alarm.delete();
      }
    }
  }

  Future<void> initializeMinimal() async {
    _initialized = true;
    await _initBasics();

    _teachers = await Hive.openBox<String>(_boxes.teachers);
    _subjects = await Hive.openBox<BaseSubject>(_boxes.subjects);
    _learning = await Hive.openBox<Subject>(_boxes.courses);
    _plan = await Hive.openBox<SemesterPlan>(_boxes.plan);
    _week = await Hive.openBox<WeekTimetable>(_boxes.week);
    await initializeAlarm();

    // always return if first init has been done
    await _initTeacher();
    await _initSubjects();
    await _initCourses();
    await _initPlan();
    await _initTimetable();
    await _initBaseFields();
  }

  Future<void> initialize() async {
    _domain = _env.get(conf.Config.env.fetchDomain)!;
    _prefix = _env.get(conf.Config.env.apiPrefix) ?? "";

    await initializeMinimal();

    _reminders = await Hive.openBox<Reminder>(_boxes.reminders);
    _notifications = await Hive.openBox<Notif>(_boxes.notifications);

    await _initReminders();
    _initNotifications().then((_) => _notificationInitialized = true);
    // defaultAlarmSound = await platform.invokeMethod("defaultAlarmSound");
    // defaultRingtoneSound = await platform.invokeMethod("defaultRingtoneSound");
    // defaultNotificationSound =
    //     await platform.invokeMethod("defaultNotificationSound");
    // alarmPrint("Done Hive init");
  }

  Future<Map> initializeIntent() async {
    await Hive.initFlutter();
    _intent = await Hive.openBox(_boxes.intent);
    return _intent.toMap();
  }

  Future<T> download<T>(
    Uri uri, {
    Map<String, String>? headers,
    int? retry,
  }) async {
    int retries = retry ?? fetch<int>(conf.Config.misc.maxDlRetries) ?? 5;
    Exception? exception;
    final res = await http.get(uri, headers: headers);

    if (res.statusCode != 200) {
      exception = http.ClientException(
        "Failed to fetch from $_domain/$endpoint! ",
      );
    }
    try {
      return jsonDecode(res.body) as T;
    } catch (e) {
      exception = FormatException(
        "Failed to parse body from ${uri.toString()}: $e",
      );
    }
    if (retries <= 0) {
      throw exception;
    } else {
      return await Future.delayed(
        Duration(
          seconds: fetch<int>(conf.Config.misc.dlRetryInterval) ?? 120,
        ),
        () async => await download(uri, headers: headers, retry: retries - 1),
      );
      // return await download(uri, headers: headers, retry: retries - 1);
    }
  }

  Future<T> endpoint<T>(String endpoint) async =>
      await download<T>(Uri.https(_domain, "$_prefix/$endpoint.json"),
          headers: _env.get(conf.Config.env.headers));

  T? fetch<T>(String key) => _generic.get(key) as T?;

  Future<void> put(String key, dynamic value) async =>
      await _generic.put(key, value);

  Future<void> setUser(Map<String, dynamic> value) async =>
      await put(_vars.user, value);

  Map<String, dynamic>? getUser() => fetch<Map<dynamic, dynamic>>(_vars.user)
      ?.map((key, value) => MapEntry(key.toString(), value));

  Future<void> setEnv<T>(String key, T value) async =>
      await _env.put(key, value);

  Future<void> _initBasics() async {
    Map<String, dynamic>? basics = fetch<Map<dynamic, dynamic>>(_vars.basics)
        ?.map((key, value) => MapEntry(key.toString(), value));
    if (basics != null) return SPBasics().setBasics(basics);
    basics = await endpoint<Map<String, dynamic>>(_vars.basics);
    await put(_vars.basics, basics);
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
    DateTime? startDate = fetch(_vars.planStartDate);
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

    await put(_vars.planStartDate, startDate);
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
        // alarmPrint(e.toString());
        // alarmPrint(s.toString());
      }
    });
  }

  Future<void> _initTimetable() async {
    DateTime? startDate = fetch(_vars.weekStartDate);
    if (_week.isNotEmpty && startDate != null) return;

    SemesterPlan plan = currentPlan;
    startDate = plan.startDate;

    List<SubjectCourse> registeredCourses = [];
    for (var id
        in User().learningCourses[SPBasics().currentYear - User().schoolYear]
            [User().semester]!) {
      try {
        registeredCourses.add(getCourse(id)!);
      } catch (e) {
        // alarmPrint(e.toString());
        // alarmPrint(s.toString());
        // invalid course
      }
    }

    int prev = 0;

    for (var e in plan.timetable) {
      List<CourseTimestamp> stamps = [];
      for (var course in registeredCourses) {
        for (var stamp in course.timestamp) {
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

    await put(_vars.weekStartDate, startDate);
  }

  Future<void> _initBaseFields() async {
    _thisWeek = getWeek(_weekStart);
    _weekStartInt = _unshiftedWeekStart.millisecondsSinceEpoch ~/ 1000;
    _cList = SPBasics().classTimestamps;
    _tList = getWeek(_unshiftedWeekStart).timestamps.where((e) {
      return e.dayOfWeek % 7 >= _weekday;
    });
  }

  Future<void> _initReminders() async {
    await _reminderFirstRun();
    await Alarm.init();
    // Isolate.spawn((t) => _pendingAlarm(t), token);
    _fullStamp = EventTimestamp.maxStamp;

    for (var r in reminders) {
      reminderUpdate(r);
    }
  }

  Future<void> _reminderFirstRun() async {
    if (fetch<bool>(_vars.alarmFirstRun) == true) return;
    _reminders.putAll(Map.fromEntries(
      (conf.defaultConfig[conf.Config.notif.reminders] as List).map((e) {
        var r = Reminder.fromJson(e as Map<String, dynamic>);
        return MapEntry<int, Reminder>(r.scheduleDuration.inMinutes, r);
      }),
    ));
    await put(_vars.alarmFirstRun, true);
  }

  Future<void> reminderUpdate(Reminder reminder,
      [List<EventTimestamp>? events]) async {
    if (reminder.disabled) return;
    String left = MiscFns.durationLeft(reminder.scheduleDuration);
    int rTime = _weekStartInt - reminder.scheduleDuration.inSeconds;
    for (var t in events ?? _tList) {
      if (t.intStamp == 0) continue;
      DateTime time = MiscFns.epoch(
          rTime + 86400 * (t.dayOfWeek % 7) + _cList[t.startStamp][0]);
      int id = (reminder.scheduleDuration.inMinutes << (_cList.length + 3)) |
          (t.dayOfWeek << _cList.length) |
          t.intStamp;

      if (time.add(reminder.ringDuration).isBefore(_now)) {
        if (getAlarm(id) != null) await Alarm.stop(id);
        continue;
      }

      if (getAlarm(id) != null) continue;
      await Alarm.set(AlarmSettings(
        id: id,
        dateTime: time,
        timeout: reminder.ringDuration.inMinutes != 0
            ? reminder.ringDuration
            : Duration(hours: t.stampLength),
        audio: reminder.audio,
        title: "${t.location} \u2022 $left \u2022 ${t.eventName}",
        body: "${t.eventName} will be started in $left!",
        vibrate: reminder.vibrate,
      ));
      await _intent.put(id, {
        AlarmApp.seedColor: fetch<int>(conf.Config.theme.accentColor),
        AlarmApp.font: fetch<String>(conf.Config.theme.appFont),
        AlarmApp.themeMode: fetch<int>(conf.Config.theme.themeMode),
        AlarmApp.eventTitle: t is CourseTimestamp
            ? getSubjectBaseAlt(t.eventName)?.name ??
                getSubjectAlt(t.eventName)?.name ??
                t.eventName
            : t.eventName,
        AlarmApp.eventSubtitle: t is CourseTimestamp ? t.eventName : "",
        AlarmApp.startTime: MiscFns.timeFormat(time),
        AlarmApp.location: t.location,
        AlarmApp.id: id,
      });
    }
  }

  Future<void> reminderRemove(int key, [List<EventTimestamp>? events]) async {
    Reminder? reminder = _reminders.get(key);
    if (reminder == null || reminder.disabled) return;
    for (var t in events ?? _tList) {
      if (t.intStamp == 0) continue;
      int id = (reminder.scheduleDuration.inMinutes << (_cList.length + 3)) |
          (t.dayOfWeek << _cList.length) |
          t.intStamp;
      if (getAlarm(id) != null) await Alarm.stop(id);
    }
    reminder.delete();
  }

  Future<void> reminderUpdateForEvent(EventTimestamp event) async {
    for (var r in reminders) {
      reminderUpdate(r, [event]);
    }
  }

  Future<void> reminderRemoveForEvent(EventTimestamp event) async {
    for (var k in _reminders.keys) {
      reminderRemove(k as int, [event]);
    }
  }

  Future<void> _initNotifications() async {
    int lastUpdated = notificationLastUpdated;
    try {
      List<int> newNs =
          (await endpoint<List>("notifications/timestamps")).cast();
      if (lastUpdated >= newNs.first) return;
      for (var n in newNs.take(newNs.indexOf((lastUpdated)))) {
        (await endpoint<List>("notifications/$n"))
            .cast<Map<String, dynamic>>()
            .forEach((e) async {
          Notif notif = Notif.fromJson(e);
          if (notif.applyEvent != null) await notif.apply();
          _notifications.add(notif);
        });
      }
      put(_vars.notificationsLastUpdated, newNs.first);
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
    await _alarms.clear();
    await Restart.restartApp();
  }

  Map<String, dynamic> get env =>
      _env.toMap().map((key, value) => MapEntry(key.toString(), value));

  String _getCourseID(String id) => RegExp(r'([^.]+)').firstMatch(id)![0]!;

  Iterable<BaseSubject> get baseSubjects => _subjects.values;

  Iterable<Subject> get subjects => _learning.values;
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

  DateTime get planStartDate => fetch(_vars.planStartDate);

  DateTime get semesterStartDate => fetch(_vars.weekStartDate);

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
    for (var day in days) {
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
          for (var event in t) {
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

  Map<int, Reminder> get remindersMap => _reminders.toMap().cast();

  Future<void> reminderAdd(
    Reminder reminder, [
    List<EventTimestamp>? events,
  ]) async {
    await reminderUpdate(reminder, events);
    await _reminders.put(reminder.scheduleDuration.inMinutes, reminder);
    var prevReminder = remindersMap.keys.lastWhereIf(
      (e) => e > reminder.scheduleDuration.inMinutes,
    );
    if (prevReminder == null) return;
    await _reminders.get(prevReminder)?.edit(
          ringDuration: reminder.scheduleDuration.inMinutes - prevReminder,
        );
  }

  Iterable<AlarmSettings> get alarms => _alarms.values;

  AlarmSettings? getAlarm(int id) => _alarms.get(id);

  Future<void> addAlarm(AlarmSettings alarm) async =>
      await _alarms.put(alarm.id, alarm);

  Future<void> removeAlarm(int id) async {
    await _alarms.delete(id);
    await _intent.delete(id);
  }

  bool get hasAlarm => _alarms.isNotEmpty;

  Future<void> setNotificationContentOnAppKill(
    String title,
    String body,
  ) async {
    await put(_vars.alarmNTitle, title);
    await put(_vars.alarmNBody, body);
  }

  String getNotificationOnAppKillTitle() =>
      fetch(_vars.alarmNTitle) ?? 'Your alarms may not ring';

  String getNotificationOnAppKillBody() =>
      fetch(_vars.alarmNBody) ??
      'You killed the app. Please reopen so your alarms can be rescheduled.';

  int get notificationLastUpdated => fetch(_vars.notificationsLastUpdated) ?? 0;
  Iterable<Notif> get notifications => _notifications.values;
  Future<void> clearNotifications() async => await _notifications.clear();
}

// Future<void> _pendingAlarm(RootIsolateToken token) async {
//   BackgroundIsolateBinaryMessenger.ensureInitialized(token);
//   Hive.init((await getApplicationDocumentsDirectory()).path);
//   Hive.registerAdapter(AlarmSettingsAdapter());
//   await Storage().initializeAlarm();
//   var now = DateTime.now();
//   var alarms = Storage().alarms.where((a) => a.dateTime.isAfter(now)).toList();
//   if (alarms.isEmpty) {
//     Isolate.current.kill(priority: Isolate.immediate);
//     return;
//   }
//   alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
//   var first = alarms.first;
//   // await Alarm.stopAll();
//   await Alarm.set(first, alarms);
//   await Storage().removeAlarm(first.id);
//   await Future.delayed(
//     first.dateTime.add(Duration(minutes: 1)).difference(DateTime.now()),
//     () async {
//       Isolate.spawn((t) => _pendingAlarm(t), token);
//     },
//   );
//   Isolate.current.kill(priority: Isolate.beforeNextEvent);
// }

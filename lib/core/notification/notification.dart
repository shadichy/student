// get notifications

import 'dart:async';

import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/core/timetable/semester_timetable.dart';
import 'package:student/misc/misc_functions.dart';

class Notif {
  final String title;
  final String content;
  final DateTime? uploadDate;
  final EventTimeline? applyEvent;
  final List<DateTime>? applyDates;
  final UserGroup? applyGroup;
  final UserSemester? applySemester;
  final bool? override;
  bool? applied;
  bool read;
  Notif(
    this.title, {
    required this.content,
    this.uploadDate,
    this.applyEvent,
    this.applyDates,
    this.applyGroup,
    this.applySemester,
    this.override,
    bool? applied,
    this.read = false,
  }) : applied = applyEvent != null ? applied ?? false : null;

  Notif.fromJson(Map<String, dynamic> map)
      : this(
          map["title"] as String,
          content: map["content"] as String,
          uploadDate: map["uploadDate"] == null
              ? null
              : MiscFns.epoch(map["uploadDate"] as int),
          applyEvent: map["applyEvent"] == null
              ? null
              : map["applyEvent"]["courseID"] is String
                  ? SubjectCourse.fromJson(map["applyEvent"])
                  : SchoolEvent(
                      label: map["applyEvent"]["label"] as String,
                      timestamp: MiscFns.list<Map<String, dynamic>>(
                              map["applyEvent"]["timestamp"] as List)
                          .map((e) => EventTimestamp.fromJson(e))
                          .toList(),
                      days: map["applyDates"],
                    ),
          applyDates: map["applyDates"] == null
              ? null
              : MiscFns.list<int>(map["applyDates"] as List)
                  .map((e) => MiscFns.epoch(e))
                  .toList(),
          applyGroup: map["applyGroup"] == null
              ? null
              : UserGroup.values[map["applyGroup"] as int],
          applySemester: map["applySemester"] == null
              ? null
              : UserSemester.values[map["applySemester"] as int],
          override: map["override"] as bool?,
          applied: map["applied"] as bool?,
          read: (map["read"] ?? false) as bool,
        );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'uploadDate': uploadDate == null
            ? null
            : uploadDate!.millisecondsSinceEpoch ~/ 1000,
        'applyEvent': applyEvent,
        'applyDates': applyDates?.map((d) => d.millisecondsSinceEpoch ~/ 1000),
        'applyGroup': applyGroup?.index,
        'applySemester': applySemester?.index,
        'override': override,
        'applied': applied,
        'read': read,
      };

  void apply() {
    if (applied == true) return;
    if (applyEvent == null ||
        applyGroup != User().group ||
        applySemester != User().semester) {
      applied = true;
      return;
    }
    SemesterTimetable().update(
      applyEvent!,
      override: override ?? false,
      days: applyDates,
    );
    applied = true;
  }

  void readNotif() {
    read = true;
  }
}

final class NotificationsGet {
  NotificationsGet._instance();
  static final _notifInstance = NotificationsGet._instance();
  factory NotificationsGet() {
    return _notifInstance;
  }

  bool _initialized = false;

  late final List<Notif> _notifications;
  List<Notif> get notifications => _notifications;
  late final int _lastUpdated;

  Future<void> awaitInitialized() async {
    if (_initialized) return;
    await Future.delayed(const Duration(seconds: 1), () async {
      await awaitInitialized();
    });
  }

  Notif _parseMap(Map<String, dynamic> map) {
    Notif notif = Notif.fromJson(map);
    if (notif.applied == false) notif.apply();
    return notif;
  }

  Future<void> write() async {
    await SharedPrefs.setString(
      "notifications",
      {
        'lastUpdated': _lastUpdated,
        'data': _notifications,
      },
    );
  }

  Future<void> initialize() async {
    Map<String, dynamic> parsedInfo =
        (await Server.getString("notifications")) ?? {};

    // _lastUpdated = parsedInfo["lastUpdated"];

    MapEntry<int, List<Iterable<Map<String, dynamic>>>> updated =
        await Server.getNotifications(
      ((parsedInfo["lastUpdated"] ?? 0) as int),
    );

    _notifications = updated.value
        .map((v) => v.map((e) => _parseMap(e)))
        .fold(
          MiscFns.list<Map<String, dynamic>>(
            (parsedInfo["data"] ?? []) as List,
          ).map((e) => _parseMap(e)),
          (p, n) => [...p, ...n],
        )
        .toList();
    _lastUpdated = updated.key;

    // _teachers = parsedInfo;
    _initialized = true;
    await write();
  }
}

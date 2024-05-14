// get notifications

import 'dart:convert';

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
  final TLUGroup? applyGroup;
  final TLUSemester? applySemester;
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
                      timestamp: MiscFns.listType<Map<String, dynamic>>(
                              map["applyEvent"]["timestamp"] as List)
                          .map((e) => EventTimestamp.fromJson(e))
                          .toList(),
                      days: map["applyDates"],
                    ),
          applyDates: map["applyDates"] == null
              ? null
              : MiscFns.listType<int>(map["applyDates"] as List)
                  .map((e) => MiscFns.epoch(e))
                  .toList(),
          applyGroup: map["applyGroup"] == null
              ? null
              : TLUGroup.values[map["applyGroup"] as int],
          applySemester: map["applySemester"] == null
              ? null
              : TLUSemester.values[map["applySemester"] as int],
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
        'applyDates': applyDates?.map((_) => _.millisecondsSinceEpoch ~/ 1000),
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

  late final List<Notif> _notifications;
  List<Notif> get notifications => _notifications;
  late final int _lastUpdated;

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
        SharedPrefs.getString("notifications", {})!;

    // _lastUpdated = parsedInfo["lastUpdated"];

    MapEntry<int, List<Iterable<Map<String, dynamic>>>> updated =
        await Server.getNotifications(
      ((parsedInfo["lastUpdated"] ?? 0) as int),
    );

    _notifications = updated.value
        .map((_) => _.map((e) => _parseMap(e)))
        .fold(
          MiscFns.listType<Map<String, dynamic>>(
            (parsedInfo["data"] ?? []) as List,
          ).map((e) => _parseMap(e)),
          (p, n) => [...p, ...n],
        )
        .toList();
    _lastUpdated = updated.key;

    // _teachers = parsedInfo;
    await write();
  }
}

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
          override: map["override"] == null ? null : map["override"] as bool,
          applied: map["applied"] == null ? null : map["applied"] as bool,
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
      };

  void apply() {
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
  late final DateTime _lastUpdated;

  Notif _parseString(String string) => _parseMap(jsonDecode(string));

  Notif _parseMap(Map<String, dynamic> map) => Notif.fromJson(map);

  Future<void> _write() async {
    await SharedPrefs.setString(
      "notifications",
      jsonEncode({
        'lastUpdated': _lastUpdated,
        'data': _notifications,
      }),
    );
  }

  Future<void> initialize() async {
    String rawInfo = SharedPrefs.getString("notifications") ?? "{}";
    // if (rawInfo is! String) {
    //   rawInfo = await Server.getNotifications(0);
    //   await SharedPrefs.setString("notifications", rawInfo);
    // }

    Map<String, dynamic> parsedInfo = {};

    try {
      parsedInfo = (jsonDecode(rawInfo) as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as String));
    } catch (e) {
      throw Exception("Failed to parse teachers info JSON from cache! $e");
    }

    // _lastUpdated = parsedInfo["lastUpdated"];

    MapEntry<int, List<String>> updated = await Server.getNotifications(
        MiscFns.epoch((parsedInfo["lastUpdated"] == null
            ? 0
            : parsedInfo["lastUpdated"] as int)));

    _notifications = [
      ...MiscFns.listType<Map<String, dynamic>>(parsedInfo["data"] as List)
          .map((e) => _parseMap(e)),
      ...updated.value.map((e) => _parseString(e))
    ];
    _lastUpdated = MiscFns.epoch(updated.key);

    // _teachers = parsedInfo;
    await _write();
  }
}

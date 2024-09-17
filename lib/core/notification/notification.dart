// get notifications

import 'dart:async';

import 'package:hive/hive.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/databases/user.dart';
import 'package:student/core/semester/functions.dart';
import 'package:student/misc/misc_functions.dart';

part 'notification.g.dart';

@HiveType(typeId: 7)
class NotificationInstance extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final DateTime? uploadDate;
  @HiveField(3)
  final EventTimeline? applyEvent;
  @HiveField(4)
  final List<DateTime>? applyDates;
  @HiveField(5)
  final int? applyGroupInt;
  final UserGroup? applyGroup;
  @HiveField(6)
  final int? applySemesterInt;
  final UserSemester? applySemester;
  @HiveField(7)
  final bool? override;
  @HiveField(8)
  bool? isApplied;
  @HiveField(9)
  bool isRead;

  NotificationInstance(
    this.title, {
    required this.content,
    this.uploadDate,
    this.applyEvent,
    this.applyDates,
    this.applyGroupInt,
    this.applySemesterInt,
    this.override,
    bool? isApplied,
    this.isRead = false,
  })  : isApplied = applyEvent != null ? isApplied ?? false : null,
        applyGroup =
            applyGroupInt == null ? null : UserGroup.values[applyGroupInt],
        applySemester = applySemesterInt == null
            ? null
            : UserSemester.values[applySemesterInt];

  NotificationInstance.fromJson(Map<String, dynamic> map)
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
          applyGroupInt: map["applyGroup"] as int?,
          applySemesterInt: map["applySemester"] as int?,
          override: map["override"] as bool?,
          isApplied: map["isApplied"] as bool?,
          isRead: (map["isRead"] ?? false) as bool,
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
        'isApplied': isApplied,
        'isRead': isRead,
      };

  Future<void> apply() async {
    if (isApplied == true) return await save();
    if (applyEvent == null ||
        applyGroup != User().group ||
        applySemester != User().semester) {
      isApplied = true;
      return await save();
    }
    await Storage().updateWeekTimetable(
      applyEvent!,
      override: override ?? false,
      days: applyDates,
    );
    isApplied = true;
    await save();
  }

  Future<void> unapply() async {}

  Future<void> read() async {
    isRead = true;
    await save();
  }

  Future<void> unread() async {
    isRead = false;
    await save();
  }
}

// @Deprecated("moving to Hive")
// final class NotificationsGet {
//   NotificationsGet._instance();
//   static final _notifInstance = NotificationsGet._instance();
//   factory NotificationsGet() {
//     return _notifInstance;
//   }
//
//   bool _initialized = false;
//
//   late final List<Notif> _notifications;
//   List<Notif> get notifications => _notifications;
//   late final int _lastUpdated;
//
//   Future<void> awaitInitialized() async {
//     if (_initialized) return;
//     await Future.delayed(const Duration(seconds: 1), () async {
//       await awaitInitialized();
//     });
//   }
//
//   Notif _parseMap(Map<String, dynamic> map) {
//     Notif notif = Notif.fromJson(map);
//     if (notif.applied == false) notif.apply();
//     return notif;
//   }
//
//   Future<void> write() async {
//     await SharedPrefs.setString(
//       "notifications",
//       {
//         'lastUpdated': _lastUpdated,
//         'data': _notifications,
//       },
//     );
//   }
//
//   Future<void> initialize() async {
//     Map<String, dynamic> parsedInfo =
//         (await Server.getString("notifications")) ?? {};
//
//     // _lastUpdated = parsedInfo["lastUpdated"];
//
//     MapEntry<int, List<Iterable<Map<String, dynamic>>>> updated =
//         await Server.getNotifications(
//       ((parsedInfo["lastUpdated"] ?? 0) as int),
//     );
//
//     _notifications = updated.value
//         .map((v) => v.map((e) => _parseMap(e)))
//         .fold(
//           MiscFns.list<Map<String, dynamic>>(
//             (parsedInfo["data"] ?? []) as List,
//           ).map((e) => _parseMap(e)),
//           (p, n) => [...p, ...n],
//         )
//         .toList();
//     _lastUpdated = updated.key;
//
//     // _teachers = parsedInfo;
//     _initialized = true;
//     await write();
//   }
// }

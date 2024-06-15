import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/misc/iterable_extensions.dart';

part 'reminder.g.reserved.dart';

enum AlarmMode { follow, silent, custom }

@HiveType(typeId: 6)
class Reminder extends HiveObject {
  @HiveField(0)
  Duration _scheduleDuration;
  @HiveField(1)
  bool _disabled;
  @HiveField(2)
  bool _vibrate;
  @HiveField(3)
  int _alarmMode;
  AlarmMode _mode;
  @HiveField(4)
  String? _audio;
  @HiveField(5)
  Duration _ringDuration;

  Duration get scheduleDuration => _scheduleDuration;
  Duration get ringDuration => _ringDuration;
  bool get disabled => _disabled;
  bool get vibrate => _vibrate;
  AlarmMode get alarmMode => _mode;
  int get alarmModeInt => _alarmMode;
  String? get audio => _audio;

  Reminder(
    int scheduleDuration, {
    int? ringDuration,
    bool? disabled,
    bool? vibrate,
    int? alarmMode,
    String? audio,
  })  : _scheduleDuration = Duration(minutes: scheduleDuration),
        _ringDuration = Duration(
            minutes: ringDuration ??
                (scheduleDuration == 0
                    ? 0
                    : Storage()
                            .remindersMap
                            .keys
                            .firstWhereIf((e) => e > scheduleDuration) ??
                        15)),
        _alarmMode = alarmMode ?? 0,
        _mode = AlarmMode.values[alarmMode ?? 0],
        _disabled = disabled ?? false,
        _vibrate = vibrate ?? alarmMode == AlarmMode.follow.index
            ? scheduleDuration == 0
            : false,
        _audio = audio;

  Reminder.fromJson(Map<String, dynamic> data)
      : this(
          data["scheduleDuration"] as int,
          ringDuration: data["ringDuration"] as int?,
          disabled: data["disabled"] as bool?,
          vibrate: data["vibrate"] as bool?,
          alarmMode: data["alarmMode"] as int?,
          audio: data["audio"] as String?,
        );

  Future<void> edit({
    int? scheduleDuration,
    int? ringDuration,
    bool? disabled,
    bool? vibrate,
    int? alarmMode,
    String? audio,
  }) async {
    if (scheduleDuration != null) {
      _scheduleDuration = Duration(minutes: scheduleDuration);
    }
    if (ringDuration != null) {
      _ringDuration = Duration(minutes: ringDuration);
    }
    if (disabled != null) _disabled = disabled;
    if (vibrate != null) _vibrate = vibrate;
    if (alarmMode != null) _mode = AlarmMode.values[alarmMode];
    if (audio != null) _audio = audio;
    await Storage().reminderUpdate(this);
    await save();
  }

  Future<void> editFromJson(Map<String, dynamic> data) async {
    return await edit(
      scheduleDuration: data["scheduleDuration"] as int?,
      ringDuration: data["ringDuration"] as int?,
      disabled: data["disabled"] as bool?,
      vibrate: data["vibrate"] as bool?,
      alarmMode: data["alarmMode"] as int?,
      audio: data["audio"] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        "scheduleDuration": _scheduleDuration.inMinutes,
        "ringDuration": _ringDuration.inMinutes,
        "disabled": _disabled,
        "vibrate": _vibrate,
        "alarmMode": _mode.index,
        "audio": _audio,
      };

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() => jsonEncode(toMap());
}

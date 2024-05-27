import 'package:hive/hive.dart';
part 'alarm.g.dart';

enum AlarmMode { follow, silent, custom }

@HiveType(typeId: 6)
class Reminder extends HiveObject {
  @HiveField(0)
  Duration _duration;
  @HiveField(1)
  bool _disabled;
  @HiveField(2)
  bool _vibrate;
  @HiveField(3)
  int _alarmMode;
  AlarmMode _mode;
  @HiveField(4)
  String? _audio;
  Duration get duration => _duration;
  bool get disabled => _disabled;
  bool get vibrate => _vibrate;
  AlarmMode get alarmMode => _mode;
  int get alarmModeInt => _alarmMode;
  String? get audio => _audio;

  Reminder(
    int duration, {
    bool? disabled,
    bool? vibrate,
    int? alarmMode,
    String? audio,
  })  : _duration = Duration(minutes: duration),
        _alarmMode = alarmMode ?? 0,
        _mode = AlarmMode.values[alarmMode ?? 0],
        _disabled = disabled ?? false,
        _vibrate = vibrate ?? true,
        _audio = audio;

  Reminder.fromJson(Map<String, dynamic> data)
      : this(
          data["duration"] as int,
          disabled: data["disabled"] as bool?,
          vibrate: data["vibrate"] as bool?,
          alarmMode: data["alarmMode"] as int?,
          audio: data["audio"] as String?,
        );

  Future<void> edit({
    int? duration,
    bool? disabled,
    bool? vibrate,
    int? alarmMode,
    String? audio,
  }) async {
    if (duration != null) _duration = Duration(minutes: duration);
    if (disabled != null) _disabled = disabled;
    if (vibrate != null) _vibrate = vibrate;
    if (alarmMode != null) _mode = AlarmMode.values[alarmMode];
    if (audio != null) _audio = audio;
    await save();
  }
}

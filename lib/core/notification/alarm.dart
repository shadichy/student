import 'package:hive/hive.dart';
part 'alarm.g.dart';

enum AlarmMode { follow, silent, custom }

@HiveType(typeId: 6)
class Reminder extends HiveObject {
  @HiveField(0)
  final Duration duration;
  @HiveField(1)
  final bool disabled;
  @HiveField(2)
  final bool vibrate;
  @HiveField(3)
  final AlarmMode alarmMode;
  @HiveField(4)
  final String? audio;

  Reminder({
    required this.duration,
    this.disabled = false,
    this.vibrate = true,
    this.alarmMode = AlarmMode.follow,
    this.audio,
  });
}

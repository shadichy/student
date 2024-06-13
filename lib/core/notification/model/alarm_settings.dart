import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:student/misc/misc_functions.dart';

part 'alarm_settings.g.dart';

/// [AlarmSettings] is a model that contains all the settings to customize
/// and set an alarm.
@HiveType(typeId: 11)
class AlarmSettings extends HiveObject {
  /// Model that contains all the settings to customize and set an alarm.
  AlarmSettings({
    required this.id,
    required this.dateTime,
    required this.timeout,
    required this.title,
    required this.body,
    this.audio,
    this.enabled = true,
    this.loopAudio = true,
    this.vibrate = true,
    this.volume,
    this.fadeDuration = 0.0,
    this.enableNotificationOnKill = false,
    this.androidFullScreenIntent = true,
  });

  /// Constructs an `AlarmSettings` instance from the given JSON data.
  AlarmSettings.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as int,
          dateTime: MiscFns.epoch(json['dateTime'] as int),
          timeout: Duration(seconds: json['timeout'] as int),
          audio: Uri.parse(json['audio'] as String),
          enabled: json['enabled'] as bool,
          loopAudio: json['loopAudio'] as bool,
          vibrate: json['vibrate'] as bool? ?? true,
          volume: json['volume'] as double?,
          fadeDuration: json['fadeDuration'] as double,
          title: json['title'] as String? ?? '',
          body: json['body'] as String? ?? '',
          enableNotificationOnKill: json['ifKilled'] as bool? ?? true,
          androidFullScreenIntent: json['fullscreen'] as bool? ?? true,
        );

  /// Unique identifier associated with the alarm. Cannot be 0 or -1;
  @HiveField(0)
  final int id;

  @HiveField(1)
  final bool enabled;

  /// Date and time when the alarm will be triggered.
  @HiveField(2)
  final DateTime dateTime;

  /// Path to audio asset to be used as the alarm ringtone. Accepted formats:
  ///
  /// * **Project asset**: Specifies an asset bundled with your Flutter project.
  ///  Use this format for assets that are included in your project's
  /// `pubspec.yaml` file.
  ///  Example: `assets/audio.mp3`.
  /// * **Absolute file path**: Specifies a direct file system path to the
  /// audio file. This format is used for audio files stored outside the
  /// Flutter project, such as files saved in the device's internal
  /// or external storage.
  ///  Example: `/path/to/your/audio.mp3`.
  /// * **Relative file path**: Specifies a file path relative to a predefined
  /// base directory in the app's internal storage. This format is convenient
  /// for referring to files that are stored within a specific directory of
  /// your app's internal storage without needing to specify the full path.
  ///  Example: `Audios/audio.mp3`.
  ///
  /// If no audio path specified, default alarm sound will be played
  ///
  /// If you want to use absolute or relative file path, you must request
  /// android storage permission and add the following permission to your
  /// `AndroidManifest.xml`:
  /// `android.permission.READ_EXTERNAL_STORAGE`
  @HiveField(3)
  final Uri? audio;

  /// If true, [audio] will repeat indefinitely until alarm is stopped.
  @HiveField(4)
  final bool loopAudio;

  /// If true, device will vibrate for 500ms, pause for 500ms and repeat until
  /// alarm is stopped.
  ///
  /// If [loopAudio] is set to false, vibrations will stop when audio ends.
  @HiveField(5)
  final bool vibrate;

  /// Specifies the system volume level to be set at the designated [dateTime].
  ///
  /// Accepts a value between 0 (mute) and 1 (maximum volume).
  /// When the alarm is triggered at [dateTime], the system volume adjusts to
  /// this specified level. Upon stopping the alarm, the system volume reverts
  /// to its prior setting.
  ///
  /// If left unspecified or set to `null`, the current system volume
  /// at the time of the alarm will be used.
  /// Defaults to `null`.
  @HiveField(6)
  final double? volume;

  /// Duration, in seconds, over which to fade the alarm ringtone.
  /// Set to 0.0 by default, which means no fade.
  @HiveField(7)
  final double fadeDuration;

  /// Title of the notification to be shown when alarm is triggered.
  @HiveField(8)
  final String title;

  /// Body of the notification to be shown when alarm is triggered.
  @HiveField(9)
  final String body;

  /// Whether to show a notification when application is killed by user.
  ///
  /// - Android: the alarm should still trigger even if the app is killed,
  /// if configured correctly and with the right permissions.
  /// - iOS: the alarm will not trigger if the app is killed.
  ///
  /// Recommended: set to `Platform.isIOS` to enable it only
  /// on iOS. Defaults to `true`.
  @HiveField(10)
  final bool enableNotificationOnKill;

  /// Whether to turn screen on and display full screen notification
  /// when android alarm notification is triggered. Enabled by default.
  ///
  /// Some devices will need the Autostart permission to show the full screen
  /// notification. You can check if the permission is granted and request it
  /// with the [auto_start_flutter](https://pub.dev/packages/auto_start_flutter)
  /// package.
  @HiveField(11)
  final bool androidFullScreenIntent;

  // Duration of the notification
  @HiveField(12)
  final Duration timeout;

  /// Returns a hash code for this `AlarmSettings` instance using
  /// Jenkins hash function.
  @override
  int get hashCode {
    var hash = 0;

    hash = hash ^ id.hashCode;
    hash = hash ^ dateTime.hashCode;
    hash = hash ^ audio.hashCode;
    hash = hash ^ loopAudio.hashCode;
    hash = hash ^ vibrate.hashCode;
    hash = hash ^ volume.hashCode;
    hash = hash ^ fadeDuration.hashCode;
    hash = hash ^ (title.hashCode);
    hash = hash ^ (body.hashCode);
    hash = hash ^ enableNotificationOnKill.hashCode;
    hash = hash & 0x3fffffff;

    return hash;
  }

  /// Creates a copy of `AlarmSettings` but with the given fields replaced with
  /// the new values.
  AlarmSettings copyWith({
    int? id,
    DateTime? dateTime,
    Duration? timeout,
    bool? enabled,
    Uri? audio,
    bool? loopAudio,
    bool? vibrate,
    double? volume,
    double? fadeDuration,
    String? title,
    String? body,
    bool? enableNotificationOnKill,
    bool? androidFullScreenIntent,
  }) {
    return AlarmSettings(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      timeout: timeout ?? this.timeout,
      enabled: enabled ?? this.enabled,
      audio: audio ?? this.audio,
      loopAudio: loopAudio ?? this.loopAudio,
      vibrate: vibrate ?? this.vibrate,
      volume: volume ?? this.volume,
      fadeDuration: fadeDuration ?? this.fadeDuration,
      title: title ?? this.title,
      body: body ?? this.body,
      enableNotificationOnKill:
          enableNotificationOnKill ?? this.enableNotificationOnKill,
      androidFullScreenIntent:
          androidFullScreenIntent ?? this.androidFullScreenIntent,
    );
  }

  static Uri? uriFromString(String? path) {
    if (path == null) return null;
    return Uri.tryParse("content://${path.replaceFirst('content://', '')}");
  }

  /// Converts this `AlarmSettings` instance to JSON data.
  Map<String, dynamic> toMap() => {
        'id': id,
        'dateTime': dateTime.millisecondsSinceEpoch ~/ 1000,
        'timeout': timeout.inSeconds,
        'enabled': enabled,
        'audio': audio.toString(),
        'title': title,
        'body': body,
        'vibrate': vibrate,
        'loopAudio': loopAudio,
        'volume': volume,
        'fadeDuration': fadeDuration,
        'ifKilled': enableNotificationOnKill,
        'fullscreen': androidFullScreenIntent,
      };

  Map<String, dynamic> toJson() => toMap();

  /// Returns all the properties of `AlarmSettings` for debug purposes.
  @override
  String toString() => jsonEncode(toMap());

  /// Compares two AlarmSettings.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmSettings &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dateTime == other.dateTime &&
          audio == other.audio &&
          loopAudio == other.loopAudio &&
          vibrate == other.vibrate &&
          volume == other.volume &&
          fadeDuration == other.fadeDuration &&
          title == other.title &&
          body == other.body &&
          enableNotificationOnKill == other.enableNotificationOnKill &&
          androidFullScreenIntent == other.androidFullScreenIntent;
}

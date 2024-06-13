// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/notification/model/alarm_settings.dart';
import 'package:student/core/notification/src/android_alarm.dart';
import 'package:student/core/notification/src/ios_alarm.dart';
import 'package:student/core/notification/utils/alarm_exception.dart';
import 'package:student/core/notification/utils/extensions.dart';

/// Custom print function designed for Alarm plugin.
DebugPrintCallback alarmPrint = debugPrintThrottled;

/// Class that handles the alarm.
abstract final class Alarm {
  /// Whether it's iOS device.
  static bool get iOS => defaultTargetPlatform == TargetPlatform.iOS;

  /// Whether it's Android device.
  static bool get android => defaultTargetPlatform == TargetPlatform.android;

  /// Stream of the ringing status.
  static final ringStream = StreamController<AlarmSettings>();

  /// Initializes Alarm services.
  ///
  /// Also calls [checkAlarm] that will reschedule alarms that were set before
  /// app termination.
  ///
  /// Set [showDebugLogs] to `false` to hide all the logs from the plugin.
  static Future<void> init({bool showDebugLogs = true}) async {
    alarmPrint = (String? message, {int? wrapWidth}) {
      if (showDebugLogs) print('[Student] $message');
    };

    // if (android) AndroidAlarm.init();
    // await AlarmStorage.init();
    await checkAlarm();
    alarmPrint("Alarm initialized");
  }

  /// Checks if some alarms were set on previous session.
  /// If it's the case then reschedules them.
  static Future<void> checkAlarm() async {
    final alarms = Storage().alarms.toList();
    alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (iOS) await stopAll();

    for (final alarm in alarms) {
      // final now = DateTime.now();
      print("Alarm init for ${alarm.id}");
      await set(alarm);
      // if (alarm.dateTime.isAfter(now)) {
      // } else {
      //   final isRinging = await Alarm.isRinging(alarm.id);
      //   isRinging ? ringStream.add(alarm) : await stop(alarm.id);
      // }
    }
  }

  /// Schedules an alarm with given [alarmSettings] with its notification.
  ///
  /// If you set an alarm for the same dateTime as an existing one,
  /// the new alarm will replace the existing one.
  static Future<bool> set(AlarmSettings alarmSettings) async {
    alarmSettingsValidation(alarmSettings);

    for (final alarm in Alarm.getAlarms()) {
      if (alarm.id == alarmSettings.id ||
          alarm.dateTime.isSameSecond(alarmSettings.dateTime)) {
        await Alarm.stop(alarm.id);
      }
    }

    // await Storage().addAlarm(alarmSettings);

    if (iOS) {
      return await IOSAlarm.setAlarm(
        alarmSettings,
        () => ringStream.add(alarmSettings),
      );
    } else if (android) {
      return await AndroidAlarm.set(
        alarmSettings,
        () => ringStream.add(alarmSettings),
      );
    }

    return false;
  }

  /// Validates [alarmSettings] fields.
  static void alarmSettingsValidation(AlarmSettings alarmSettings) {
    if (alarmSettings.id == 0 || alarmSettings.id == -1) {
      throw AlarmException(
        'Alarm id cannot be 0 or -1. Provided: ${alarmSettings.id}',
      );
    }
    if (alarmSettings.id > 2147483647) {
      throw AlarmException(
        '''Alarm id cannot be set larger than Int max value (2147483647). Provided: ${alarmSettings.id}''',
      );
    }
    if (alarmSettings.id < -2147483648) {
      throw AlarmException(
        '''Alarm id cannot be set smaller than Int min value (-2147483648). Provided: ${alarmSettings.id}''',
      );
    }
    // if (alarmSettings.volume != null &&
    //     (alarmSettings.volume! < 0 || alarmSettings.volume! > 1)) {
    //   throw AlarmException(
    //     'Volume must be between 0 and 1. Provided: ${alarmSettings.volume}',
    //   );
    // }
    // if (alarmSettings.fadeDuration < 0) {
    //   throw AlarmException(
    //     '''Fade duration must be positive. Provided: ${alarmSettings.fadeDuration}''',
    //   );
    // }
  }

  /// When the app is killed, all the processes are terminated
  /// so the alarm may never ring. By default, to warn the user, a notification
  /// is shown at the moment he kills the app.
  /// This methods allows you to customize this notification content.
  ///
  /// [title] default value is `Your alarm may not ring`
  ///
  /// [body] default value is `You killed the app.
  /// Please reopen so your alarm can ring.`
  static Future<void> setNotificationOnAppKillContent(
    String title,
    String body,
  ) =>
      Storage().setNotificationContentOnAppKill(title, body);

  /// Stops alarm.
  static Future<bool> stop(int id) async {
    await Storage().removeAlarm(id);

    return iOS ? await IOSAlarm.stopAlarm(id) : await AndroidAlarm.stop(id);
  }

  /// Stops all the alarms.
  static Future<void> stopAll() async {
    final alarms = Storage().alarms;

    for (final alarm in alarms) {
      await stop(alarm.id);
    }
  }

  /// Whether the alarm is ringing.
  static Future<bool> isRinging(int id) async => iOS
      ? await IOSAlarm.checkIfRinging(id)
      : await AndroidAlarm.isRinging(id);

  /// Whether an alarm is set.
  static bool hasAlarm() => Storage().hasAlarm;

  /// Returns alarm by given id. Returns null if not found.
  static AlarmSettings? getAlarm(int id) {
    final alarms = Storage().alarms;

    for (final alarm in alarms) {
      if (alarm.id == id) return alarm;
    }
    alarmPrint('Alarm with id $id not found.');

    return null;
  }

  /// Returns all the alarms.
  static List<AlarmSettings> getAlarms() => Storage().alarms.toList();
}

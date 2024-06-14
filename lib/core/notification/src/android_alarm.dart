import 'dart:async';

import 'package:flutter/services.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/core/notification/alarm.dart';
import 'package:student/core/notification/model/alarm_settings.dart';
import 'package:student/core/notification/utils/alarm_exception.dart';

/// Uses method channel to interact with the native platform.
abstract final class AndroidAlarm {
  /// Method channel for the alarm operations.
  static const platform = MethodChannel('dev.tlu.student.methods');

  /// Event channel for the alarm events.
  static const eventChannel = EventChannel('dev.tlu.student.events');

  /// Whether there are other alarms set.
  static bool get hasOtherAlarms => Storage().alarms.length > 1;

  /// Starts listening to the alarm events.
  static void init() => listenToAlarmEvents();

  /// Listens to the alarm events.
  static void listenToAlarmEvents() {
    // eventChannel.receiveBroadcastStream().listen(
    //   (dynamic event) {
    //     try {
    //       final eventMap = Map<String, dynamic>.from(event as Map);
    //       final id = eventMap['id'] as int;
    //       final settings = Alarm.getAlarm(id);
    //       if (settings != null) Alarm.ringStream.add(settings);
    //     } catch (e) {
    //       alarmPrint('Error receiving alarm events: $e');
    //     }
    //   },
    //   onError: (dynamic error, StackTrace stackTrace) {
    //     alarmPrint('Error listening to alarm events: $error, $stackTrace');
    //   },
    // );
  }

  /// Schedules a native alarm with given [settings] with its notification.
  static Future<bool> set(
    AlarmSettings settings,
    void Function()? onRing,
  ) async {
    try {
      // final delay = settings.dateTime.difference(DateTime.now());

      await platform
          .invokeMethod('setAlarm', settings.toMap())
          .then((r) => alarmPrint(r));
    } catch (e) {
      throw AlarmException('nativeAndroidAlarm error: $e');
    }

    if (settings.enableNotificationOnKill && !hasOtherAlarms) {
      try {
        await platform.invokeMethod(
          'setNotificationOnKillService',
          {
            'title': Storage().getNotificationOnAppKillTitle(),
            'body': Storage().getNotificationOnAppKillBody(),
          },
        );
      } catch (e) {
        throw AlarmException('NotificationOnKillService error: $e');
      }
    }

    alarmPrint(
      '''Alarm with id ${settings.id} scheduled at ${settings.dateTime}''',
    );

    return true;
  }

  /// Sends the message `stop` to the isolate so the audio player
  /// can stop playing and dispose.
  static Future<bool> stop(int id) async {
    try {
      final res = await platform.invokeMethod('stopAlarm', {'id': id});
      alarmPrint(res);
      if (!hasOtherAlarms) await stopNotificationOnKillService();
      return true;
    } catch (e) {
      alarmPrint('Failed to stop alarm: $e');
      return false;
    }
  }

  /// Checks if the alarm with given [id] is ringing.
  static Future<bool> isRinging(int id) async {
    try {
      final res = await platform.invokeMethod('isRinging', {'id': id}) as bool;
      return res;
    } catch (e) {
      alarmPrint('Failed to check if alarm is ringing: $e');
      return false;
    }
  }

  /// Disable the notification on kill service.
  static Future<void> stopNotificationOnKillService() async {
    try {
      await platform.invokeMethod('stopNotificationOnKillService');
    } catch (e) {
      throw AlarmException('NotificationOnKillService error: $e');
    }
  }
}

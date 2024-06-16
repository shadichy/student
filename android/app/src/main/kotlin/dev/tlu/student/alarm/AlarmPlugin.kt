package dev.tlu.student.alarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI
import androidx.annotation.NonNull
import dev.tlu.student.provider.Alarm
import dev.tlu.student.services.NotificationOnKillService
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.Calendar

class AlarmPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "dev.tlu.student.alarm")
        methodChannel.setMethodCallHandler(this)

        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "dev.tlu.student.alarm.events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        handleMethodCall(context, call, result)
    }

    companion object {
        @JvmStatic
        var eventSink: EventChannel.EventSink? = null

        private const val INVALID_ID = "INVALID_ID"
        private const val INVALID_START_TIME = "INVALID_START"

        fun handleMethodCall(context: Context, call: MethodCall, result: Result) {
            when (call.method) {
                "setAlarm" -> {
                    try {
                        handleSetAlarm(context, call)
                    } catch (e: Exception) {
                        result.error("${e.message}", null, null)
                    }
                    result.success(true)
                }

                "stopAlarm" -> {
                    try {
                        handleStopAlarm(context, call)
                    } catch (e: Exception) {
                        result.error("${e.message}", null, null)
                    }

                    result.success(true)
                }

                "isRinging" -> {
                    val id = call.argument<Int>(Alarm.ID)
                    val ringingAlarmIds = AlarmService.ringingAlarmIds
                    val isRinging = ringingAlarmIds.contains(id)
                    result.success(isRinging)
                }

                "setNotificationOnKillService" -> {
                    val title = call.argument<String>("title")
                    val body = call.argument<String>("body")

                    val serviceIntent = Intent(context, NotificationOnKillService::class.java)
                    serviceIntent.putExtra("title", title)
                    serviceIntent.putExtra("body", body)

                    context.startService(serviceIntent)

                    result.success(true)
                }

                "stopNotificationOnKillService" -> {
                    val serviceIntent = Intent(context, NotificationOnKillService::class.java)
                    context.stopService(serviceIntent)
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }

        private fun handleSetAlarm(context: Context, call: MethodCall) {
            val alarm = Alarm(
                call.argument<Int>(Alarm.ID) ?: -1,
                call.argument<Int>("dateTime") ?: -1,
                call.argument<Int>("timeout") ?: -1
            )

            println("[Android] 1 alarm $alarm")

            if (alarm.id == -1) throw Exception(INVALID_ID)
            if (alarm.secondsSinceEpoch == -1) throw Exception(INVALID_START_TIME)

            alarm.vibrate = call.argument<Boolean>("vibrate") ?: alarm.vibrate
            alarm.label = call.argument<String>("title") ?: alarm.label
            alarm.body = call.argument<String>("body") ?: alarm.label

            alarm.loopAudio = call.argument<Boolean>("loopAudio") ?: alarm.vibrate
            alarm.volume = call.argument<Double>("volume") ?: alarm.volume
            alarm.fadeDuration = call.argument<Double>("fadeDuration") ?: alarm.fadeDuration

            alarm.audio = call.argument<String>("audio") ?: "null"
            if (alarm.audio == "null") alarm.audio = DEFAULT_ALARM_ALERT_URI.toString()

            println("[Android] 2 alarm $alarm")
            val alarmIntent = Intent(context, AlarmReceiver::class.java)
            alarmIntent.putExtra(Alarm.NAME, alarm)

            val delayInMillis: Long = alarm.startTime.timeInMillis - System.currentTimeMillis()

            if (delayInMillis <= 5000L) {
                handleImmediateAlarm(context, alarmIntent, delayInMillis)
            } else {
                handleDelayedAlarm(context, alarmIntent, alarm.startTime, alarm.id)
            }
        }

        private fun handleStopAlarm(context: Context, call: MethodCall) {
            val id = call.argument<Int>(Alarm.ID) ?: throw Exception(INVALID_ID)

            // Check if the alarm is currently ringing
            if (AlarmService.ringingAlarmIds.contains(id)) {
                // If the alarm is ringing, stop the alarm service for this ID
                val stopIntent = Intent(context, AlarmService::class.java)
                stopIntent.action = AlarmService.STOP_ALARM
                stopIntent.putExtra(Alarm.ID, id)
                context.stopService(stopIntent)
            }

            // Intent to cancel the future alarm if it's set
            val alarmIntent = Intent(context, AlarmReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                id,
                alarmIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Cancel the future alarm using AlarmManager
            val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            am.cancel(pendingIntent)
        }

        private fun handleImmediateAlarm(context: Context, intent: Intent, delayInMillis: Long) {
            val handler = Handler(Looper.getMainLooper())
            handler.postDelayed({
                context.sendBroadcast(intent)
            }, delayInMillis)
        }

        private fun handleDelayedAlarm(
            context: Context,
            intent: Intent,
            startTime: Calendar,
            id: Int
        ) {
            try {
                val triggerTime = startTime.timeInMillis
                val pendingIntent = PendingIntent.getBroadcast(
                    context,
                    id,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                val am = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
                    ?: throw IllegalStateException("AlarmManager not available")

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    am.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        triggerTime,
                        pendingIntent
                    )
                } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    am.setExact(AlarmManager.RTC_WAKEUP, triggerTime, pendingIntent)
                } else {
                    am.set(AlarmManager.RTC_WAKEUP, triggerTime, pendingIntent)
                }
            } catch (e: ClassCastException) {
                Log.e("AlarmPlugin", "AlarmManager service type casting failed", e)
            } catch (e: IllegalStateException) {
                Log.e("AlarmPlugin", "AlarmManager service not available", e)
            } catch (e: Exception) {
                Log.e("AlarmPlugin", "Error in handling delayed alarm", e)
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }
}
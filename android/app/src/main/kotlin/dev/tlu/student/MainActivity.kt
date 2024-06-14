package dev.tlu.student

import android.content.Intent
import android.net.Uri
import dev.tlu.student.alarms.AlarmStateManager
import dev.tlu.student.data.DataModel
import dev.tlu.student.provider.Alarm
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val methodChannel = "dev.tlu.student.methods"
    private val eventChannel = "dev.tlu.student.events"

    companion object {
        @JvmStatic
        var eventSink: EventChannel.EventSink? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        DataModel.dataModel.init(context)
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            methodChannel
        ).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            // TODO
            when (call.method) {
                "getEntrypointName" -> result.success(dartEntrypointFunctionName)
                "alarm" -> {
                    val intent = Intent(this, AlarmActivity::class.java)
                    intent.putExtra("id", call.argument("id") as Int?)
                    startActivity(intent)
                    result.success("[Android] invoking alarm")
                }

                "setAlarm" -> {
                    val id = call.argument<Int>("id")
                    val alarm = Alarm(
                        id ?: -1,
                        call.argument<Int>("dateTime") ?: -1,
                        call.argument<Int>("timeout") ?: -1
                    )
                    if (alarm.id == -1 || alarm.secondsSinceEpoch == -1 || alarm.duration == -1) {
                        result.error("INVALID_FIELDS", "Fields is invalid!", alarm)
                        return@setMethodCallHandler
                    }
                    alarm.vibrate = call.argument<Boolean>("vibrate") ?: alarm.vibrate
                    alarm.label = call.argument<String>("title")
                    alarm.body = call.argument<String>("body")
                    try {
                        alarm.audio = Uri.parse(call.argument<String>("audio"))
                    } catch (_: Exception) {}
                    alarm.highPrior = id!! shl 16 == 0
//                    val intent = Intent(ACTION_SET_ALARM)
//                    intent.setAction(ACTION_SET_ALARM)
//                    intent.putExtra("id", id)
//                    intent.putExtra("dateTime", call.argument<Int>("dateTime"))
//                    intent.putExtra("timeout", call.argument<Int>("timeout"))
//                    intent.putExtra("enabled", call.argument<Boolean>("enabled"))
//                    intent.putExtra("audio", call.argument<String>("audio"))
//                    intent.putExtra("title", call.argument<String>("title"))
//                    intent.putExtra("body", call.argument<String>("body"))
//                    intent.putExtra("vibrate", call.argument<Boolean>("vibrate"))
//                    intent.putExtra("volume", call.argument<Double>("volume"))
//                    intent.putExtra("loopAudio", call.argument<Boolean>("loopAudio"))
//                    intent.putExtra("fadeDuration", call.argument<Double>("fadeDuration"))
                    AlarmStateManager.registerInstance(context, alarm)
                    result.success("[Android] setting alarm $id")
                }

                "stopAlarm" -> {
                    val id = call.argument<Int>("id")
                    if (id == null) {
                        result.error("INVALID_ID", "ID field is invalid!", null)
                        return@setMethodCallHandler
                    }
                    AlarmStateManager.unregisterInstance(context, id)
                    result.success("[Android] stopping alarm $id")
                }

                "defaultAlarmSound" -> result.success(
                    DataModel.dataModel.defaultAlarmRingtoneUri.toString()
                )

                "defaultRingtoneSound" -> result.success(
                    DataModel.dataModel.defaultPhoneRingtoneUri.toString()
                )

                "defaultNotificationSound" -> result.success(
                    DataModel.dataModel.defaultNotificationRingtoneUri.toString()
                )
                else -> result.notImplemented()
            }
        }
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })
    }
}

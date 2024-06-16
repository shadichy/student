package dev.tlu.student

import android.content.Intent
import dev.tlu.student.alarm.AlarmPlugin
import dev.tlu.student.provider.Alarm
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val methodChannel = "dev.tlu.student.methods"
    private val eventChannel = "dev.tlu.student.events"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        DataModel.dataModel.init(context)
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            methodChannel
        ).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            // TODO
            when (call.method) {
                "alarm" -> {
                    val intent = Intent(this, AlarmActivity::class.java)
                    intent.putExtra(Alarm.ID, call.argument(Alarm.ID) as Int?)
                    startActivity(intent)
                    result.success("[Android] invoking alarm")
                }

                else -> AlarmPlugin.handleMethodCall(context, call, result)
            }
        }
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    AlarmPlugin.eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    AlarmPlugin.eventSink = null
                }
            })
    }
}

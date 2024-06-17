package dev.tlu.student

import dev.tlu.student.alarm.AlarmPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        DataModel.dataModel.init(context)
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            methodChannel
        ).setMethodCallHandler { call, result ->
            AlarmPlugin.handleMethodCall(
                context,
                call,
                result
            )
        }
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel)
            .setStreamHandler(eventStreamHandler)

    }

    companion object {
        const val methodChannel = "dev.tlu.student.methods"
        const val eventChannel = "dev.tlu.student.events"
        val eventStreamHandler: EventChannel.StreamHandler = object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                AlarmPlugin.eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                AlarmPlugin.eventSink = null
            }
        }
    }
}

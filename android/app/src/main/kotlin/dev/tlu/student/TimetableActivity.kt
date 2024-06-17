package dev.tlu.student

import dev.tlu.student.alarm.AlarmPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class TimetableActivity : FlutterActivity() {
    private val methodChannel = MainActivity.methodChannel
    private val eventChannel = MainActivity.methodChannel

    override fun getDartEntrypointArgs(): List<String> {
        return List(1) { _ -> """{"route": "timetable"}""" }
    }

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
            .setStreamHandler(MainActivity.eventStreamHandler)
    }
}

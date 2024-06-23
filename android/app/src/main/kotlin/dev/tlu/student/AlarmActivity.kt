package dev.tlu.student

import dev.tlu.student.alarm.AlarmPlugin
import dev.tlu.student.provider.Alarm
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class AlarmActivity : FlutterActivity() {
    private val methodChannel = MainActivity.methodChannel

    override fun getDartEntrypointFunctionName(): String {
        return Alarm.NAME
    }

    override fun getDartEntrypointArgs(): List<String> {
        return List(1) { _ -> "${intent.getIntExtra(Alarm.ID, 0)}" }
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
    }
}

package dev.tlu.student

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class AlarmActivity : FlutterActivity() {
    private val channel = "dev.tlu.student.alarm"

    override fun getDartEntrypointFunctionName(): String {
        return "alarm"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            // TODO
            when (call.method) {
                "getEntrypointName" -> result.success(dartEntrypointFunctionName)
                else -> result.notImplemented()
            }
        }
    }
}

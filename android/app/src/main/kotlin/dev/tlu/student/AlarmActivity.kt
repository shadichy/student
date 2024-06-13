package dev.tlu.student

import dev.tlu.student.alarms.AlarmStateManager
import dev.tlu.student.data.DataModel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class AlarmActivity : FlutterActivity() {
    private val methodChannel = "dev.tlu.student.methods"
    private val intent = getIntent()

    override fun getDartEntrypointFunctionName(): String {
        return "alarm"
    }

    override fun getDartEntrypointArgs(): List<String> {
        return List(1) { _ -> "${intent.getIntExtra("id", 0)}" }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        DataModel.dataModel.init(context);
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            methodChannel
        ).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            // TODO
            when (call.method) {
                "getEntrypointName" -> result.success(dartEntrypointFunctionName)
                "stopAlarm" -> {
                    val id = call.argument<Int>("id")
                    if (id == null) {
                        result.error("INVALID_ID", "ID field is invalid!", null)
                        return@setMethodCallHandler;
                    }
                    AlarmStateManager.unregisterInstance(context, id)
                    result.success("[Android] stopping alarm $id")
                }
                else -> result.notImplemented()
            }
        }
    }
}

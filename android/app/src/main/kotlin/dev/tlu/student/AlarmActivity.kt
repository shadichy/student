package dev.tlu.student

import android.content.Context
import android.os.Bundle
import android.os.PersistableBundle
import dev.tlu.student.alarms.AlarmStateManager
import dev.tlu.student.data.DataModel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class AlarmActivity : FlutterActivity() {
    private val methodChannel = "dev.tlu.student.methods"
    private lateinit var appContext: Context


    override fun getDartEntrypointFunctionName(): String {
        return "alarm"
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)

        appContext = applicationContext

        try {
            val intent = intent
            // println("[Android] alarm launched with intent ${intent.extras}")

        } catch (e: Exception) {
            // println(e.message)
            e.printStackTrace()
        }
    }

    override fun getDartEntrypointArgs(): List<String> {
        return List(1) { _ -> "${intent.getIntExtra("id", 0)}" }
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
                "stopAlarm" -> {
                    val id = call.argument<Int>("id")
                    if (id == null) {
                        result.error("INVALID_ID", "ID field is invalid!", null)
                        return@setMethodCallHandler
                    }
                    AlarmStateManager.unregisterInstance(context, id)
                    result.success("[Android] stopping alarm $id")
                }
                else -> result.notImplemented()
            }
        }
    }
}

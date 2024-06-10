package dev.tlu.student

import android.content.Intent
import android.media.RingtoneManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "dev.tlu.student.methods"
    private val ringtoneManager = RingtoneManager(this)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            // This method is invoked on the main thread.
            // TODO
            when (call.method) {
                "getEntrypointName" -> result.success(dartEntrypointFunctionName)
                "alarm" -> {
                    val intent = Intent(this, AlarmActivity::class.java)
                    startActivity(intent)
                    result.success("[Android] invoking alarm")
                }
                "defaultAlarmSound" -> {
                    val alarmUri = ringtoneManager.getRingtoneUri(RingtoneManager.TYPE_ALARM)
                    result.success(alarmUri)
                }
                "defaultRingtoneSound" -> {
                    val ringtoneUri = ringtoneManager.getRingtoneUri(RingtoneManager.TYPE_RINGTONE)
                    result.success(ringtoneUri)
                }
                "defaultNotificationSound" -> {
                    val notificationUri = ringtoneManager.getRingtoneUri(RingtoneManager.TYPE_NOTIFICATION)
                    result.success(notificationUri)
                }
                else -> result.notImplemented()
            }
        }
    }
}

package dev.tlu.student.alarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.FileUtils
import android.os.Handler
import android.os.Looper
import android.provider.BaseColumns
import android.provider.MediaStore.Audio.AudioColumns
import android.provider.Settings
import androidx.annotation.RequiresApi
import dev.tlu.student.AlarmActivity
import dev.tlu.student.provider.Alarm
import dev.tlu.student.services.NotificationOnKillService
import io.flutter.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import java.io.FileNotFoundException
import java.util.Calendar


object AlarmPlugin {
    @JvmStatic
    var eventSink: EventChannel.EventSink? = null

    private const val INVALID_ID = "INVALID_ID"
    private const val INVALID_START_TIME = "INVALID_START"

    fun handleMethodCall(context: Context, call: MethodCall, result: Result) {
        when (call.method) {
            "alarm" -> {
                val intent = Intent(context, AlarmActivity::class.java)
                intent.putExtra(Alarm.ID, call.argument(Alarm.ID) as Int?)
                context.startActivity(intent)
                result.success(true)
            }

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

        if (alarm.id == -1) throw Exception(INVALID_ID)
        if (alarm.secondsSinceEpoch == -1) throw Exception(INVALID_START_TIME)

        alarm.vibrate = call.argument<Boolean>("vibrate") ?: alarm.vibrate
        alarm.label = call.argument<String>("title") ?: alarm.label
        alarm.body = call.argument<String>("body") ?: alarm.label

        alarm.loopAudio = call.argument<Boolean>("loopAudio") ?: alarm.loopAudio
        alarm.loopVibrate = call.argument<Boolean>("loopAudio") ?: alarm.loopVibrate
        alarm.volume = call.argument<Double>("volume") ?: alarm.volume
        alarm.fadeDuration = call.argument<Double>("fadeDuration") ?: alarm.fadeDuration

        alarm.audio = call.argument<String>("audio") ?: "null"
        if (alarm.audio == "null") {
            val defaultAudio = Settings.System.DEFAULT_ALARM_ALERT_URI.toString()
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                alarm.audio = getRingtoneUriForRestore(context.contentResolver, defaultAudio, RingtoneManager.TYPE_ALARM)?.toString() ?: defaultAudio
                } else {
                    throw Exception()
                }
            } catch (e: Exception) {
                e.printStackTrace()
                alarm.audio = defaultAudio
            }
        }

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
        alarmIntent.action = AlarmService.STOP_ALARM
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

    fun handleImmediateAlarm(context: Context, intent: Intent, delayInMillis: Long) {
        val handler = Handler(Looper.getMainLooper())
        handler.postDelayed({
            context.sendBroadcast(intent)
        }, delayInMillis)
    }

    fun handleDelayedAlarm(
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

    @RequiresApi(Build.VERSION_CODES.Q)
    @Throws(FileNotFoundException::class, IllegalArgumentException::class)
    fun getRingtoneUriForRestore(
        contentResolver: ContentResolver, value: String?, ringtoneType: Int
    ): Uri? {
        if (value == null) {
            // Return a valid null. It means the null value is intended instead of a failure.
            return null
        }
        var ringtoneUri: Uri?
        val canonicalUri = Uri.parse(value)
        // Try to get the media uri via the regular non-canonicalize method first.
        ringtoneUri = contentResolver.uncanonicalize(canonicalUri)
        if (ringtoneUri != null) {
            // Canonicalize it to make the result contain the right metadata of the media asset.
            ringtoneUri = contentResolver.canonicalize(ringtoneUri)
            return ringtoneUri
        }
        // Query the media by title and ringtone type.
        val title = canonicalUri.getQueryParameter(AudioColumns.TITLE)
        val baseUri = ContentUris.removeId(canonicalUri).buildUpon().clearQuery().build()
        val ringtoneTypeSelection: String = when (ringtoneType) {
            RingtoneManager.TYPE_RINGTONE -> AudioColumns.IS_RINGTONE
            RingtoneManager.TYPE_NOTIFICATION -> AudioColumns.IS_NOTIFICATION

            RingtoneManager.TYPE_ALARM -> AudioColumns.IS_ALARM
            else -> throw IllegalArgumentException("Unknown ringtone type: $ringtoneType")
        }
        val selection = ringtoneTypeSelection + "=1 AND " + AudioColumns.TITLE + "=?"
        val cursor: Cursor?
        try {
            cursor =
                contentResolver.query(
                    baseUri,  /* projection */
                    arrayOf(BaseColumns._ID),  /* selection */
                    selection,  /* selectionArgs */
                    arrayOf(title),  /* sortOrder */
                    null,  /* cancellationSignal */
                    null
                )
        } catch (e: IllegalArgumentException) {
            throw FileNotFoundException("Volume not found for $baseUri")
        }
        if (cursor == null) {
            throw FileNotFoundException("Missing cursor for $baseUri")
        } else if (cursor.count == 0) {
            FileUtils.closeQuietly(cursor)
            throw FileNotFoundException("No item found for $baseUri")
        } else if (cursor.count > 1) {
            // Find more than 1 result.
            // We are not sure which one is the right ringtone file so just abandon this case.
            FileUtils.closeQuietly(cursor)
            throw FileNotFoundException(
                "Find multiple ringtone candidates by title+ringtone_type query: count: "
                        + cursor.count
            )
        }
        if (cursor.moveToFirst()) {
            ringtoneUri = ContentUris.withAppendedId(baseUri, cursor.getLong(0))
            FileUtils.closeQuietly(cursor)
        } else {
            FileUtils.closeQuietly(cursor)
            throw FileNotFoundException("Failed to read row from the result.")
        }
        // Canonicalize it to make the result contain the right metadata of the media asset.
        ringtoneUri = contentResolver.canonicalize(ringtoneUri)
        return ringtoneUri
    }
}

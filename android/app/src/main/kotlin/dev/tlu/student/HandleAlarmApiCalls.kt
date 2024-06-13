package dev.tlu.student

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.AlarmClock
import dev.tlu.student.alarms.AlarmStateManager
import dev.tlu.student.data.DataModel
import dev.tlu.student.provider.Alarm

class HandleAlarmApiCalls : Activity() {
    private lateinit var appContext: Context

    override fun onCreate(icicle: Bundle?) {
        super.onCreate(icicle)

        appContext = applicationContext

        try {
            val intent = intent
            val action = intent?.action ?: return
            // LOGGER.i("onCreate: $intent")

            when (action) {
                AlarmClock.ACTION_SET_ALARM -> handleSetAlarm(intent)
                AlarmClock.ACTION_SHOW_ALARMS -> handleShowAlarms()
//                AlarmClock.ACTION_SET_TIMER -> handleSetTimer(intent)
//                AlarmClock.ACTION_SHOW_TIMERS -> handleShowTimers(intent)
                AlarmClock.ACTION_DISMISS_ALARM -> handleDismissAlarm(intent)
                AlarmClock.ACTION_SNOOZE_ALARM -> handleSnoozeAlarm(intent)
//                AlarmClock.ACTION_DISMISS_TIMER -> handleDismissTimer(intent)
            }
        } catch (e: Exception) {
            // LOGGER.wtf(e)
            e.printStackTrace()
        } finally {
            finish()
        }
    }

    private fun handleDismissAlarm(intent: Intent) {
        startActivity(Intent(appContext, MainActivity::class.java))
        dismissAlarm(intent.getIntExtra("id", -1), this)
    }

    private fun handleSnoozeAlarm(intent: Intent) {
        snoozeAlarm(intent.getIntExtra("id", -1), this)
    }

    /**
     * Processes the SET_ALARM intent
     * @param intent Intent passed to the app
     */
    private fun handleSetAlarm(intent: Intent) {
        val alarm = Alarm(
                intent.getIntExtra("id", -1),
                intent.getIntExtra("dateTime", -1),
                intent.getIntExtra("timeout", -1),
        )
        if (alarm.id == -1 || alarm.secondsSinceEpoch == -1) {
            return
        }
        alarm.enabled = intent.getBooleanExtra("enabled", true)
        alarm.label = intent.getStringExtra("title")
        alarm.body = intent.getStringExtra("body")
        alarm.vibrate = intent.getBooleanExtra("vibrate", false)
        try {
            alarm.audio = Uri.parse(intent.getStringExtra("audio"))
        } catch (e: Exception) {
            alarm.audio = DataModel.dataModel.defaultAlarmRingtoneUri
        }
        println("[Android] Alarm received ${alarm.id}")
        AlarmStateManager.registerInstance(this, alarm)
    }


    private fun handleShowAlarms() {
        startActivity(
                Intent(this, MainActivity::class.java)
                    .putExtra("dart_entrypoint_args", arrayOf("""{"route": "notif_settings"}"""))
        )
    }

    companion object {
        fun dismissAlarm(id: Int, activity: Activity) {
            val context = activity.applicationContext
            AlarmStateManager.unregisterInstance(context, id)
        }

        fun snoozeAlarm(id: Int, activity: Activity) {
            val context = activity.applicationContext
            AlarmStateManager.snoozeInstance(context, id)
        }
    }
}
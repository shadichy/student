package dev.tlu.student.alarm

import android.app.ForegroundServiceStartNotAllowedException
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.annotation.RequiresApi
import dev.tlu.student.provider.Alarm
import dev.tlu.student.services.AudioService
import dev.tlu.student.services.NotificationHandler
import dev.tlu.student.services.VibrationService
import dev.tlu.student.services.VolumeService
import io.flutter.Log

class AlarmService : Service() {
    private var audioService: AudioService? = null
    private var vibrationService: VibrationService? = null
    private var volumeService: VolumeService? = null
    private var showSystemUI: Boolean = true

    companion object {
        @JvmStatic
        var ringingAlarmIds: List<Int> = listOf()

        const val STOP_ALARM = "STOP_ALARM"
    }

    override fun onCreate() {
        super.onCreate()

        audioService = AudioService(this)
        vibrationService = VibrationService(this)
        volumeService = VolumeService(this)
    }

    @RequiresApi(Build.VERSION_CODES.S)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent == null) {
            stopSelf()
            return START_NOT_STICKY
        }

        val action = intent.action
        if (action.equals(STOP_ALARM)) {
            val id: Int = intent.getIntExtra(Alarm.ID, -1)
            if (id != -1) stopAlarm(id)
            return START_NOT_STICKY
        }

        val alarm: Alarm = intent.getParcelableExtra(Alarm.NAME) ?: return START_NOT_STICKY

        // Handling notification
        val notificationHandler = NotificationHandler(this)
        val notification = notificationHandler.buildNotification(alarm)

        // Starting foreground service safely
        try {
            if (!alarm.highPrior) throw Exception()
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    startForeground(
                        alarm.id,
                        notification,
                        ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
                    )
                } else {
                    startForeground(alarm.id, notification)
                }
            } catch (e: ForegroundServiceStartNotAllowedException) {
                Log.e("AlarmService", "Foreground service start not allowed", e)
                throw e;
            } catch (e: SecurityException) {
                Log.e("AlarmService", "Security exception in starting foreground service", e)
                throw e;
            }
        } catch (e: Exception) {
            (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager?)
                ?.notify(alarm.id, notification)
        }

        AlarmPlugin.eventSink?.success(mapOf(Alarm.ID to alarm.id))

        if (alarm.volume in 0.0..1.0) {
            volumeService?.setVolume(alarm.volume, showSystemUI)
        }

        volumeService?.requestAudioFocus()

        audioService?.setOnAudioCompleteListener {
            if (!alarm.loopAudio) {
                vibrationService?.stopVibrating()
                volumeService?.restorePreviousVolume(showSystemUI)
                volumeService?.abandonAudioFocus()
            }
        }

        audioService?.playAudio(alarm.id, alarm.audio, alarm.loopAudio, alarm.fadeDuration)

        ringingAlarmIds = audioService?.getPlayingMediaPlayersIds()!!

        if (alarm.vibrate) vibrationService?.startVibrating(
            longArrayOf(0, 500, 500),
            if (alarm.loopVibrate) 1 else 0
        )

        // Wake up the device
        (getSystemService(Context.POWER_SERVICE) as PowerManager)
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "app:AlarmWakelockTag")
            .acquire(5 * 60 * 1000L) // 5 minutes

        val delayedStopIntent = Intent(this, AlarmReceiver::class.java)
            .putExtra(Alarm.ID, alarm.id)
            .setAction(STOP_ALARM)
        AlarmPlugin.handleDelayedAlarm(this, delayedStopIntent, alarm.endTime, alarm.id shl 1)

        return START_STICKY
    }

    private fun stopAlarm(id: Int) {
        try {
            val playingIds = audioService?.getPlayingMediaPlayersIds() ?: listOf()
            ringingAlarmIds = playingIds

            // Safely call methods on 'volumeService' and 'audioService'
            volumeService?.restorePreviousVolume(showSystemUI)
            volumeService?.abandonAudioFocus()

            audioService?.stopAudio(id)

            // Check if media player is empty safely
            vibrationService?.stopVibrating()
            if (audioService?.isMediaPlayerEmpty() == true) stopSelf()

            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    stopForeground(STOP_FOREGROUND_REMOVE)
                } else {
                    stopForeground(true)
                }
            } catch (e: Exception) {
                e.printStackTrace()
                (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager?)?.cancel(id)
            }
        } catch (e: IllegalStateException) {
            Log.e("AlarmService", "Illegal State: ${e.message}", e)
        } catch (e: Exception) {
            Log.e("AlarmService", "Error in stopping alarm: ${e.message}", e)
        }
    }

    override fun onDestroy() {
        ringingAlarmIds = listOf()

        audioService?.cleanUp()
        vibrationService?.stopVibrating()
        volumeService?.restorePreviousVolume(showSystemUI)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            stopForeground(true)
        }

        // Call the superclass method
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}

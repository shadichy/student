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
import dev.tlu.student.AlarmActivity
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
        val alarm: Alarm = intent.getParcelableExtra(Alarm.NAME) ?: return START_NOT_STICKY
        if (action == STOP_ALARM && alarm.id != -1) {
            stopAlarm(alarm.id)
            return START_NOT_STICKY
        }

        // Handling notification
        val notificationHandler = NotificationHandler(this)
        val appIntent = Intent(applicationContext, AlarmActivity::class.java)
        appIntent.putExtra(Alarm.ID, alarm.id)
        val notification = notificationHandler.buildNotification(alarm)

        // Starting foreground service safely
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
            val nm =
                applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager?
            try {
                nm?.cancel(alarm.id)
            } catch (_: Exception) {
            }
            Log.e("AlarmService", "Foreground service start not allowed", e)
            return START_NOT_STICKY // Return if cannot start foreground service
        } catch (e: SecurityException) {
            Log.e("AlarmService", "Security exception in starting foreground service", e)
            return START_NOT_STICKY // Return on security exception
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

        if (alarm.vibrate) {
            vibrationService?.startVibrating(longArrayOf(0, 500, 500), 1)
        }

        // Wake up the device
        val wakeLock = (getSystemService(Context.POWER_SERVICE) as PowerManager)
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "app:AlarmWakelockTag")
        wakeLock.acquire(5 * 60 * 1000L) // 5 minutes

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

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                stopForeground(STOP_FOREGROUND_REMOVE)
            } else {
                stopForeground(true)
            }
            val nm =
                applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager?
            try {
                nm?.cancel(id)
            } catch (_: Exception) {
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

        stopForeground(true)

        // Call the superclass method
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}

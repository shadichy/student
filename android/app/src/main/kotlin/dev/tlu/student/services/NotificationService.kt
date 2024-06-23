package dev.tlu.student.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.os.Build
import androidx.activity.R
import androidx.annotation.RequiresApi
import dev.tlu.student.AlarmActivity
import dev.tlu.student.alarm.AlarmReceiver
import dev.tlu.student.alarm.AlarmService
import dev.tlu.student.provider.Alarm

class NotificationHandler(private val context: Context) {
    companion object {
        private const val CHANNEL_ID = "alarm_plugin_channel"
        private const val CHANNEL_NAME = "Alarm Notification"
    }

    init {
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                setSound(null, null)
            }

            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    fun buildNotification(alarm: Alarm): Notification {
        val appIconResId = dev.tlu.student.R.drawable.ic_launcher_monochrome
//        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName) ?: Intent()
        val intent = Intent(context, AlarmActivity::class.java)
        intent.putExtra(Alarm.ID, alarm.id)
        val notificationPendingIntent = PendingIntent.getActivity(
            context,
            alarm.id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // If the alarm is ringing, stop the alarm service for this ID
        val stopIntent = Intent(context, AlarmReceiver::class.java)
        stopIntent.action = AlarmService.STOP_ALARM
        stopIntent.putExtra(Alarm.ID, alarm.id)

        val notificationDeleteIntent = PendingIntent.getBroadcast(
            context,
            alarm.id,
            stopIntent,
            PendingIntent.FLAG_CANCEL_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notificationBuilder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, CHANNEL_ID) // For API 26 and above
        } else {
            Notification.Builder(context) // For lower API levels
        }

        notificationBuilder
            .setSmallIcon(appIconResId)
            .setContentTitle(alarm.label)
            .setContentText(alarm.body)
            .setPriority(Notification.PRIORITY_MAX)
            .setCategory(Notification.CATEGORY_ALARM)
            .setAutoCancel(false)
            .setOngoing(true)
            .setContentIntent(notificationPendingIntent)
            .setSound(
                RingtoneManager.getActualDefaultRingtoneUri(
                    context,
                    RingtoneManager.TYPE_NOTIFICATION
                )
            )
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .addAction(
                R.drawable.notification_action_background,
                "Details",
                notificationPendingIntent
            )
            .addAction(
                R.drawable.notification_action_background,
                "Got it!",
                notificationDeleteIntent
            )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            notificationBuilder.setForegroundServiceBehavior(Notification.FOREGROUND_SERVICE_IMMEDIATE)
        }

        notificationBuilder.setFullScreenIntent(notificationPendingIntent, true)

        return notificationBuilder.build()
    }
}
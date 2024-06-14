/*
 * Copyright (C) 2020 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package dev.tlu.student.alarms

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.content.res.Resources
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import dev.tlu.student.AlarmActivity
import dev.tlu.student.provider.Alarm
import dev.tlu.student.provider.AlarmState

internal object AlarmNotifications {
    private const val ALARM_CHANNEL_ID = "alarmNotification"
    private const val ALARM_FIRING_NOTIFICATION_ID = Int.MAX_VALUE - 7

    @JvmStatic
    @Synchronized
    fun showHighPriorityNotification(
            context: Context,
            alarm: Alarm
    ) {
//        Logger.log("Displaying high priority notification for alarm instance: " + alarm.id)
        val icon = context.packageManager.getApplicationInfo(context.packageName, 0).icon

        val builder: NotificationCompat.Builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationCompat.Builder(context, ALARM_CHANNEL_ID) // For API 26 and above
        } else {
            NotificationCompat.Builder(context) // For lower API levels
        }
        
        builder
                .setShowWhen(false)
                .setContentTitle(alarm.label)
                .setContentText(alarm.body)
                .setSmallIcon(icon)
                .setAutoCancel(false)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_EVENT)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setLocalOnly(true)


        // Setup up dismiss action
        val dismissIntent: Intent = AlarmStateManager.createStateChangeIntent(context,
                AlarmStateManager.ALARM_DISMISS_TAG, alarm, AlarmState.DISMISSED_STATE)
        val id = alarm.id
        builder.addAction(icon,
                "Got it!",
                PendingIntent.getService(context, id,
                        dismissIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE))

        // Setup content action if instance is owned by alarm
        val viewAlarmIntent: Intent = Intent(context, AlarmActivity::class.java)
        viewAlarmIntent.putExtra("id", id)
        builder.setContentIntent(PendingIntent.getActivity(context, id,
                viewAlarmIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE))

        val nm: NotificationManagerCompat = NotificationManagerCompat.from(context)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                    ALARM_CHANNEL_ID,
                    ALARM_CHANNEL_ID,
                    NotificationManager.IMPORTANCE_HIGH)
            nm.createNotificationChannel(channel)
        }
        val notification: Notification = builder.build()
        nm.notify(id, notification)
//        updateUpcomingAlarmGroupNotification(context, -1, notification)
    }

    @Synchronized
    fun showAlarmNotification(service: Service, alarm: Alarm) {
//        LogUtils.v("Displaying alarm notification for alarm instance: " + alarm.mId)

        val resources: Resources = service.getResources()
        val icon = service.packageManager.getApplicationInfo(service.packageName, 0).icon
        val notification: NotificationCompat.Builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationCompat.Builder(service, ALARM_CHANNEL_ID) // For API 26 and above
        } else {
            NotificationCompat.Builder(service) // For lower API levels
        }

        notification
                .setContentTitle(alarm.label)
                .setContentText(alarm.body)
                .setSmallIcon(icon)
                .setOngoing(true)
                .setAutoCancel(false)
                .setDefaults(NotificationCompat.DEFAULT_LIGHTS)
                .setWhen(0)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setLocalOnly(true)

        // Setup Snooze Action
//        val snoozeIntent: Intent = AlarmStateManager.createStateChangeIntent(service,
//                AlarmStateManager.ALARM_SNOOZE_TAG, alarm, AlarmState.SNOOZE_STATE)
//        snoozeIntent.putExtra(AlarmStateManager.FROM_NOTIFICATION_EXTRA, true)
//        val snoozePendingIntent: PendingIntent = PendingIntent.getService(service,
//                ALARM_FIRING_NOTIFICATION_ID, snoozeIntent, PendingIntent.FLAG_UPDATE_CURRENT)
//        notification.addAction(icon,
//                resources.getString(0), snoozePendingIntent)

        // Setup Dismiss Action
        val dismissIntent: Intent = AlarmStateManager.createStateChangeIntent(service,
                AlarmStateManager.ALARM_DISMISS_TAG, alarm, AlarmState.DISMISSED_STATE)
        dismissIntent.putExtra(AlarmStateManager.FROM_NOTIFICATION_EXTRA, true)
        val dismissPendingIntent: PendingIntent = PendingIntent.getService(service,
            alarm.id, dismissIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        notification.addAction(icon, "Got it!", dismissPendingIntent)

        // Setup Content Action
        val contentIntent: Intent = Intent(service, AlarmActivity::class.java)
        contentIntent.putExtra("id", alarm.id)
        notification.setContentIntent(PendingIntent.getActivity(service,
            alarm.id, contentIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE))

        // Setup fullscreen intent
//        val fullScreenIntent: Intent = Intent(service, AlarmActivity::class.java)
//        fullScreenIntent.putExtra("id", alarm.id)
        // set action, so we can be different then content pending intent
        contentIntent.setAction("fullscreen_activity")
        contentIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_NO_USER_ACTION)
        notification.setFullScreenIntent(PendingIntent.getActivity(service,
            alarm.id, contentIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE),
                true)
        notification.setPriority(NotificationCompat.PRIORITY_MAX)

        val nm: NotificationManagerCompat = NotificationManagerCompat.from(service)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                ALARM_CHANNEL_ID,
                ALARM_CHANNEL_ID,
                NotificationManager.IMPORTANCE_MAX)
            nm.createNotificationChannel(channel)
        }
        clearNotification(service, alarm.id)
        val createNotification = notification.build()
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                service.startForeground(alarm.id, createNotification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
            } else {
                service.startForeground(alarm.id, notification.build())
            }
        } catch (e: Exception) {
            print(e.message)
            e.printStackTrace()
            nm.notify(alarm.id, createNotification)
        }
    }

    @JvmStatic
    @Synchronized
    fun clearNotification(context: Context, id: Int) {
//        LogUtils.v("Clearing notifications for alarm instance: " + alarm.mId)
        val nm: NotificationManagerCompat = NotificationManagerCompat.from(context)
        nm.cancel(id)
    }

}
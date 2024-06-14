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

package dev.tlu.student.data

import android.content.ContentResolver
import android.content.Context
import android.database.ContentObserver
import android.media.RingtoneManager
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.Settings

/**
 * All alarm data will eventually be accessed via this model.
 */
internal class AlarmModel(
    context: Context,
    /** The model from which settings are fetched.  */
//    private val mSettingsModel: SettingsModel
) {

    /** The uri of the default ringtone to play for new alarms; mirrors last selection.  */
    private var mDefaultAlarmRingtoneUri: Uri
    private var mDefaultNotificationRingtoneUri: Uri
    private var mDefaultPhoneRingtoneUri: Uri

    init {
        // Clear caches affected by system settings when system settings change.
        val cr: ContentResolver = context.contentResolver
        val observer: ContentObserver = SystemAlarmAlertChangeObserver()
        cr.registerContentObserver(Settings.System.DEFAULT_ALARM_ALERT_URI, false, observer)
        mDefaultAlarmRingtoneUri = RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_ALARM)
        mDefaultPhoneRingtoneUri= RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_RINGTONE)
        mDefaultNotificationRingtoneUri = RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_NOTIFICATION)
    }

    // Never set the silent ringtone as default; new alarms should always make sound by default.
    var defaultAlarmRingtoneUri: Uri
        get() = mDefaultAlarmRingtoneUri
        set(uri) {
            // Never set the silent ringtone as default; new alarms should always make sound by default.
            mDefaultAlarmRingtoneUri = uri
        }

    var defaultPhoneRingtoneUri: Uri
        get() = mDefaultPhoneRingtoneUri
        set(uri) {
            mDefaultPhoneRingtoneUri = uri
        }

    // Never set the silent ringtone as default; new alarms should always make sound by default.
    var defaultNotificationRingtoneUri: Uri
        get() = mDefaultNotificationRingtoneUri
        set(uri) {
            // Never set the silent ringtone as default; new alarms should always make sound by default.
            mDefaultNotificationRingtoneUri = uri
        }

//    val alarmCrescendoDuration: Long
//        get() = mSettingsModel.alarmCrescendoDuration
//
//    val alarmVolumeButtonBehavior: DataModel.AlarmVolumeButtonBehavior
//        get() = mSettingsModel.alarmVolumeButtonBehavior
//
//    val alarmTimeout: Int
//        get() = mSettingsModel.alarmTimeout
//
//    val snoozeLength: Int
//        get() = mSettingsModel.snoozeLength

    /**
     * This receiver is notified when system settings change. Cached information built on
     * those system settings must be cleared.
     */
    private inner class SystemAlarmAlertChangeObserver
        : ContentObserver(Handler(Looper.myLooper()!!))
}
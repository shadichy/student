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

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ContentResolver
import android.content.Context
import android.content.Context.ALARM_SERVICE
import android.content.Intent
import androidx.core.app.NotificationManagerCompat
import dev.tlu.student.MainActivity
import dev.tlu.student.data.DataModel
import dev.tlu.student.provider.Alarm
import dev.tlu.student.provider.AlarmState
import dev.tlu.student.utils.AsyncHandler
import dev.tlu.student.utils.Utils
import java.util.Calendar

/**
 * This class handles all the state changes for alarm instances. You need to
 * register all alarm instances with the state manager if you want them to
 * be activated. If a major time change has occurred (ie. TIMEZONE_CHANGE, TIMESET_CHANGE),
 * then you must also re-register instances to fix their states.
 *
 * Please see [) for special transitions when major time changes][.registerInstance]
 */
class AlarmStateManager : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (INDICATOR_ACTION == intent.action) {
            return
        }
        if (AlarmService.ALARM_ALERT_ACTION==intent.action) {
            val alarm: Alarm = intent.getParcelableExtra(Alarm.NAME) ?: return;
            scheduleInstanceStateChange(context, alarm.endTime, alarm, AlarmState.DISMISSED_STATE)
        }
//        DataModel.dataModel.init(context);

        val result: PendingResult = goAsync()
//        val wl: PowerManager.WakeLock = AlarmAlertWakeLock.createPartialWakeLock(context)
//        wl.acquire()
        AsyncHandler.post {
            handleIntent(context, intent)
            result.finish()
//            wl.release()
        }
    }

    /**
     * Abstract away how the current time is computed. If no implementation of this interface is
     * given the default is to return [Calendar.getInstance]. Otherwise, the factory
     * instance is consulted for the current time.
     */
    interface CurrentTimeFactory {
        val currentTime: Calendar
    }

    /**
     * Abstracts away how state changes are scheduled. The [AlarmManagerStateChangeScheduler]
     * implementation schedules callbacks within the system AlarmManager. Alternate
     * implementations, such as test case mocks can subvert this behavior.
     */
    interface StateChangeScheduler {
        fun scheduleInstanceStateChange(
            context: Context,
            time: Calendar,
            alarm: Alarm,
            newState: Int
        )

        fun cancelScheduledInstanceStateChange(context: Context, alarm: Alarm)
    }

    /**
     * Schedules state change callbacks within the AlarmManager.
     */
    private class AlarmManagerStateChangeScheduler : StateChangeScheduler {
        override fun scheduleInstanceStateChange(
            context: Context,
            time: Calendar,
            alarm: Alarm,
            newState: Int
        ) {
            val timeInMillis = time.timeInMillis
//            LogUtils.i("Scheduling state change %d to instance %d at %s (%d)", newState,
//                    alarm.mId, AlarmUtils.getFormattedTime(context, time), timeInMillis)
            val stateChangeIntent: Intent =
                createStateChangeIntent(context, ALARM_MANAGER_TAG, alarm, newState)
            // Treat alarm state change as high priority, use foreground broadcasts
            stateChangeIntent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND)
            val pendingIntent: PendingIntent =
                PendingIntent.getService(
                    context, alarm.id,
                    stateChangeIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

            val am: AlarmManager = context.getSystemService(ALARM_SERVICE) as AlarmManager
            if (Utils.isMOrLater) {
                // Ensure the alarm fires even if the device is dozing.
                am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, timeInMillis, pendingIntent)
            } else if (Utils.isKITKATOrLater){
                am.setExact(AlarmManager.RTC_WAKEUP, timeInMillis, pendingIntent)
            } else {
                am.set(AlarmManager.RTC_WAKEUP, timeInMillis, pendingIntent)
            }
            // println("[Android] scheduled ${alarm.id} at ${AlarmUtils.getAlarmText(context, alarm, false)}")
        }

        override fun cancelScheduledInstanceStateChange(context: Context, alarm: Alarm) {
//            LogUtils.v("Canceling instance " + instance.mId + " timers")

            // Create a PendingIntent that will match any one set for this instance
            val pendingIntent: PendingIntent? =
                PendingIntent.getService(
                    context, alarm.id,
                    createStateChangeIntent(context, ALARM_MANAGER_TAG, alarm, null),
                    PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
                )

            pendingIntent?.let {
                val am: AlarmManager = context.getSystemService(ALARM_SERVICE) as AlarmManager
                am.cancel(it)
                it.cancel()
            }
        }
    }

    companion object {
        // Intent action to trigger an instance state change.
        const val CHANGE_STATE_ACTION = "change_state"

        // Intent action to show the alarm and dismiss the instance
        const val SHOW_AND_DISMISS_ALARM_ACTION = "show_and_dismiss_alarm"

        // Intent action for an AlarmManager alarm serving only to set the next alarm indicators
        private const val INDICATOR_ACTION = "indicator"

        // System intent action to notify AppWidget that we changed the alarm text.
        const val ACTION_ALARM_CHANGED = "com.android.deskclock.ALARM_CHANGED"

        // Extra key to set the desired state change.
        const val ALARM_STATE_EXTRA = "intent.extra.alarm.state"

        // Extra key to indicate the state change was launched from a notification.
        const val FROM_NOTIFICATION_EXTRA = "intent.extra.from.notification"

        // Extra key to set the global broadcast id.
        private const val ALARM_GLOBAL_ID_EXTRA = "intent.extra.alarm.global.id"

        // Intent category tags used to dismiss, snooze or delete an alarm
        const val ALARM_DISMISS_TAG = "DISMISS_TAG"
        const val ALARM_SNOOZE_TAG = "SNOOZE_TAG"
        const val ALARM_DELETE_TAG = "DELETE_TAG"

        // Intent category tag used when schedule state change intents in alarm manager.
        private const val ALARM_MANAGER_TAG = "ALARM_MANAGER"

        // Buffer time in seconds to fire alarm instead of marking it missed.
        const val ALARM_FIRE_BUFFER = 15

        // A factory for the current time; can be mocked for testing purposes.
        private var sCurrentTimeFactory: CurrentTimeFactory? = null

        // Schedules alarm state transitions; can be mocked for testing purposes.
        private var sStateChangeScheduler: StateChangeScheduler = AlarmManagerStateChangeScheduler()

        private val currentTime: Calendar
            get() = (if (sCurrentTimeFactory == null) {
                DataModel.dataModel.calendar
            } else {
                sCurrentTimeFactory!!.currentTime
            })


        fun setCurrentTimeFactory(currentTimeFactory: CurrentTimeFactory?) {
            sCurrentTimeFactory = currentTimeFactory
        }

        fun setStateChangeScheduler(stateChangeScheduler: StateChangeScheduler?) {
            sStateChangeScheduler = stateChangeScheduler ?: AlarmManagerStateChangeScheduler()
        }

        /**
         * Update the next alarm stored in framework. This value is also displayed in digital
         * widgets and the clock tab in this app.
         */
//        private fun updateNextAlarm(context: Context) {
//            val nextAlarm = getNextFiringAlarm(context)
//
//            if (Utils.isPreL) {
//                updateNextAlarmInSystemSettings(context, nextAlarm)
//            } else {
//                updateNextAlarmInAlarmManager(context, nextAlarm)
//            }
//        }

        /**
         * Returns an alarm instance of an alarm that's going to fire next.
         *
         * @param context application context
         * @return an alarm instance that will fire earliest relative to current time.
         */
//        @JvmStatic
//        fun getNextFiringAlarm(context: Context): AlarmInstance? {
//            val cr: ContentResolver = context.getContentResolver()
//            val activeAlarmQuery: String =
//                    AlarmState.ALARM_STATE + "<" + AlarmState.FIRED_STATE
//            val alarmInstances = AlarmInstance.getInstances(cr, activeAlarmQuery)
//
//            var nextAlarm: AlarmInstance? = null
//            for (instance in alarmInstances) {
//                if (nextAlarm == null || instance.alarmTime.before(nextAlarm.alarmTime)) {
//                    nextAlarm = instance
//                }
//            }
//            return nextAlarm
//        }

        /**
         * Used in pre-L devices, where "next alarm" is stored in system settings.
         */
//        @TargetApi(Build.VERSION_CODES.KITKAT)
//        private fun updateNextAlarmInSystemSettings(context: Context, nextAlarm: AlarmInstance?) {
//            // Format the next alarm time if an alarm is scheduled.
//            var time = ""
//            if (nextAlarm != null) {
//                time = AlarmUtils.getFormattedTime(context, nextAlarm.alarmTime)
//            }
//
//            try {
//                // Write directly to NEXT_ALARM_FORMATTED in all pre-L versions
//                Settings.System.putString(context.getContentResolver(), NEXT_ALARM_FORMATTED, time)
//                LogUtils.i("Updated next alarm time to: '$time'")
//
//                // Send broadcast message so pre-L AppWidgets will recognize an update.
//                context.sendBroadcast(Intent(ACTION_ALARM_CHANGED))
//            } catch (se: SecurityException) {
//                // The user has most likely revoked WRITE_SETTINGS.
//                LogUtils.e("Unable to update next alarm to: '$time'", se)
//            }
//        }

        /**
         * Used in L and later devices where "next alarm" is stored in the Alarm Manager.
        //         */
//        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
//        private fun updateNextAlarmInAlarmManager(context: Context, nextAlarm: AlarmInstance?) {
//            // Sets a surrogate alarm with alarm manager that provides the AlarmClockInfo for the
//            // alarm that is going to fire next. The operation is constructed such that it is
//            // ignored by AlarmStateManager.
//
//            val alarmManager: AlarmManager = context.getSystemService(ALARM_SERVICE) as AlarmManager
//
//            val flags = if (nextAlarm == null) PendingIntent.FLAG_NO_CREATE else 0
//            val operation: PendingIntent? = PendingIntent.getBroadcast(context, 0 /* requestCode */,
//                    createIndicatorIntent(context), flags)
//
//            if (nextAlarm != null) {
//                LogUtils.i("Setting upcoming AlarmClockInfo for alarm: " + nextAlarm.mId)
//                val alarmTime: Long = nextAlarm.alarmTime.timeInMillis
//
//                // Create an intent that can be used to show or edit details of the next alarm.
//                val viewIntent: PendingIntent =
//                        PendingIntent.getActivity(context, nextAlarm.hashCode(),
//                        AlarmNotifications.createViewAlarmIntent(context, nextAlarm),
//                        PendingIntent.FLAG_UPDATE_CURRENT)
//
//                val info = AlarmClockInfo(alarmTime, viewIntent)
//                Utils.updateNextAlarm(alarmManager, info, operation!!)
//            } else if (operation != null) {
//                LogUtils.i("Canceling upcoming AlarmClockInfo")
//                alarmManager.cancel(operation)
//            }
//        }

        /**
         * Used by dismissed and missed states, to update parent alarm. This will either
         * disable, delete or reschedule parent alarm.
         *
         * @param context application context
         * @param instance to update parent for
         */
//        private fun updateParentAlarm(context: Context, instance: AlarmInstance) {
//            val cr: ContentResolver = context.getContentResolver()
//            val alarm = Alarm.getAlarm(cr, instance.mAlarmId!!)
//            if (alarm == null) {
//                LogUtils.e("Parent has been deleted with instance: $instance")
//                return
//            }
//
//            if (!alarm.daysOfWeek.isRepeating) {
//                if (alarm.deleteAfterUse) {
//                    LogUtils.i("Deleting parent alarm: " + alarm.id)
//                    Alarm.deleteAlarm(cr, alarm.id)
//                } else {
//                    LogUtils.i("Disabling parent alarm: " + alarm.id)
//                    alarm.enabled = false
//                    Alarm.updateAlarm(cr, alarm)
//                }
//            } else {
//                // Schedule the next repeating instance which may be before the current instance if
//                // a time jump has occurred. Otherwise, if the current instance is the next instance
//                // and has already been fired, schedule the subsequent instance.
//                var nextRepeatedInstance = alarm.createInstanceAfter(currentTime)
//                if (instance.mAlarmState > AlarmState.FIRED_STATE &&
//                        nextRepeatedInstance.alarmTime == instance.alarmTime) {
//                    nextRepeatedInstance = alarm.createInstanceAfter(instance.alarmTime)
//                }
//
//                LogUtils.i("Creating new instance for repeating alarm " + alarm.id +
//                        " at " +
//                        AlarmUtils.getFormattedTime(context, nextRepeatedInstance.alarmTime))
//                AlarmInstance.addInstance(cr, nextRepeatedInstance)
//                registerInstance(context, nextRepeatedInstance, true)
//            }
//        }

        /**
         * Utility method to create a proper change state intent.
         *
         * @param context application context
         * @param tag used to make intent differ from other state change intents.
         * @param alarm to change state to
         * @param state to change to.
         * @return intent that can be used to change an alarm instance state
         */
        fun createStateChangeIntent(
            context: Context?,
            tag: String?,
            alarm: Alarm,
            state: Int?
        ): Intent {
            // This intent is directed to AlarmService, though the actual handling of it occurs here
            // in AlarmStateManager. The reason is that evidence exists showing the jump between the
            // broadcast receiver (AlarmStateManager) and service (AlarmService) can be thwarted by
            // the Out Of Memory killer. If clock is killed during that jump, firing an alarm can
            // fail to occur. To be safer, the call begins in AlarmService, which has the power to
            // display the firing alarm if needed, so no jump is needed.
            val intent: Intent = Intent(context, AlarmService::class.java)
            intent.putExtra(Alarm.NAME, alarm)
            intent.setAction(CHANGE_STATE_ACTION)
            intent.addCategory(tag)
//            intent.putExtra(ALARM_GLOBAL_ID_EXTRA, DataModel.dataModel.globalIntentId)
            if (state != null) {
                intent.putExtra(ALARM_STATE_EXTRA, state.toInt())
            }
            return intent
        }

        /**
         * Schedule alarm instance state changes with [AlarmManager].
         *
         * @param ctx application context
         * @param time to trigger state change
         * @param instance to change state to
         * @param newState to change to
         */
        private fun scheduleInstanceStateChange(
            ctx: Context,
            time: Calendar,
            alarm: Alarm,
            newState: Int
        ) {
            sStateChangeScheduler.scheduleInstanceStateChange(ctx, time, alarm, newState)
        }

        /**
         * Cancel all [AlarmManager] timers for instance.
         *
         * @param ctx application context
         * @param alarm to disable all [AlarmManager] timers
         */
        private fun cancelScheduledInstanceStateChange(ctx: Context, alarm: Alarm) {
            sStateChangeScheduler.cancelScheduledInstanceStateChange(ctx, alarm)
        }

        /**
         * This will set the alarm instance to the SILENT_STATE and update
         * the application notifications and schedule any state changes that need
         * to occur in the future.
         *
         * @param context application context
         * @param alarm to set state to
         */
        private fun setSilentState(context: Context, alarm: Alarm) {
//            LogUtils.i("Setting silent state to instance " + alarm.mId)

            // Update alarm in db
            val contentResolver: ContentResolver = context.getContentResolver()
//            instance.mAlarmState = AlarmState.SILENT_STATE
//            AlarmInstance.updateInstance(contentResolver, instance)

            // Setup instance notification and scheduling timers
            AlarmNotifications.clearNotification(context, alarm.id)
            scheduleInstanceStateChange(context, alarm.startTime, alarm, AlarmState.FIRED_STATE)
        }

        /**
         * This will set the alarm instance to the LOW_NOTIFICATION_STATE and update
         * the application notifications and schedule any state changes that need
         * to occur in the future.
         *
         * @param context application context
         * @param instance to set state to
         */
//        private fun setLowNotificationState(context: Context, instance: AlarmInstance) {
//            LogUtils.i("Setting low notification state to instance " + instance.mId)
//
//            // Update alarm state in db
//            val contentResolver: ContentResolver = context.getContentResolver()
//            instance.mAlarmState = AlarmState.LOW_NOTIFICATION_STATE
//            AlarmInstance.updateInstance(contentResolver, instance)
//
//            // Setup instance notification and scheduling timers
//            AlarmNotifications.showLowPriorityNotification(context, instance)
//            scheduleInstanceStateChange(context, instance.highNotificationTime,
//                    instance, AlarmState.HIGH_NOTIFICATION_STATE)
//        }

        /**
         * This will set the alarm instance to the HIDE_NOTIFICATION_STATE and update
         * the application notifications and schedule any state changes that need
         * to occur in the future.
         *
         * @param context application context
         * @param instance to set state to
         */
//        private fun setHideNotificationState(context: Context, instance: AlarmInstance) {
//            LogUtils.i("Setting hide notification state to instance " + instance.mId)
//
//            // Update alarm state in db
//            val contentResolver: ContentResolver = context.getContentResolver()
//            instance.mAlarmState = AlarmState.HIDE_NOTIFICATION_STATE
//            AlarmInstance.updateInstance(contentResolver, instance)
//
//            // Setup instance notification and scheduling timers
//            AlarmNotifications.clearNotification(context, instance)
//            scheduleInstanceStateChange(context, instance.highNotificationTime,
//                    instance, AlarmState.HIGH_NOTIFICATION_STATE)
//        }

        /**
         * This will set the alarm instance to the HIGH_NOTIFICATION_STATE and update
         * the application notifications and schedule any state changes that need
         * to occur in the future.
         *
         * @param context application context
         * @param alarm to set state to
         */
        private fun setHighNotificationState(context: Context, alarm: Alarm) {
//            LogUtils.i("Setting high notification state to instance " + instance.mId)

            // Update alarm state in db
//            val contentResolver: ContentResolver = context.getContentResolver()
//            instance.mAlarmState = AlarmState.HIGH_NOTIFICATION_STATE
//            AlarmInstance.updateInstance(contentResolver, instance)

            // Setup instance notification and scheduling timers
            AlarmNotifications.showHighPriorityNotification(context, alarm)
            scheduleInstanceStateChange(context, alarm.startTime, alarm, AlarmState.FIRED_STATE)
        }

        /**
         * This will set the alarm instance to the FIRED_STATE and update
         * the application notifications and schedule any state changes that need
         * to occur in the future.
         *
         * @param context application context
         * @param alarm to set state to
         */
        private fun setFiredState(context: Context, alarm: Alarm) {
//            LogUtils.i("Setting fire state to instance " + alarm.mId)

            // Update alarm state in db
//            val contentResolver: ContentResolver = context.getContentResolver()
//            alarm.mAlarmState = AlarmState.FIRED_STATE
//            AlarmInstance.updateInstance(contentResolver, alarm)

//            alarm.mAlarmId?.let {
//                // if the time changed *backward* and pushed an instance from missed back to fired,
//                // remove any other scheduled instances that may exist
//                AlarmInstance.deleteOtherInstances(context, contentResolver, it, alarm.mId)
//            }

//            Events.sendAlarmEvent(R.string.action_fire, 0)


            var timeout = alarm.startTime
            val now = DataModel.dataModel.calendar
            if (timeout.before(now)) {
                now.add(Calendar.SECOND, ALARM_FIRE_BUFFER)
                timeout=now
            }
            scheduleInstanceStateChange(
                context,
                timeout,
                alarm,
                AlarmState.FIRED_STATE
            )

            // Instance not valid anymore, so find next alarm that will fire and notify system
//            updateNextAlarm(context)
        }

        /**
         * This will set the alarm instance to the SNOOZE_STATE and update
         * the application notifications and schedule any state changes that need
         * to occur in the future.
         *
         * @param context application context
         * @param alarm to set state to
         */
        @JvmStatic
        fun setSnoozeState(
            context: Context,
            alarm: Alarm,
            showToast: Boolean
        ) {
            // Stop alarm if this instance is firing it
            AlarmService.stopAlarm(context, alarm.id)

            // Calculate the new snooze alarm time
            val snoozeMinutes = 5
            val newAlarmTime = alarm.startTime
            newAlarmTime.add(Calendar.MINUTE, snoozeMinutes)

            // Update alarm state and new alarm time in db.
//            LogUtils.i("Setting snoozed state to instance " + alarm.mId + " for " +
//                    AlarmUtils.getFormattedTime(context, newAlarmTime))
//            alarm.alarmTime = newAlarmTime
//            alarm.mAlarmState = AlarmState.SNOOZE_STATE
//            AlarmInstance.updateInstance(context.getContentResolver(), alarm)

            // Setup instance notification and scheduling timers
//            AlarmNotifications.showSnoozeNotification(context, alarm)
            scheduleInstanceStateChange(context, newAlarmTime, alarm, AlarmState.DISMISSED_STATE)

            // Display the snooze minutes in a toast.
//            if (showToast) {
//                val mainHandler = Handler(context.getMainLooper())
//                val myRunnable = Runnable {
//                    val displayTime =
//                        String.format(
//                            context
//                                    .getResources()
//                                    .getQuantityText(R.plurals.alarm_alert_snooze_set,
//                                            snoozeMinutes)
//                                    .toString(),
//                            snoozeMinutes)
//                    Toast.makeText(context, displayTime, Toast.LENGTH_LONG).show()
//                }
//                mainHandler.post(myRunnable)
//            }

            // Instance time changed, so find next alarm that will fire and notify system
//            updateNextAlarm(context)
        }

        /**
         * This will set the alarm instance to the MISSED_STATE and update
         * the application notifications and schedule any state changes that need
         * to occur in the future.
         *
         * @param context application context
         * @param instance to set state to
         */
//        fun setMissedState(context: Context, instance: AlarmInstance) {
//            LogUtils.i("Setting missed state to instance " + instance.mId)
//            // Stop alarm if this instance is firing it
//            AlarmService.stopAlarm(context, instance)
//
//            // Check parent if it needs to reschedule, disable or delete itself
//            if (instance.mAlarmId != null) {
//                updateParentAlarm(context, instance)
//            }
//
//            // Update alarm state
//            val contentResolver: ContentResolver = context.getContentResolver()
//            instance.mAlarmState = AlarmState.MISSED_STATE
//            AlarmInstance.updateInstance(contentResolver, instance)
//
//            // Setup instance notification and scheduling timers
//            AlarmNotifications.showMissedNotification(context, instance)
//            scheduleInstanceStateChange(context, instance.missedTimeToLive,
//                    instance, AlarmState.DISMISSED_STATE)
//
//            // Instance is not valid anymore, so find next alarm that will fire and notify system
//            updateNextAlarm(context)
//        }

        /**
         * This will set the alarm instance to the PREDISMISSED_STATE and schedule an instance state
         * change to DISMISSED_STATE at the regularly scheduled firing time.
         *
         * @param context application context
         * @param alarm to set state to
         */
//        @JvmStatic
//        fun setPreDismissState(context: Context, instance: AlarmInstance) {
//            LogUtils.i("Setting predismissed state to instance " + instance.mId)
//
//            // Update alarm in db
//            val contentResolver: ContentResolver = context.getContentResolver()
//            instance.mAlarmState = AlarmState.PREDISMISSED_STATE
//            AlarmInstance.updateInstance(contentResolver, instance)
//
//            // Setup instance notification and scheduling timers
//            AlarmNotifications.clearNotification(context, instance)
//            scheduleInstanceStateChange(context, instance.alarmTime, instance,
//                    AlarmState.DISMISSED_STATE)
//
//            // Check parent if it needs to reschedule, disable or delete itself
//            if (instance.mAlarmId != null) {
//                updateParentAlarm(context, instance)
//            }
//
//            updateNextAlarm(context)
//        }

        /**
         * This just sets the alarm instance to DISMISSED_STATE.
         */
        @JvmStatic
        fun setDismissState(context: Context, alarm: Alarm) {
            scheduleInstanceStateChange(context, alarm.endTime, alarm, AlarmState.DISMISSED_STATE)
        }

        /**
         * This will delete the alarm instance, update the application notifications, and schedule
         * any state changes that need to occur in the future.
         *
         * @param context application context
         * @param id to set state to
         */
        @JvmStatic
        fun deleteInstanceAndUpdateParent(context: Context, id: Int) {
//            LogUtils.i("Deleting instance " + instance.mId + " and updating parent alarm.")

            // Remove all other timers and notifications associated to it
            unregisterInstance(context, id)

            // Check parent if it needs to reschedule, disable or delete itself
//            if (instance.mAlarmId != null) {
//                updateParentAlarm(context, instance)
//            }

            // Delete instance as it is not needed anymore
//            AlarmInstance.deleteInstance(context.getContentResolver(), instance.mId)

            // Instance is not valid anymore, so find next alarm that will fire and notify system
//            updateNextAlarm(context)
        }

        /**
         * This will set the instance state to DISMISSED_STATE and remove its notifications and
         * alarm timers.
         *
         * @param context application context
         * @param alarm to unregister
         */
        fun unregisterInstance(context: Context, id: Int) {
            AlarmService.stopAlarm(context, id)
            AlarmNotifications.clearNotification(context, id)
        }

        fun snoozeInstance(context: Context, id: Int) {
            AlarmService.stopAlarm(context, id)
        }

        /**
         * This registers the AlarmInstance to the state manager. This will look at the instance
         * and choose the most appropriate state to put it in. This is primarily used by new
         * alarms, but it can also be called when the system time changes.
         *
         * Most state changes are handled by the states themselves, but during major time changes we
         * have to correct the alarm instance state. This means we have to handle special cases as
         * describe below:
         *
         *
         *  * Make sure all dismissed alarms are never re-activated
         *  * Make sure pre-dismissed alarms stay predismissed
         *  * Make sure firing alarms stayed fired unless they should be auto-silenced
         *  * Missed instance that have parents should be re-enabled if we went back in time
         *  * If alarm was SNOOZED, then show the notification but don't update time
         *  * If low priority notification was hidden, then make sure it stays hidden
         *
         *
         * If none of these special case are found, then we just check the time and see what is the
         * proper state for the instance.
         *
         * @param context application context
         * @param alarm to register
         */
        @JvmStatic
        fun registerInstance(
            context: Context,
            alarm: Alarm,
//                updateNextAlarm: Boolean
        ) {
            if (!alarm.enabled) return
            // println("[Android] Alarm with id ${alarm.id} registering at ${AlarmUtils.getAlarmText(context, alarm, false)}")
//            LogUtils.i("Registering instance: " + instance.mId)
//            val cr: ContentResolver = context.getContentResolver()
            val currentTime = currentTime
            val alarmTime: Calendar = alarm.startTime
            val timeoutTime: Calendar = alarm.endTime
//            val lowNotificationTime: Calendar = alarm.lowNotificationTime
//            val highNotificationTime: Calendar = alarm.highNotificationTime
//            val missedTTL: Calendar = alarm.missedTimeToLive
//
//            // Handle special use cases here
            if (currentTime.after(timeoutTime)) {
                // This should never happen, but add a quick check here
//                LogUtils.e("Alarm Instance is dismissed, but never deleted")
                // println("[Android] deleted ${alarm.id}")
                unregisterInstance(context, alarm.id)
                return
            } else if (currentTime.after(alarmTime)) {
                // There is a chance that the TIME_SET occurred right when the alarm should go off,
                // so we need to add a check to see if we should fire the alarm instead of marking
                // it missed.
                val alarmBuffer = alarm.endTime
                // println("[Android] fired ${alarm.id}")
                if (currentTime.before(alarmBuffer)) {
                    setFiredState(context, alarm)
                }
            } else {
                // Alarm is still active, so initialize as a silent alarm
                // println("[Android] delayed ${alarm.id}")
                setSilentState(context, alarm)
            }
        }

        /**
         * This will delete and unregister all instances associated with alarmId, without affect
         * the alarm itself. This should be used whenever modifying or deleting an alarm.
         *
         * @param context application context
         * @param alarmId to find instances to delete.
         */
//        @JvmStatic
//        fun deleteAllInstances(context: Context, alarmId: Long) {
//            LogUtils.i("Deleting all instances of alarm: $alarmId")
//            val cr: ContentResolver = context.getContentResolver()
//            val instances = AlarmInstance.getInstancesByAlarmId(cr, alarmId)
//            for (instance in instances) {
//                unregisterInstance(context, instance)
//                AlarmInstance.deleteInstance(context.getContentResolver(), instance.mId)
//            }
//            updateNextAlarm(context)
//        }

        /**
         * Delete and unregister all instances unless they are snoozed. This is used whenever an
         * alarm is modified superficially (label, vibrate, or ringtone change).
         */
//        fun deleteNonSnoozeInstances(context: Context, alarmId: Long) {
//            LogUtils.i("Deleting all non-snooze instances of alarm: $alarmId")
//            val cr: ContentResolver = context.getContentResolver()
//            val instances = AlarmInstance.getInstancesByAlarmId(cr, alarmId)
//            for (instance in instances) {
//                if (instance.mAlarmState == AlarmState.SNOOZE_STATE) {
//                    continue
//                }
//                unregisterInstance(context, instance)
//                AlarmInstance.deleteInstance(context.getContentResolver(), instance.mId)
//            }
//            updateNextAlarm(context)
//        }

        /**
         * Fix and update all alarm instance when a time change event occurs.
         *
         * @param context application context
         */
//        @JvmStatic
//        fun fixAlarmInstances(context: Context) {
//            LogUtils.i("Fixing alarm instances")
//            // Register all instances after major time changes or when phone restarts
//            val contentResolver: ContentResolver = context.getContentResolver()
//            val currentTime = currentTime
//
//            // Sort the instances in reverse chronological order so that later instances are fixed
//            // or deleted before re-scheduling prior instances (which may re-create or update the
//            // later instances).
//            val instances = AlarmInstance.getInstances(
//                    contentResolver, null /* selection */)
//            instances.sortWith(Comparator { lhs, rhs -> rhs.alarmTime.compareTo(lhs.alarmTime) })
//
//            for (instance in instances) {
//                val alarm = Alarm.getAlarm(contentResolver, instance.mAlarmId!!)
//                if (alarm == null) {
//                    unregisterInstance(context, instance)
//                    AlarmInstance.deleteInstance(contentResolver, instance.mId)
//                    LogUtils.e("Found instance without matching alarm; deleting instance %s",
//                            instance)
//                    continue
//                }
//                val priorAlarmTime = alarm.getPreviousAlarmTime(instance.alarmTime)
//                val missedTTLTime: Calendar = instance.missedTimeToLive
//                if (currentTime.before(priorAlarmTime) || currentTime.after(missedTTLTime)) {
//                    val oldAlarmTime: Calendar = instance.alarmTime
//                    val newAlarmTime = alarm.getNextAlarmTime(currentTime)
//                    val oldTime: CharSequence =
//                            DateFormat.format("MM/dd/yyyy hh:mm a", oldAlarmTime)
//                    val newTime: CharSequence =
//                            DateFormat.format("MM/dd/yyyy hh:mm a", newAlarmTime)
//                    LogUtils.i("A time change has caused an existing alarm scheduled" +
//                            " to fire at %s to be replaced by a new alarm scheduled to fire at %s",
//                            oldTime, newTime)
//
//                    // The time change is so dramatic the AlarmInstance doesn't make any sense;
//                    // remove it and schedule the new appropriate instance.
//                    deleteInstanceAndUpdateParent(context, instance)
//                } else {
//                    registerInstance(context, instance, false /* updateNextAlarm */)
//                }
//            }
//
//            updateNextAlarm(context)
//        }

        /**
         * Utility method to set alarm instance state via constants.
         *
         * @param context application context
         * @param alarm to change state on
         * @param state to change to
         */
        private fun setAlarmState(context: Context, alarm: Alarm?, state: Int) {
            if (alarm == null) {
//                LogUtils.e("Null alarm instance while setting state to %d", state)
                return
            }
//            setHighNotificationState(context, alarm)
            when (state) {
                AlarmState.SILENT_STATE -> setSilentState(context, alarm)
//                AlarmState.LOW_NOTIFICATION_STATE -> {
//                    setLowNotificationState(context, alarm)
//                }
//                AlarmState.HIDE_NOTIFICATION_STATE -> {
//                    setHideNotificationState(context, alarm)
//                }
                AlarmState.HIGH_NOTIFICATION_STATE -> setHighNotificationState(context, alarm)
                AlarmState.FIRED_STATE -> setFiredState(context, alarm)
                AlarmState.SNOOZE_STATE -> setSnoozeState(context, alarm, true /* showToast */)
//                AlarmState.MISSED_STATE -> setMissedState(context, alarm)
//                AlarmState.PREDISMISSED_STATE -> setPreDismissState(context, alarm)
                AlarmState.DISMISSED_STATE -> unregisterInstance(context, alarm.id)
//                else -> LogUtils.e("Trying to change to unknown alarm state: $state")
            }
        }

        fun handleIntent(context: Context, intent: Intent) {
            val action: String? = intent.getAction()
//            LogUtils.v("AlarmStateManager received intent $intent")
            if (CHANGE_STATE_ACTION == action) {
//                val uri: Uri = intent.getData()!!
//                val instance: AlarmInstance? =
//                    AlarmInstance.getInstance(context.getContentResolver(),
//                        AlarmInstance.getId(uri))
//                if (instance == null) {
//                    LogUtils.e("Can not change state for unknown instance: $uri")
//                    return
//                }
//
//                val globalId = DataModel.dataModel.globalIntentId
//                val intentId: Int = intent.getIntExtra(ALARM_GLOBAL_ID_EXTRA, -1)
                val alarmState: Int = intent.getIntExtra(ALARM_STATE_EXTRA, -1)
                val alarm: Alarm = intent.getParcelableExtra(Alarm.NAME) ?: return
                //                if (intentId != globalId) {
//                    LogUtils.i("IntentId: " + intentId + " GlobalId: " + globalId +
//                            " AlarmState: " + alarmState)
//                    // Allows dismiss/snooze requests to go through
//                    if (!intent.hasCategory(ALARM_DISMISS_TAG) &&
//                            !intent.hasCategory(ALARM_SNOOZE_TAG)) {
//                        LogUtils.i("Ignoring old Intent")
//                        return
//                    }
//                }
//
//                if (intent.getBooleanExtra(FROM_NOTIFICATION_EXTRA, false)) {
//                    if (intent.hasCategory(ALARM_DISMISS_TAG)) {
//                        Events.sendAlarmEvent(R.string.action_dismiss, R.string.label_notification)
//                    } else if (intent.hasCategory(ALARM_SNOOZE_TAG)) {
//                        Events.sendAlarmEvent(R.string.action_snooze, R.string.label_notification)
//                    }
//                }
//
                if (alarmState >= 0) {
                    setAlarmState(context, alarm, alarmState)
                } else {
                    registerInstance(context, alarm)
                }
            } else if (SHOW_AND_DISMISS_ALARM_ACTION == action) {
//                val uri: Uri = intent.getData()!!
//                val instance: AlarmInstance? =
//                        AlarmInstance.getInstance(context.getContentResolver(),
//                        AlarmInstance.getId(uri))
                val id: Int = intent.getIntExtra("id", -1)

                try {
//                    LogUtils.e("Null alarminstance for SHOW_AND_DISMISS")
                    // dismiss the notification
                    if (id != -1) {
                        NotificationManagerCompat.from(context).cancel(id)
                    }
                    return
                } catch (e: Exception) {
                    e.printStackTrace()
                }

                val viewAlarmIntent: Intent =
                    Intent(context, MainActivity::class.java)
                        .putExtra("dart_entrypoint_args", arrayOf("""{"route": "notif_settings"}"""))
                        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

                // Open DeskClock which is now positioned on the alarms tab.
                context.startActivity(viewAlarmIntent)

                deleteInstanceAndUpdateParent(context, id)
            }
        }

        /**
         * Creates an intent that can be used to set an AlarmManager alarm to set the next alarm
         * indicators.
         */
        private fun createIndicatorIntent(context: Context?): Intent {
            return Intent(context, AlarmStateManager::class.java).setAction(INDICATOR_ACTION)
        }
    }
}
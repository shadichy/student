package dev.tlu.student.provider

interface AlarmState {
    companion object {

        /**
         * Alarm state when to show no notification.
         *
         * Can transitions to:
         * LOW_NOTIFICATION_STATE
         */
        const val SILENT_STATE = 0

        /**
         * Alarm state to show low priority alarm notification.
         *
         * Can transitions to:
         * HIDE_NOTIFICATION_STATE
         * HIGH_NOTIFICATION_STATE
         * DISMISSED_STATE
         */
        const val LOW_NOTIFICATION_STATE = 1

        /**
         * Alarm state to hide low priority alarm notification.
         *
         * Can transitions to:
         * HIGH_NOTIFICATION_STATE
         */
        const val HIDE_NOTIFICATION_STATE = 2

        /**
         * Alarm state to show high priority alarm notification.
         *
         * Can transitions to:
         * DISMISSED_STATE
         * FIRED_STATE
         */
        const val HIGH_NOTIFICATION_STATE = 3

        /**
         * Alarm state when alarm is in snooze.
         *
         * Can transitions to:
         * DISMISSED_STATE
         * FIRED_STATE
         */
        const val SNOOZE_STATE = 4

        /**
         * Alarm state when alarm is being fired.
         *
         * Can transitions to:
         * DISMISSED_STATE
         * SNOOZED_STATE
         * MISSED_STATE
         */
        const val FIRED_STATE = 5

        /**
         * Alarm state when alarm has been missed.
         *
         * Can transitions to:
         * DISMISSED_STATE
         */
        const val MISSED_STATE = 6

        /**
         * Alarm state when alarm is done.
         */
        const val DISMISSED_STATE = 7

        /**
         * Alarm state when alarm has been dismissed before its intended firing time.
         */
        const val PREDISMISSED_STATE = 8

        /**
         * Alarm year.
         *
         * Type: INTEGER
         */
        const val YEAR = "year"

        /**
         * Alarm month in year.
         *
         * Type: INTEGER
         */
        const val MONTH = "month"

        /**
         * Alarm day in month.
         *
         * Type: INTEGER
         */
        const val DAY = "day"

        /**
         * Alarm hour in 24-hour localtime 0 - 23.
         *
         * Type: INTEGER
         */
        const val HOUR = "hour"

        /**
         * Alarm minutes in localtime 0 - 59
         *
         * Type: INTEGER
         */
        const val MINUTES = "minutes"

        /**
         * Foreign key to Alarms table
         *
         * Type: INTEGER (long)
         */
        const val ALARM_ID = "alarm_id"

        /**
         * Alarm state
         *
         * Type: INTEGER
         */
        const val ALARM_STATE = "alarm_state"
    }
}

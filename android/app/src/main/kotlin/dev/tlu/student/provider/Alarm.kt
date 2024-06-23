package dev.tlu.student.provider

import android.os.Parcel
import android.os.Parcelable
import java.util.Calendar

class Alarm: Parcelable {
    // Public fields
    // TODO: Refactor instance names
    @JvmField
    var id: Int

    @JvmField
    var secondsSinceEpoch: Int

    @JvmField
    var duration: Int

    @JvmField
    var vibrate: Boolean

    @JvmField
    var loopVibrate: Boolean

    @JvmField
    var label: String

    @JvmField
    var body: String

    @JvmField
    var audio: String

    @JvmField
    var loopAudio: Boolean

    @JvmField
    var volume: Double

    @JvmField
    var fadeDuration: Double

    @JvmField
    var highPrior: Boolean

    // Creates a default alarm at the current time.
    constructor(id: Int, secondsSinceEpoch: Int, duration: Int) {
        this.id = id
        this.secondsSinceEpoch = secondsSinceEpoch
        this.duration = duration
        vibrate = true
        loopVibrate = false
        label = ""
        body= ""
        audio = ""
        loopAudio = false
        volume=-1.0
        fadeDuration=0.0
        // depends on the database, formerly 14 is the standard so 14+3=17 is used
        highPrior = id ushr 17 == 0
    }

    internal constructor(p: Parcel) {
        id = p.readInt()
        secondsSinceEpoch = p.readInt()
        duration = p.readInt()
        vibrate = p.readInt() == 1
        highPrior = p.readInt() == 1
        loopAudio = p.readInt() == 1
        loopVibrate = p.readInt() == 1
        volume = p.readDouble()
        fadeDuration = p.readDouble()
        label = p.readString() ?: ""
        body = p.readString() ?: ""
        audio = p.readString() ?: ""
    }
    override fun describeContents(): Int = 0


    override fun writeToParcel(p: Parcel, flags: Int) {
        p.writeInt(id)
        p.writeInt(secondsSinceEpoch)
        p.writeInt(duration)
        p.writeInt(if (vibrate) 1 else 0)
        p.writeInt(if (highPrior) 1 else 0)
        p.writeInt(if (loopAudio) 1 else 0)
        p.writeInt(if (loopVibrate) 1 else 0)
        p.writeDouble(volume)
        p.writeDouble(fadeDuration)
        p.writeString(label)
        p.writeString(body)
        p.writeString(audio)
    }


    override fun equals(other: Any?): Boolean {
        if (other !is Alarm) return false
        return id == other.id
    }

    override fun hashCode(): Int {
        return id.hashCode()
    }

    override fun toString(): String {
        return "Alarm{" +
                "audio=" + audio +
                ", id=" + id +
                ", secondsSinceEpoch=" + secondsSinceEpoch +
                ", duration=" + duration +
                ", vibrate=" + vibrate +
                ", label='" + label + '\'' +
                ", body='" + body + '\'' +
                '}'
    }

    val startTime: Calendar
        get() {
            val calendar = Calendar.getInstance()
            calendar.timeInMillis = secondsSinceEpoch.toLong() * 1000L
            return calendar
        }

    val endTime: Calendar
        get() {
            val calendar = startTime
            calendar.add(Calendar.SECOND, duration)
            return calendar
        }

    companion object {
        const val NAME = "alarm"
        const val ID = "id"

        @JvmField
        val CREATOR: Parcelable.Creator<Alarm> = object : Parcelable.Creator<Alarm>
        {
            override fun createFromParcel(parcel: Parcel): Alarm {
                return Alarm(parcel)
            }

            override fun newArray(size: Int): Array<Alarm?> {
                return arrayOfNulls(size)
            }

        }
    }
}
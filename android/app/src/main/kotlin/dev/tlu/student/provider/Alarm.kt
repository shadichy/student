package dev.tlu.student.provider

import android.net.Uri
import android.os.Parcel
import android.os.Parcelable
import java.util.Calendar

class Alarm: Parcelable {
    // Public fields
    // TODO: Refactor instance names
    @JvmField
    var id: Int

    @JvmField
    var enabled = true

    @JvmField
    var secondsSinceEpoch: Int

    @JvmField
    var duration: Int

    @JvmField
    var vibrate: Boolean

    @JvmField
    var label: String?

    @JvmField
    var body: String?

    @JvmField
    var audio: Uri? = null

    @JvmField
    var highPrior: Boolean

    // Creates a default alarm at the current time.
    constructor(id: Int, secondsSinceEpoch: Int, duration: Int) {
        this.id = id
        this.secondsSinceEpoch = secondsSinceEpoch
        this.duration = duration
        vibrate = true
        label = ""
        body= ""
        audio = null
        // depends on the database, formerly 14 is the standard so 14+2=16 is used
        highPrior = id shl 16 == 0
    }

    internal constructor(p: Parcel) {
        id = p.readInt()
        secondsSinceEpoch = p.readInt()
        duration = p.readInt()
        enabled = p.readInt() == 1
        vibrate = p.readInt() == 1
        highPrior = p.readInt() == 1
        label = p.readString()
        body = p.readString()
        audio = p.readParcelable(null)
    }
    override fun describeContents(): Int = 0


    override fun writeToParcel(p: Parcel, flags: Int) {
        p.writeInt(id)
        p.writeInt(secondsSinceEpoch)
        p.writeInt(duration)
        p.writeInt(if (enabled) 1 else 0)
        p.writeInt(if (vibrate) 1 else 0)
        p.writeInt(if (highPrior) 1 else 0)
        p.writeString(label)
        p.writeString(body)
        p.writeParcelable(audio, flags)
    }


    override fun equals(other: Any?): Boolean {
        if (other !is Alarm) return false
        return id == other.id
    }

    override fun hashCode(): Int {
        return java.lang.Integer.valueOf(id).hashCode()
    }

    override fun toString(): String {
        return "Alarm{" +
                "audio=" + audio +
                ", id=" + id +
                ", enabled=" + enabled +
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

    companion object CREATOR : Parcelable.Creator<Alarm> {
        override fun createFromParcel(parcel: Parcel): Alarm {
            return Alarm(parcel)
        }

        override fun newArray(size: Int): Array<Alarm?> {
            return arrayOfNulls(size)
        }
    }

}
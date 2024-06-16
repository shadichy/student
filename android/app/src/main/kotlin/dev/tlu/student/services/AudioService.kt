package dev.tlu.student.services

import android.content.Context
import android.media.MediaPlayer
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import io.flutter.Log
import java.util.Timer
import java.util.TimerTask
import java.util.concurrent.ConcurrentHashMap

class AudioService(private val context: Context) {
    private val mediaPlayers = ConcurrentHashMap<Int, MediaPlayer>()
    private val ringtonePlayers = ConcurrentHashMap<Int, Ringtone>()
    private val timers = ConcurrentHashMap<Int, Timer>()

    private var onAudioComplete: (() -> Unit)? = null

    fun setOnAudioCompleteListener(listener: () -> Unit) {
        onAudioComplete = listener
    }

    fun isMediaPlayerEmpty(): Boolean {
        return mediaPlayers.isEmpty() && ringtonePlayers.isEmpty()
    }

    fun getPlayingMediaPlayersIds(): List<Int> {
        return mediaPlayers.filter { (_, mediaPlayer) -> mediaPlayer.isPlaying }.keys.toList() +
                ringtonePlayers.filter { (_, ringtonePlayer) -> ringtonePlayer.isPlaying }.keys.toList()
    }

    fun playAudio(id: Int, filePath: String, loopAudio: Boolean, fadeDuration: Double?) {
        stopAudio(id) // Stop and release any existing MediaPlayer and Timer for this ID
        println("[Android] file path $filePath")

        val adjustedFilePath = when {
            filePath.startsWith("assets/") -> "flutter_assets/$filePath"
            !filePath.startsWith("/") -> "${context.filesDir.parent}/app_flutter/$filePath"
            else -> filePath
        }

        try {
            MediaPlayer().apply {
                when {
                    adjustedFilePath.startsWith("flutter_assets/") -> {
                        // It's an asset file
                        val assetManager = context.assets
                        val descriptor = assetManager.openFd(adjustedFilePath)
                        setDataSource(
                            descriptor.fileDescriptor,
                            descriptor.startOffset,
                            descriptor.length
                        )
                    }

                    adjustedFilePath.startsWith("content://") -> {
                        setDataSource(context, Uri.parse(adjustedFilePath))
                    }

                    else -> {
                        // Handle local files and adjusted paths
                        setDataSource(adjustedFilePath)
                    }
                }

                prepare()
                isLooping = loopAudio
                start()

                setOnCompletionListener {
                    if (!loopAudio) {
                        onAudioComplete?.invoke()
                    }
                }

                mediaPlayers[id] = this

                if (fadeDuration != null && fadeDuration > 0) {
                    val timer = Timer(true)
                    timers[id] = timer
                    startFadeIn(this, fadeDuration, timer)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            Log.e("AudioService", "Error playing audio: $e")
            try {
                RingtoneManager.getRingtone(context, Uri.parse(adjustedFilePath)).apply {
                    ringtonePlayers[id] = this
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) isLooping = loopAudio
                    play()
                    setOnAudioCompleteListener {
                        if (!loopAudio) {
                            onAudioComplete?.invoke()
                        }
                    }

                    if (fadeDuration != null && fadeDuration > 0) {
                        val timer = Timer(true)
                        timers[id] = timer
                        startFadeIn(this, fadeDuration, timer)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    fun stopAudio(id: Int) {
        timers[id]?.cancel()
        timers.remove(id)

        if (mediaPlayers.containsKey(id)) {
            mediaPlayers[id]?.apply {
                if (isPlaying) {
                    stop()
                }
                reset()
                release()
            }
            mediaPlayers.remove(id)
        }

        if (ringtonePlayers.containsKey(id)) {
            ringtonePlayers[id]!!.apply {
                if (isPlaying) {
                    stop()
                }
            }
            ringtonePlayers.remove(id)
        }
    }

    private fun startFadeIn(mediaPlayer: MediaPlayer, duration: Double, timer: Timer) {
        val maxVolume = 1.0f
        val fadeDuration = (duration * 1000).toLong()
        val fadeInterval = 100L
        val numberOfSteps = fadeDuration / fadeInterval
        val deltaVolume = maxVolume / numberOfSteps
        var volume = 0.0f

        timer.schedule(object : TimerTask() {
            override fun run() {
                if (!mediaPlayer.isPlaying) {
                    cancel()
                    return
                }

                mediaPlayer.setVolume(volume, volume)
                volume += deltaVolume

                if (volume >= maxVolume) {
                    mediaPlayer.setVolume(maxVolume, maxVolume)
                    cancel()
                }
            }
        }, 0, fadeInterval)
    }

    private fun startFadeIn(ringtonePlayer: Ringtone, duration: Double, timer: Timer) {
        val maxVolume = 1.0f
        val fadeDuration = (duration * 1000).toLong()
        val fadeInterval = 100L
        val numberOfSteps = fadeDuration / fadeInterval
        val deltaVolume = maxVolume / numberOfSteps
        var volume = 0.0f

        timer.schedule(object : TimerTask() {
            override fun run() {
                if (!ringtonePlayer.isPlaying) {
                    cancel()
                    return
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    ringtonePlayer.volume = volume

                    volume += deltaVolume

                    if (volume >= maxVolume) {
                        ringtonePlayer.volume = maxVolume
                        cancel()
                    }
                }
            }
        }, 0, fadeInterval)
    }

    fun cleanUp() {
        timers.values.forEach(Timer::cancel)
        timers.clear()

        mediaPlayers.values.forEach { mediaPlayer ->
            if (mediaPlayer.isPlaying) {
                mediaPlayer.stop()
            }
            mediaPlayer.reset()
            mediaPlayer.release()
        }
        mediaPlayers.clear()

        ringtonePlayers.values.forEach { ringtonePlayer ->
            ringtonePlayer.apply {
                if (isPlaying) stop()
            }
        }
        ringtonePlayers.clear()
    }
}


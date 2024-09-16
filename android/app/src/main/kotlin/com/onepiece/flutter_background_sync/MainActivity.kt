package com.onepiece.flutter_background_sync

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import androidx.core.app.NotificationCompat
import com.umair.beacons_plugin.BeaconsPlugin
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    /*override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Create a notification channel for Android 8.0+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                "beacon_scan_channel",
                "Beacon Background Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }*/

    /*override fun onPause() {
        super.onPause()

        //Start Background service to scan BLE devices
        BeaconsPlugin.startBackgroundService(this)
    }

    override fun onResume() {
        super.onResume()

        //Stop Background service, app is in foreground
        BeaconsPlugin.stopBackgroundService(this)
    }*/
}

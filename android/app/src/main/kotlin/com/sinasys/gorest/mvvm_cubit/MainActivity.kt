package com.sinasys.gorest.mvvm_cubit

import android.location.Location
import androidx.annotation.NonNull
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private val CHANNEL = "my_location_plugin"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getCurrentLocation" -> getCurrentLocation(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun getCurrentLocation(result: MethodChannel.Result) {
        print("===getCurrentLocation")
        try {
            fusedLocationClient.lastLocation
                .addOnSuccessListener { location: Location? ->
                    if (location != null) {
                        print("===location $location")
                        result.success(location.isFromMockProvider)
                    } else {
                        result.error("ERROR", "Unable to fetch location", null)
                    }
                }
                .addOnFailureListener {
                    result.error("ERROR", "Unable to fetch location", null)
                }
        } catch (e: SecurityException) {
            result.error("ERROR", "Location permission denied", null)
        }
    }
}

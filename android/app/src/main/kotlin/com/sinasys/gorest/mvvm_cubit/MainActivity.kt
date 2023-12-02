package com.sinasys.gorest.mvvm_cubit

import android.annotation.SuppressLint
import android.location.Criteria
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private var isMockLocationEnabled = false
    private var locationManager: LocationManager? = null

    @SuppressLint("MissingPermission")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        forceCheckingMock()
    }

    @SuppressLint("MissingPermission")
    private fun forceCheckingMock() {
        locationManager?.requestLocationUpdates(LocationManager.GPS_PROVIDER, 2000, 10f, object: LocationListener{
            @SuppressLint("NewApi")
            override fun onLocationChanged(location: Location) {
                isMockLocationEnabled = location.isMock
            }

        })
    }

    override fun onResume() {
        super.onResume()
        forceCheckingMock()
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "request_check_mock").setMethodCallHandler {
                call, result ->
            result.success(isMockLocationEnabled)
        }

    }
}

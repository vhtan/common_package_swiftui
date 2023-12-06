package com.sinasys.gorest.mvvm_cubit

import android.Manifest
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.tasks.OnSuccessListener
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private var isMockLocationEnabled = false
    private var locationManager: LocationManager? = null

    private val REQUEST_LOCATION_PERMISSION = 1
//    private var fusedLocationClient: FusedLocationProviderClient? = null

    @SuppressLint("MissingPermission")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

//        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this);
        // Check location permission at runtime
        if (ContextCompat.checkSelfPermission(
                this,
                android.Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            // Permission is granted, proceed to request location updates
            locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
            forceCheckingMock()
        } else {
            // Permission is not granted, request it from the user
            ActivityCompat.requestPermissions(
                this,
                arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION),
                REQUEST_LOCATION_PERMISSION
            )
        }
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

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

    }
}

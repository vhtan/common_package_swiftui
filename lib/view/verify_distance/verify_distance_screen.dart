import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';

class VerifyDistanceScreen extends StatefulWidget {
  final StopPointResponse stopPoint;
  final double arrivalLimitRadius;

  const VerifyDistanceScreen({
    super.key,
    required this.stopPoint,
    required this.arrivalLimitRadius,
  });

  @override
  State<StatefulWidget> createState() => _VerifyDistanceScreenState();
}

class _VerifyDistanceScreenState extends State<VerifyDistanceScreen> {
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  final Location _location = Location();
  Timer? _delayTimer;

  bool _doneDelayTimer = false;
  LocationData? _locationData;
  FarFromCheckInError? _farFromCheckInError;
  ForceRequestLocationError? _forceRequestLocationError;

  @override
  void initState() {
    logger.d('=====start initstate');
    checkLocationPermission();
    _delayTimer = Timer(const Duration(milliseconds: 1500), () {
      logger.d('===message');
      _doneDelayTimer = true;
      if (_locationData != null) {
        logger.d('===_locationData $_locationData');
        Navigator.pop(context, _locationData);
        return;
      }
      if (_farFromCheckInError != null) {
        logger.d('===_farFromCheckInError $_farFromCheckInError');
        Navigator.pop(context, _farFromCheckInError);
        return;
      }
      if (_forceRequestLocationError != null) {
        logger.d('===_forceRequestLocationError $_forceRequestLocationError');
        Navigator.pop(context, _forceRequestLocationError);
        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
      handleLocation(context);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PopScope(
        canPop: false,
        child: Center(
          child: ProgressDialog(
            isProgressed: false,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void handleLocation(BuildContext context) async {
    final data = await getCurrentLocation();
    final stopPointLocation = LocationData.fromMap({
      'longitude': widget.stopPoint.destination?.longitude,
      'latitude': widget.stopPoint.destination?.latitude,
    });
    if (data != null) {
      final isNeedCheckDistance = widget.arrivalLimitRadius > 0;
      final calDistance = calculateDistance(data, stopPointLocation);
      if (isNeedCheckDistance && calDistance <= widget.arrivalLimitRadius) {
        if (!context.mounted) return;
        if (_doneDelayTimer) Navigator.pop(context, data);
        _locationData = data;
      } else {
        if (!context.mounted) return;
        _farFromCheckInError =
            const FarFromCheckInError(message: AppString.farFromCheckIn);
        if (_doneDelayTimer) Navigator.pop(context, _farFromCheckInError);
      }
    }
  }

  double calculateDistance(LocationData start, LocationData end) {
    double distance = Geolocator.distanceBetween(
      start.latitude ?? 0,
      start.longitude ?? 0,
      end.latitude ?? 0,
      end.longitude ?? 0,
    );
    return distance;
  }

  Future<LocationData?> getCurrentLocation() async {
    if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
      return await _location.getLocation();
    }
    return null;
  }

  Future<void> checkLocationPermission() async {
    if (!_serviceEnabled) {
      final serviceEnabled = await _location.requestService();
      setState(() {
        _serviceEnabled = serviceEnabled;
      });
      if (!_serviceEnabled) return;
    }
    PermissionStatus? permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.granted) {
      setState(() {
        _permissionGranted = permissionGranted;
      });
    } else {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {
        setState(() {
          _permissionGranted = permissionGranted;
        });
      } else if (permissionGranted == PermissionStatus.denied ||
          permissionGranted == PermissionStatus.deniedForever) {
        if (!context.mounted) return;
        _forceRequestLocationError = const ForceRequestLocationError(
            message: 'Bạn phải cung cấp quyền truy cập vị trí!');
        if (_doneDelayTimer) Navigator.pop(context, _forceRequestLocationError);
      }
    }
  }
}

Future<dynamic> showVerifyDistanceDialog({
  required context,
  required GlobalKey key,
  required StopPointResponse stopPoint,
  required double arrivalLimitRadius,
  required ValueChanged<LocationData> onVerifyLocationData,
  required ValueChanged<String> onError,
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return VerifyDistanceScreen(
        stopPoint: stopPoint,
        arrivalLimitRadius: arrivalLimitRadius,
        key: key,
      );
    },
  );
}

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: AppColors.primary,
    );
  }
}

class FarFromCheckInError {
  final String message;
  const FarFromCheckInError({
    required this.message,
  });
}

class ForceRequestLocationError {
  final String message;
  const ForceRequestLocationError({
    required this.message,
  });
}

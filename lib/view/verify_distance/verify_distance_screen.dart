import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';
import 'package:safe_device/safe_device.dart';

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
  bool? _isSomethingWrong = null;
  PermissionStatus? _permissionGranted;
  final Location _location = Location();
  Timer? _delayTimer;

  bool _doneDelayTimer = false;
  LocationData? _locationData;
  FarFromCheckInError? _farFromCheckInError;
  ForceRequestLocationError? _forceRequestLocationError;

  @override
  void initState() {
    checkLocationPermission();
    _delayTimer = Timer(const Duration(milliseconds: 1500), () {
      _doneDelayTimer = true;
      if (_locationData != null) {
        Navigator.pop(context, _locationData);
        return;
      }
      if (_farFromCheckInError != null) {
        Navigator.pop(context, _farFromCheckInError);
        return;
      }
      if (_forceRequestLocationError != null) {
        Navigator.pop(context, _forceRequestLocationError);
        return;
      }
    });
    logger.d('====initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
      if (_isSomethingWrong != null && _isSomethingWrong == false) {
        handleLocation(context);
      }
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

  Future<bool> _isMockLocation() async {
    if (Platform.isIOS) return false;
    return await const MethodChannel('my_location_plugin')
        .invokeMethod('getCurrentLocation');
  }

  Future<bool> _checkWrong() async {
    try {
      bool isMock = await _isMockLocation();
      bool isRealDevice = await SafeDevice.isRealDevice;
      bool isJailBroken = await SafeDevice.isJailBroken;
      logger.d('isMock $isMock');
      logger.d('isRealDevice $isRealDevice');
      logger.d('isJailBroken $isJailBroken');
      return isMock || !isRealDevice || isJailBroken;
    } on PlatformException catch (e) {
      logger.d("Error checking mock location: $e");
      return false;
    }
  }

  void checkMockLocation() async {
    bool isWrong = await _checkWrong();
    if (!mounted) return;
    if (isWrong) {
      _farFromCheckInError =
          const FarFromCheckInError(message: AppString.fakeGPS);
      if (_doneDelayTimer) Navigator.pop(context, _farFromCheckInError);
    } else {
      setState(() {
        _isSomethingWrong = false;
      });
    }
  }

  void handleLocation(BuildContext context) async {
    final data = await getCurrentLocation();
    final stopPointLocation = LocationData.fromMap({
      'longitude': widget.stopPoint.destination?.longitude,
      'latitude': widget.stopPoint.destination?.latitude,
    });

    if (stopPointLocation.latitude == null ||
        stopPointLocation.longitude == null) {
      if (!context.mounted) return;
      _farFromCheckInError = const FarFromCheckInError(
          message: 'Không xác định được vị trí điểm đến!');
      if (_doneDelayTimer) Navigator.pop(context, _farFromCheckInError);
      return;
    }

    if (data != null) {
      final isNeedCheckDistance = widget.arrivalLimitRadius > 0;
      if (isNeedCheckDistance == false) {
        if (!context.mounted) return;
        if (_doneDelayTimer) Navigator.pop(context, data);
        _locationData = data;
        return;
      }
      final calDistance = calculateDistance(data, stopPointLocation);
      if (isNeedCheckDistance && calDistance <= widget.arrivalLimitRadius) {
        if (!context.mounted) return;
        if (_doneDelayTimer) Navigator.pop(context, data);
        _locationData = data;
      } else {
        if (!context.mounted) return;
        _farFromCheckInError = FarFromCheckInError(
            message:
                '${AppString.farFromCheckIn}. Khoảng cách giới hạn là: ${formatCurrency(widget.arrivalLimitRadius)}m. Khoảng cách hiện tại là ${formatCurrency(calDistance)}m.');
        if (_doneDelayTimer) Navigator.pop(context, _farFromCheckInError);
      }
    } else {
      if (!context.mounted) return;
      _farFromCheckInError =
          const FarFromCheckInError(message: AppString.canNotGetLocation);
      if (_doneDelayTimer) Navigator.pop(context, _farFromCheckInError);
    }
  }

  String formatCurrency(double amount) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return currencyFormatter.format(amount);
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
      checkMockLocation();
      setState(() {
        _permissionGranted = permissionGranted;
      });
    } else {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {
        checkMockLocation();
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

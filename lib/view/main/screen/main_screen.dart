import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/temp_form/temp_form_response.dart';
import 'package:mvvm_cubit/data/model/warning/warning_response.dart';
import 'package:mvvm_cubit/data/request/check_in/check_in_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/main.dart';
import 'package:mvvm_cubit/manager/hive_storage_manager.dart';
import 'package:mvvm_cubit/view/add_trip/add_trip_screen.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/check_point/check_point_screen.dart';
import 'package:mvvm_cubit/view/main/widget/trip_container.dart';
import 'package:mvvm_cubit/view/pending_trip/screen/pending_trip_screen.dart';
import 'package:mvvm_cubit/view/warnings_handler/screen/warnings_handler_screen.dart';
import 'package:mvvm_cubit/view/webview/webview_screen.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  Location location = Location();

  TripResponse? _trip;
  TempFormResponse? _tempForm;
  List<WarningResponse>? _warningList;
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  final _cubit = MainCubit(repository: di());
  static Timer? _fetchTrip;
  static Timer? _fetchWarning;
  final HiveStorageManager _hiveStorageManager = di();
  double _arrivalLimitRadius = 0;
  final _timerDuration = const Duration(seconds: 10);
  final GlobalKey<State> progressKey = GlobalKey<State>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getTrip();
      startFetchingWarning();

      checkLocationPermission();
      Future.delayed(const Duration(seconds: 2), () {
        _cubit.getWarningList();
        getCurrentLocation();
        _cubit.getTempFormDetails();
      });
    });
    AuthManager.setTokenExpiredCallback(() {
      cancelFetchingTrip();
      cancelFetchingWarning();
      navigateTo(
        const LoginScreen(),
      );
    });

    _hiveStorageManager.getLoginData().then(
      (value) {
        setState(() {
          _arrivalLimitRadius = value?.arrivalLimitRadius ?? 0;
        });
      },
    );

    WidgetsBinding.instance.addObserver(this);
  }

  void startFetchingTrip() {
    cancelFetchingTrip();
    _fetchTrip = Timer.periodic(
      _timerDuration,
      (timer) {
        // _cubit.getTrip();
      },
    );
  }

  static void cancelFetchingTrip() {
    _fetchTrip?.cancel();
    _fetchTrip = null;
  }

  void startFetchingWarning() {
    cancelFetchingWarning();
    _fetchWarning = Timer.periodic(
      _timerDuration,
      (timer) {
        _cubit.getWarningList();
        _cubit.getTempFormDetails();
      },
    );
  }

  @override
  void dispose() {
    cancelFetchingTrip();
    cancelFetchingWarning();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  static void cancelFetchingWarning() {
    _fetchWarning?.cancel();
    _fetchWarning = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      logger.d('===AppLifecycleState.resumed');
      startFetchingWarning();
    } else if (state == AppLifecycleState.inactive) {
      logger.d('===AppLifecycleState.inactive');
      cancelFetchingWarning();
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
      return await location.getLocation();
    }
    return null;
  }

  void checkLocationPermission() async {
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(create: (context) => _cubit),
      ],
      child: Scaffold(
        body: BlocConsumer<MainCubit, GenericCubitState>(
          listener: (context, state) {
            switch (state.status) {
              case Status.failure:
                if (progressKey.currentContext != null) {
                  Navigator.pop(context);
                }
                showErrorSnackBar(
                  context,
                  state.error ?? AppString.sendTimeOut,
                );
              case Status.success:
                logger.d('main success $state');
                final data = state.data;
                if (data is GetWarningListMainState) {
                  setState(() {
                    _warningList = data.warningList;
                  });
                } else if (data is GetTripMainState) {
                  setState(() {
                    _trip = data.trip;
                  });
                } else if (data is GetTempFormDetailsMainState) {
                  setState(() {
                    _tempForm = data.tempForm;
                  });
                } else if (data is EmptyTripMainState) {
                  setState(() {
                    _trip = null;
                  });
                } else if (data is EmptyTempFormMainState) {
                  setState(() {
                    _tempForm = null;
                  });
                } else if (data is DidDeleteTripMainState) {
                  setState(() {
                    _tempForm = null;
                  });
                } else if (data is DidCloseTripMainState) {
                  setState(() {
                    _tempForm = null;
                  });
                }
              default:
                break;
            }
          },
          builder: (context, state) {
            return BlocBuilder<MainCubit, GenericCubitState<MainState>>(
              builder: (context, state) {
                return Column(
                  children: [
                    warningWidgetList(),
                    if (_trip != null && _tempForm == null)
                      Expanded(
                        child: currentTrip(context, _trip!),
                      ),
                    if (_tempForm != null && _trip == null)
                      Expanded(
                        child: pendingTrip(),
                      ),
                    if (_trip == null && _tempForm == null)
                      Expanded(
                        child: noTrip(),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void navigateTo(Widget screen) {
    if (!mounted) return;
    final name = screen.runtimeType.toString();
    logger.d('navigateTo $name');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(
          name: name,
        ),
      ),
    );
  }

  Widget currentTrip(BuildContext context, TripResponse trip) {
    return TripContainer(
      trip: trip,
      onArrived: (stopPoint) async {
        _locationData = await getCurrentLocation();
        final stopPointLocation = LocationData.fromMap({
          'longitude': stopPoint.destination?.longitude,
          'latitude': stopPoint.destination?.latitude,
        });
        if (_locationData != null) {
          final isNeedCheckDistance = _arrivalLimitRadius > 0;
          final calDistance =
              calculateDistance(_locationData!, stopPointLocation);

          if (isNeedCheckDistance && calDistance > _arrivalLimitRadius) {
            // ignore: use_build_context_synchronously
            showErrorSnackBar(
              context,
              AppString.farFromCheckIn,
            );
          } else {
            // ignore: use_build_context_synchronously
            await showDialog(
              context: context,
              builder: (context) => CheckPointScreen(
                didCapture: (imagePath) => _cubit.submitArrived(
                  CheckInRequest(
                      id: stopPoint.id,
                      imagePath: imagePath,
                      latitude: _locationData?.latitude ?? 0,
                      longitude: _locationData?.longitude ?? 0),
                ),
              ),
              barrierDismissible: false,
            );
          }
        }
      },
      onConfirm: (value) {
        navigateTo(
          WebViewCustom(
            title: 'Xác nhận PYC: $value',
            jobRequestId: trip.routeId ?? 0,
          ),
        );
      },
      onFinihed: (value) {
        navigateTo(
          WebViewCustom(
            title: 'Hoàn thành PYC: $value',
            jobRequestId: trip.routeId ?? 0,
          ),
        );
      },
    );
  }
}

extension _MainScreenDeliveryList on MainScreenState {
  Widget noTrip() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EmptyWidget(message: 'Chưa có lộ trình'),
          const SizedBox(height: 20),
          PrimaryButton(
            title: 'Kiểm tra lộ trình',
            buttonHeight: 50,
            onPressed: () => _cubit.getTrip(),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            title: 'Thêm phiếu yêu cầu',
            buttonHeight: 50,
            onPressed: () => showDialog<String>(
              context: context,
              builder: (context) => AddTripScreen(
                didAddTrip: () => _cubit.getTempFormDetails(),
              ),
              barrierDismissible: false,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget pendingTrip() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PendingTripScreen(
            tempForm: _tempForm!,
            onDelete: () => _cubit.deleteNewTrip(),
            onEdit: () => showDialog<String>(
              context: context,
              builder: (context) => AddTripScreen(
                tempForm: _tempForm,
                didAddTrip: () => _cubit.getTempFormDetails(),
              ),
              barrierDismissible: false,
            ),
            onClose: (value) => _cubit.closeNewTrip(value),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget warningWidgetList() {
    final ll =
        (_warningList ?? []).map<Widget>((e) => widgetWithWarning(e)).toList();
    return Column(
      children: ll,
    );
  }

  Widget widgetWithWarning(WarningResponse warning) {
    final level = warning.level ?? 1;
    // final level = 3;
    var color = AppColors.warning;
    if (level == 2) {
      color = AppColors.warningHigh;
    } else if (level == 3) {
      color = AppColors.warningRisk;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            const Icon(
              Icons.warning,
              color: AppColors.red,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                warning.warningMessage?.decodeHtml ?? '',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => WarningsHandlerScreen(
                  id: warning.id ?? '',
                ),
              ),
              child: const Text(
                "Xử lý",
                style: menuTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
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
}

class StopPointItem {
  final StopPointResponse stopPoint;
  bool isExpanded;

  StopPointItem(this.stopPoint, {this.isExpanded = false});
}

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
import 'package:mvvm_cubit/common/widget/spinkit_indicator.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/data/model/warning/warning_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/main.dart';
import 'package:mvvm_cubit/view/add_trip/add_trip_screen.dart';
import 'package:mvvm_cubit/view/check_point/check_point_screen.dart';
import 'package:mvvm_cubit/view/main/widget/trip_container.dart';
import 'package:mvvm_cubit/view/pending_trip/screen/pending_trip_screen.dart';
import 'package:mvvm_cubit/view/warnings_handler/screen/warnings_handler_screen.dart';
import 'package:mvvm_cubit/view/webview/webview_screen.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  Location location = Location();

  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final cubit = MainCubit(repository: di());
  static Timer? fetchTrip;
  static Timer? fetchWarning;
  String? _imagePath;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.getTrip();
      cubit.getWarningList();
      cubit.getTempFormDetails();
      checkLocationPermission();
      Future.delayed(const Duration(seconds: 5), () {
        getCurrentLocation();
      });
    });
    AuthManager.setTokenExpiredCallback(() {
      cancelFetchingTrip();
      cancelFetchingWarning();
    });
  }

  void startFetchingTrip() {
    cancelFetchingTrip();
    fetchTrip = Timer.periodic(const Duration(seconds: 10), (timer) {
      cubit.getTrip();
    });
  }

  static void cancelFetchingTrip() {
    fetchTrip?.cancel();
    fetchTrip = null;
  }

  void startFetchingWarning() {
    cancelFetchingWarning();
    fetchWarning = Timer.periodic(const Duration(seconds: 10), (timer) {
      cubit.getWarningList();
    });
  }

  @override
  void dispose() {
    cancelFetchingTrip();
    cancelFetchingWarning();
    super.dispose();
  }

  static void cancelFetchingWarning() {
    fetchWarning?.cancel();
    fetchWarning = null;
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
    return BlocProvider(
      create: (_) => cubit,
      child: Scaffold(
        body: BlocConsumer<MainCubit, GenericCubitState<MainState>>(
          listener: (context, state) {
            switch (state.status) {
              case Status.failure:
                showErrorSnackBar(
                  context,
                  state.error ?? AppString.sendTimeOut,
                );
              case Status.success:
                break;
              default:
                break;
            }
          },
          builder: (context, state) {
            return BlocBuilder<MainCubit, GenericCubitState<MainState>>(
              builder: (context, state) {
                final data = state.data;
                final warningList =
                    (data as GetWarningListMainState?)?.warningList ?? [];
                switch (state.status) {
                  case Status.failure:
                    return noTrip();
                  case Status.empty:
                    return const EmptyWidget(message: "No delivery!");
                  case Status.loading:
                    return const SpinKitIndicator(type: SpinKitType.circle);
                  case Status.success:
                    // startFetchingTrip();
                    // startFetchingWarning();
                    if (data is GetTripMainState) {
                      return Column(
                        children: [
                          warningWidgetList(warningList),
                          Expanded(
                            child: currentTrip((data as GetTripMainState).trip),
                          ),
                        ],
                      );
                    } else if (data is GetTempFormDetailsMainState) {
                      return Column(
                        children: [
                          warningWidgetList(warningList),
                          Expanded(
                            child: pendingTrip(),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          warningWidgetList(warningList),
                          Expanded(
                            child: noTrip(),
                          ),
                        ],
                      );
                    }
                }
              },
            );
          },
        ),
      ),
    );
  }

  void navigateTo(Widget screen) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  Widget currentTrip(TripResponse trip) {
    return TripContainer(
      trip: trip,
      onArrived: (value) async {
        _locationData = await getCurrentLocation();
        final stopPointLocation = LocationData.fromMap({
          'longitude': value.destination?.longitude,
          'latitude': value.destination?.latitude,
        });
        if (_locationData != null) {
          if (calculateDistance(_locationData!, stopPointLocation) > 20) {
            // ignore: use_build_context_synchronously
            await showDialog(
              context: context,
              builder: (context) => CheckPointScreen(
                didCapture: (value) => _imagePath = value,
              ),
              barrierDismissible: false,
            );
          }
        }
      },
      onFinihed: () {
        navigateTo(
          const WebViewCustom(
            title: 'Trip vacom',
            url: ApiConfig.finishedStopPointLink,
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
            onPressed: () => cubit.getTrip(),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            title: 'Thêm phiếu yêu cầu',
            buttonHeight: 50,
            onPressed: () => showDialog<String>(
              context: context,
              builder: (context) => AddTripScreen(
                didAddTrip: () => cubit.getTempFormDetails(),
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
            onDelete: () => cubit.deleteNewTrip(),
            onEdit: () => cubit.editNewTrip(''),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget warningWidgetList(List<WarningResponse> list) {
    final ll = list.map<Widget>((e) => widgetWithWarning(e)).toList();
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
                warning.warningMessage ?? '',
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
                style: textDefault,
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

import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/delete_dialog.dart';
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
import 'package:mvvm_cubit/view/verify_distance/verify_distance_screen.dart';
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

  final _cubit = MainCubit(repository: di());
  static Timer? _fetchTrip;
  static Timer? _fetchWarning;
  static Timer? _fetchTempFormDetails;
  final HiveStorageManager _hiveStorageManager = di();
  double _arrivalLimitRadius = 0;
  String _loginCode = '';
  final _timerDuration = const Duration(seconds: 10);
  final GlobalKey<State> progressKey = GlobalKey<State>();
  int apiCounter = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLoadData();
    });
    AuthManager.instance.setTokenExpiredCallback(() {
      cancelFetchingTrip();
      cancelFetchingWarning();
      cancelFetchingTempFormDetails();
      if (AuthManager.instance.isLoggedIn) {
        navigateTo(
          const LoginScreen(),
        );
      }
      AuthManager.instance.setLoggedIn(false);
    });

    _hiveStorageManager.getLoginData().then(
      (value) {
        setState(() {
          _arrivalLimitRadius = value?.arrivalLimitRadius ?? 0;
          _loginCode = value?.code ?? '';
        });
      },
    );

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> initLoadData() async {
    try {
      final List<Future<void>> apiCalls = [
        _cubit.getTrip(),
        _cubit.getWarningList(),
        _cubit.getTempFormDetails(),
      ];

      await Future.wait(apiCalls);
    } catch (error) {
      logger.e(error);
    }
    startFetchingWarning();
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

  void startFetchingWarning() {
    cancelFetchingWarning();
    _fetchWarning = Timer.periodic(
      _timerDuration,
      (timer) {
        logger.d('startFetchingWarning ${AuthManager.instance.isLoggedIn}');
        if (AuthManager.instance.isLoggedIn) {
          _cubit.getWarningList();
        }
      },
    );
  }

  void startFetchingTempFormDetails() {
    cancelFetchingTempFormDetails();
    _fetchWarning = Timer.periodic(
      _timerDuration,
      (timer) {
        logger.d(
            'startFetchingTempFormDetails ${AuthManager.instance.isLoggedIn}');
        if (AuthManager.instance.isLoggedIn) {
          _cubit.getTempFormDetails();
        }
      },
    );
  }

  @override
  void dispose() {
    cancelFetchingTrip();
    cancelFetchingWarning();
    cancelFetchingTempFormDetails();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  static void cancelFetchingTrip() {
    _fetchTrip?.cancel();
    _fetchTrip = null;
  }

  static void cancelFetchingWarning() {
    _fetchWarning?.cancel();
    _fetchWarning = null;
  }

  static void cancelFetchingTempFormDetails() {
    _fetchTempFormDetails?.cancel();
    _fetchTempFormDetails = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      logger.d('===AppLifecycleState.resumed');
      _cubit.getWarningList();
      startFetchingWarning();
      if (_tempForm != null) {
        _cubit.getTempFormDetails();
        startFetchingTempFormDetails();
      }
    } else if (state == AppLifecycleState.inactive) {
      logger.d('===AppLifecycleState.inactive');
      cancelFetchingWarning();
      cancelFetchingTempFormDetails();
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
            setState(() {
              apiCounter += 1;
            });
            switch (state.status) {
              case Status.failure:
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
                  if (_tempForm == null) {
                    startFetchingTempFormDetails();
                  }
                  setState(() {
                    _tempForm = data.tempForm;
                  });
                } else if (data is EmptyTripMainState) {
                  setState(() {
                    _trip = null;
                  });
                } else if (data is EmptyTempFormMainState) {
                  cancelFetchingTempFormDetails();
                  setState(() {
                    _tempForm = null;
                  });
                } else if (data is DidDeleteTripMainState) {
                  showConfirmSnackBar(context, 'Đã huỷ PYC tạm thành công');
                  setState(() {
                    _tempForm = null;
                  });
                } else if (data is DidCloseTripMainState) {
                  showConfirmSnackBar(
                      context, 'Đã hoàn thành PYC tạm thành công');
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
                if (apiCounter < 3) {
                  return Center(
                    child: _LoadingIndicator(),
                  );
                }
                return Column(
                  children: [
                    // warningWidgetList(),
                    if (_trip != null)
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
    return RefreshIndicator(
      child: TripContainer(
        trip: trip,
        onArrived: (stopPoint) => showVerifyDistanceDialog(
          context: context,
          key: progressKey,
          stopPoint: stopPoint,
          arrivalLimitRadius: _arrivalLimitRadius,
          onVerifyLocationData: (locationData) {},
          onError: (value) => showErrorSnackBar(context, value),
        ).then(
          (value) {
            if (value is LocationData) {
              showDialog(
                context: context,
                builder: (context) => CheckPointScreen(
                  didCapture: (image) => _cubit.submitArrived(
                    CheckInRequest(
                      id: stopPoint.id,
                      imgName: image.imgName ?? '',
                      latitude: value.latitude ?? 0,
                      longitude: value.longitude ?? 0,
                    ),
                  ),
                ),
                barrierDismissible: false,
              );
            } else if (value is FarFromCheckInError) {
              showErrorSnackBar(context, value.message);
            } else if (value is ForceRequestLocationError) {
              forceDialog(context, 'Bạn phải cung cấp quyền truy cập vị trí!')
                  .then(
                (value) {
                  if (value == true) {
                    AppSettings.openAppSettings();
                  }
                },
              );
            }
          },
        ),
        onFinihed: () {
          navigateTo(
            WebViewCustom(
              title: 'Hoàn thành PYC: ${trip.routeId ?? 0}',
              jobRequestId: trip.routeId ?? 0,
              code: _loginCode,
            ),
          );
        },
      ),
      onRefresh: () => _cubit.getTrip(),
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
                didAddTrip: () {
                  showConfirmSnackBar(context, 'Đã thêm PYC tạm thành công');
                  _cubit.getTempFormDetails();
                },
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
    return RefreshIndicator(
      edgeOffset: 20,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PendingTripScreen(
                  tempForm: _tempForm!,
                  onDelete: () => _cubit.deleteNewTrip(),
                  onEdit: () => showDialog<String>(
                    context: context,
                    builder: (context) => AddTripScreen(
                      tempForm: _tempForm,
                      didAddTrip: () {
                        showConfirmSnackBar(
                            context, 'Đã cập nhập PYC tạm thành công');
                        _cubit.getTempFormDetails();
                      },
                    ),
                    barrierDismissible: false,
                  ),
                  onClose: (value) => _cubit.closeNewTrip(value),
                ),
                const SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
      onRefresh: () => _cubit.getTempFormDetails(),
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
    } else if (level == 4) {
      color = AppColors.error;
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

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: AppColors.primary,
    );
  }
}

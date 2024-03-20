import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
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
  final List<WarningDetailsResponse> _warningList = [];
  final double _warningHeight = 70;
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
  int _currentPageWarning = 0;
  final _warningListScrollController = ScrollController();
  bool _isLast = false;

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
          context: context,
          screen: const LoginScreen(),
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

    _warningListScrollController.addListener(() {
      if (_warningListScrollController.position.pixels ==
          _warningListScrollController.position.maxScrollExtent) {
        if (_isLast == false) {
          loadMoreWarningList();
        }
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> initLoadData() async {
    try {
      final List<Future<void>> apiCalls = [
        _cubit.getTrip(),
        _cubit.getWarningList(_currentPageWarning),
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

  void loadMoreWarningList() {
    _currentPageWarning += 1;
    _cubit.getWarningList(_currentPageWarning);
  }

  void startFetchingWarning() {
    cancelFetchingWarning();
    _fetchWarning = Timer.periodic(
      _timerDuration,
      (timer) {
        logger.d('startFetchingWarning ${AuthManager.instance.isLoggedIn}');
        if (AuthManager.instance.isLoggedIn) {
          _cubit.getWarningListForFetching();
        }
      },
    );
  }

  void startFetchingTempFormDetails() {
    cancelFetchingTempFormDetails();
    _fetchWarning = Timer.periodic(
      _timerDuration,
      (timer) {
        if (AuthManager.instance.isLoggedIn) {
          _cubit.getTempFormDetailsForFecthing();
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
      _cubit.getWarningList(_currentPageWarning);
      _cubit.getTrip;
      startFetchingWarning();
      if (_tempForm != null) {
        _cubit.getTempFormDetails();
        startFetchingTempFormDetails();
      }
    } else if (state == AppLifecycleState.inactive) {
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
                  if (data.warningList.isEmpty) {
                    _isLast = true;
                  }
                  setState(() {
                    _warningList.addAll(data.warningList);
                  });
                } else if (data is FetchWarningListMainState) {
                  bool isContains = data.warningList.any(
                    (element) => _warningList.contains(element),
                  );
                  if (isContains) {
                    setState(() {
                      _currentPageWarning = 0;
                      _isLast = false;
                      _warningList.clear();
                      _warningList.addAll(data.warningList);
                    });
                  }
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
                  showConfirmSnackBar(
                    context,
                    'Đã huỷ PYC tạm thành công',
                  );
                  setState(() {
                    _tempForm = null;
                  });
                } else if (data is DidCloseTripMainState) {
                  showConfirmSnackBar(
                    context,
                    'Đã hoàn thành PYC tạm thành công',
                  );
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
                    warningWidgetList(),
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

  Future<T?> navigateTo<T extends Object?>(
      {required BuildContext context, required Widget screen}) {
    final name = screen.runtimeType.toString();
    return Navigator.push(
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
                      imgName: image?.imgName,
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
        onFinished: () {
          navigateTo(
            context: context,
            screen: WebViewCustom(
              title: 'Hoàn thành PYC: ${trip.routeId ?? 0}',
              jobRequestId: trip.routeId ?? 0,
              code: _loginCode,
            ),
          ).then((value) => _cubit.getTrip());
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

  double _calculateWarningHeight(int length) {
    if (length > 4) {
      return 260;
    } else {
      return length * _warningHeight;
    }
  }

  Widget warningWidgetList() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: _calculateWarningHeight(_warningList.length),
      ),
      child: ListView.separated(
        controller: _warningListScrollController,
        itemBuilder: (_, index) {
          return _widgetWithWarning(_warningList[index]);
        },
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: AppColors.textDefaultLight,
        ),
        itemCount: _warningList.length,
      ),
    );
  }

  Widget _widgetWithWarning(WarningDetailsResponse? warning) {
    final level = warning?.level ?? 1;
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
      height: _warningHeight,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: color,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(
            Icons.warning,
            color: AppColors.red,
            size: 24.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cảnh báo cấp độ: ${warning?.level ?? 1}',
                  style: headLine7,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  warning?.warningMessage?.decodeHtml ?? '',
                  style: textDefault,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Thời gian cảnh báo: ${(warning?.startTime ?? 0).toDate.toStringFormat()}',
                  style: headLine7,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
          // if (warning?.type != 'SOS-robbed')
          ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => WarningsHandlerScreen(
                id: warning?.id ?? '',
                isCanChat: true,
              ),
            ),
            child: const Text(
              "Xử lý",
              style: menuTextStyle,
            ),
          ),
        ],
      ),
    );
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

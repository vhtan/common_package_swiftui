import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/spinkit_indicator.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/add_trip/add_trip_screen.dart';
import 'package:mvvm_cubit/view/check_point/check_point_screen.dart';
import 'package:mvvm_cubit/view/main/widget/trip_container.dart';
import 'package:mvvm_cubit/view/pending_trip/screen/pending_trip_screen.dart';
import 'package:mvvm_cubit/view/warnings_handler/screen/warnings_handler_screen.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Location location = Location();

  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final cubit = MainCubit(repository: di());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.getTrip();
      cubit.getCurrencyList();
      checkLocationPermission();
      Future.delayed(const Duration(milliseconds: 5000), () {
        getCurrentLocation();
      });
    });
  }

  void getCurrentLocation() async {
    if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
      _locationData = await location.getLocation();
    }
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
        body: BlocConsumer<MainCubit, GenericCubitState>(
          listener: (context, state) {
            switch (state.status) {
              case Status.failure:
                showErrorSnackBar(
                  context,
                  state.error ?? AppString.sendTimeOut,
                );
                break;
              case Status.success:
                // clear cached login
                // navigateTo(const LoginScreen());
                break;
              default:
                break;
            }
          },
          builder: (context, state) {
            return BlocBuilder<MainCubit, GenericCubitState<MainState>>(
              builder: (context, state) {
                switch (state.status) {
                  case Status.failure:
                    // return const SizedBox();
                    // return tripList();
                    // return pendingTrip();
                    return noTrip();
                  case Status.empty:
                    return const EmptyWidget(message: "No delivery!");
                  case Status.loading:
                    return const SpinKitIndicator(type: SpinKitType.circle);
                  case Status.success:
                    var trip = state.data?.trip;
                    var pendTrip = state.data?.pendingTrip;
                    if (trip != null) {
                      return noTrip();
                    } else if (pendTrip != null) {
                      return pendingTrip();
                    } else {
                      return Column(
                        children: [
                          // warningNoTrip(),
                          // const SizedBox(height: 4),
                          // warningStopTooLong(),
                          noTrip(),
                        ],
                      );
                      // return noTrip();
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
}

extension _MainScreenDeliveryList on _MainScreenState {
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
            onPressed: () => showDialog<Trip>(
              context: context,
              builder: (context) => const AddTripScreen(),
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
            onEdit: () => cubit.editNewTrip(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget currentTrip(TripResponse trip) {
    return TripContainer(
      trip: trip,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => const CheckPointScreen(),
        barrierDismissible: false,
      ),
    );
  }

  Widget warningNoTrip() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.warning,
        // borderRadius: BorderRadius.all(Radius.circular(8)),
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
            const SizedBox(width: 8.0), // Add spacing between elements
            const Expanded(
              child: Text(
                'Di chuyển không có phiếu yêu cầu',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Specify an overflow property
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Thêm PYC",
                style: textDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget warningStopTooLong() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.warningHigh,
        // borderRadius: BorderRadius.all(Radius.circular(8)),
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
            const SizedBox(width: 8.0), // Add spacing between elements
            const Expanded(
              child: Text(
                'Cánh báo: Dừng quá lâu',
                style: textDefault,
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Specify an overflow property
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const WarningsHandlerScreen(),
                  barrierDismissible: false,
                );
              },
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
}

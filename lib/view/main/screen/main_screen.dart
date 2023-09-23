import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/spinkit_indicator.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/main/duty.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/view/add_trip/add_trip_screen.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/check_point/check_point_screen.dart';
import 'package:mvvm_cubit/view/main/widget/trip_container.dart';
import 'package:mvvm_cubit/view/pending_trip/screen/pending_trip_screen.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Duty> _itineraries = [
    PickUpDuty(
      id: 1,
      title: 'Đón áp tải',
      buttonTitle: 'Đến nơi',
      name: 'Nguyễn Văn Thắng',
      address: '123 Nguyên Công Trứ, P1, Quận 10',
      phone: '0987654321',
    ),
    PickUpDuty(
      id: 2,
      title: 'Đón bảo vệ',
      buttonTitle: 'Đến nơi',
      name: 'Nguyễn Văn Thắng',
      address: '123 Nguyên Công Trứ, P1, Quận 10',
      phone: '0987654321',
    ),
    DeliveryDuty(
      id: 3,
      title: 'Xử lý phiếu yêu cầu',
      buttonTitle: 'Hoàn thành',
      requestFormId: 'PYC: 78909',
      totalAmount: 'Tổng tiền: 3 tỷ',
      type: 'Loại: tiếp quỹ',
    ),
    DeliveryDuty(
      id: 4,
      title: 'Xử lý phiếu yêu cầu',
      buttonTitle: 'Hoàn thành',
      requestFormId: 'PYC: 22909',
      totalAmount: 'Tổng tiền: 4 tỷ',
      type: 'Loại: trả quỷ',
    ),
  ];

  @override
  void initState() {
    BlocProvider.of<MainCubit>(context).getTrip();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MainCubit, GenericCubitState>(
        listener: (context, state) {
          switch (state.status) {
            case Status.failure:
              // navigateTo(const LoginScreen());
              break;
            case Status.success:
              // clear cached login
              ApiConfig.loginResponse = null;
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
                    return currentTrip();
                  } else if (pendTrip != null) {
                    return pendingTrip();
                  } else {
                    return noTrip();
                  }
              }
            },
          );
        },
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
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const EmptyWidget(message: 'Chưa có lộ trình'),
          const SizedBox(height: 20),
          PrimaryButton(
            title: 'Kiểm tra lộ trình',
            buttonHeight: 50,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const AddTripScreen(),
              barrierDismissible: false,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
              title: 'Thêm phiếu yêu cầu',
              buttonHeight: 50,
              onPressed: () => showDialog<Trip>(
                    context: context,
                    builder: (context) => const AddTripScreen(),
                    barrierDismissible: false,
                  )),
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
            onDelete: () => context.read<MainCubit>().deleteNewTrip(),
            onEdit: () => context.read<MainCubit>().editNewTrip(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget currentTrip() {
    return TripContainer(
      itineraries: _itineraries,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => const CheckPointScreen(),
        barrierDismissible: false,
      ),
    );
  }
}

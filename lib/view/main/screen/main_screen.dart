import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/spinkit_indicator.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/model/main/delivery.dart';
import 'package:mvvm_cubit/data/model/main/itinerary.dart';
import 'package:mvvm_cubit/view/add_request_form/add_request_form.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/check_point/check_point_screen.dart';
import 'package:mvvm_cubit/view/main/widget/itinerary_list.dart';
import 'package:mvvm_cubit/view/pending_request_form/pending_request_form_screen.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Itinerary> _itineraries = [
    PickUpItinerary(
      id: 1,
      title: 'Đón áp tải',
      buttonTitle: 'Đến nơi',
      name: 'Nguyễn Văn Thắng',
      address: '123 Nguyên Công Trứ, P1, Quận 10',
      phone: '0987654321',
    ),
    PickUpItinerary(
      id: 2,
      title: 'Đón bảo vệ',
      buttonTitle: 'Đến nơi',
      name: 'Nguyễn Văn Thắng',
      address: '123 Nguyên Công Trứ, P1, Quận 10',
      phone: '0987654321',
    ),
    RequestFormItinerary(
      id: 3,
      title: 'Xử lý phiếu yêu cầu',
      buttonTitle: 'Hoàn thành',
      requestFormId: 'PYC: 78909',
      totalAmount: 'Tổng tiền: 3 tỷ',
      type: 'Loại: tiếp quỹ',
    ),
    RequestFormItinerary(
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
    BlocProvider.of<MainCubit>(context).getListDelivery();
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
            navigateTo(const LoginScreen());
            break;
          default:
            break;
        }
      }, builder: (context, state) {
        return BlocBuilder<MainCubit, GenericCubitState<List<Delivery>>>(
            builder: (BuildContext context,
                GenericCubitState<List<Delivery>> state) {
          switch (state.status) {
            case Status.failure:
              // return const SizedBox();
              return itineraryList();
            // return pendingItinerary();
            case Status.empty:
              return const EmptyWidget(message: "No delivery!");
            case Status.loading:
              return const SpinKitIndicator(type: SpinKitType.circle);
            case Status.success:
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.data?.length ?? 0,
                itemBuilder: (_, index) {
                  return null;
                },
              );
          }
        });
      }),
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
  Widget noItinerary() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const EmptyWidget(message: 'Chưa có lộ trình'),
          const SizedBox(height: 20),
          PrimaryButton(
            title: 'Thêm phiếu yêu cầu',
            buttonHeight: 50,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const AddRequestFormScreen(),
              barrierDismissible: false,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget pendingItinerary() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PendingRequestFormScreen(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget itineraryList() {
    return ItineraryList(
      itineraries: _itineraries,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => const CheckPointScreen(),
        barrierDismissible: false,
      ),
    );
  }
}

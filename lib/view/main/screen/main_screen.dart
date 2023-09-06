import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/spinkit_indicator.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/delivery.dart';
import 'package:mvvm_cubit/data/model/main/itinerary.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/check_point/check_point_screen.dart';
import 'package:mvvm_cubit/view/main/widget/status_container.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final List<Itinerary> _itineraries = List.generate(
  //   4,
  //   (index) => Itinerary(
  //     title: 'Đón áp tải $index',
  //     name: 'Nguyễn Văn Thắng $index',
  //     address: '123 Nguyên Công Trứ, P1, Quận 10',
  //     phone: '0987654321',
  //   ),
  // );
  final List<Itinerary> _itineraries = [
    PickUpItinerary(
      title: 'Đón áp tải',
      buttonTitle: 'Đến nơi',
      name: 'Nguyễn Văn Thắng',
      address: '123 Nguyên Công Trứ, P1, Quận 10',
      phone: '0987654321',
    ),
    PickUpItinerary(
      title: 'Đón bảo vệ',
      buttonTitle: 'Đến nơi',
      name: 'Nguyễn Văn Thắng',
      address: '123 Nguyên Công Trứ, P1, Quận 10',
      phone: '0987654321',
    ),
    RequestFormItinerary(
      title: 'Xử lý phiếu yêu cầu',
      buttonTitle: 'Hoàn thành',
      requestFormId: 'PYC: 78909',
      totalAmount: 'Tổng tiền: 3 tỷ',
      type: 'Loại: tiếp quỹ',
    ),
    RequestFormItinerary(
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
  Widget itineraryList() {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      shrinkWrap: true,
      itemCount: _itineraries.length,
      itemBuilder: (_, index) {
        Itinerary itinerary = _itineraries[index];
        if (itinerary is PickUpItinerary) {
          PickUpItinerary pickUp = itinerary;
          return renderPickUpItinerary(pickUp);
        } else if (itinerary is RequestFormItinerary) {
          RequestFormItinerary request = itinerary;
          return renderRequestFormItinerary(request);
        } else {
          return null;
        }
      },
    );
  }

  Widget renderPickUpItinerary(PickUpItinerary itinerary) {
    return ExpansionTile(
      backgroundColor: AppColors.notificationUnread,
      title: Text(
        itinerary.title,
        style: headLine2,
      ),
      subtitle: Text(
        itinerary.name,
        style: textDefault,
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.map),
              const SizedBox(width: 10),
              Text(
                itinerary.address,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 10),
              Text(
                itinerary.phone,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PrimaryButton(
            title: itinerary.buttonTitle,
            buttonHeight: 50,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const CheckPointScreen(),
              barrierDismissible: false,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget renderRequestFormItinerary(RequestFormItinerary itinerary) {
    return ExpansionTile(
      backgroundColor: AppColors.notificationUnread,
      title: Text(
        itinerary.title,
        style: headLine2,
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.api_sharp),
              const SizedBox(width: 10),
              Text(
                itinerary.requestFormId,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.money_rounded),
              const SizedBox(width: 10),
              Text(
                itinerary.totalAmount,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              const Icon(Icons.account_balance),
              const SizedBox(width: 10),
              Text(
                itinerary.type,
                style: textDefault,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PrimaryButton(
            title: itinerary.buttonTitle,
            buttonHeight: 50,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const CheckPointScreen(),
              barrierDismissible: false,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

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
  final List<Itinerary> _itineraries = const [
    Itinerary(
      title: 'Đón áp tải',
      name: 'Nguyễn Văn Thắng',
      address: '123 Nguyên Công Trứ, P1, Quận 10',
      phone: '0987654321',
    ),
    Itinerary(
      title: 'Đón bảo vệ',
      name: 'Nguyễn Văn Thắng',
      address: '123 Nguyên Công Trứ, P1, Quận 10',
      phone: '0987654321',
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

  Widget renderListItinerary(Itinerary itinerary) {
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
            title: 'Đến nơi',
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
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      shrinkWrap: true,
      itemCount: _itineraries.length,
      itemBuilder: (_, index) {
        Itinerary itinerary = _itineraries[index];
        return renderListItinerary(itinerary);
      },
    );
  }
}

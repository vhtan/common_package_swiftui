import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/spinkit_indicator.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/delivery.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/main/widget/status_container.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Delivery> _deliveries = List.generate(
      9,
      (index) => Delivery(
          orderCode: '${index}32312',
          startAddress: 'Phú Thuận, District 7, Ho Chi Minh City $index',
          destinationAddress:
              '4 Đ. Đào Trí, Phú Thuận, Quận 7, Thành phố Hồ Chí Minh $index',
          startedTime: DateTime(2023),
          status: DeliveryStatus.arrived,
          type: DeliveryType.decreaseFund));

  @override
  void initState() {
    BlocProvider.of<MainCubit>(context).getListDelivery();
    super.initState();
  }

  PreferredSizeWidget get _appBar {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () => context.read<MainCubit>().getDeliveryList(),
      //   icon: const Icon(Icons.refresh),
      // ),
      // actions: [
      //   PopupMenu<DeliveryStatus>(
      //     icon: Icons.filter_list_outlined,
      //     items: DeliveryStatus.values,
      //     onChanged: (DeliveryStatus value) {
      //       context.read<MainCubit>().getDeliveryList(status: value);
      //     },
      //   ),
      //   PopupMenu<Gender>(
      //     icon: Icons.filter_alt_outlined,
      //     items: Gender.values,
      //     onChanged: (Gender value) {
      //       context.read<MainCubit>().getDeliveryList(gender: value);
      //     },
      //   )
      // ],
      title: const Text("Main Report"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appBar,
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
              return deliveryList();
            case Status.empty:
              return const EmptyWidget(message: "No delivery!");
            case Status.loading:
              return const SpinKitIndicator(type: SpinKitType.circle);
            case Status.success:
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.data?.length ?? 0,
                itemBuilder: (_, index) {
                  Delivery delivery = state.data![index];
                  return renderListDelivery(delivery);
                },
              );
          }
        });
      }),
    );
  }

  Widget renderListDelivery(Delivery delivery) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#${delivery.orderCode}', style: headLine4),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Xuất phát: ${delivery.startAddress}',
                            style: textDefault,
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.pin_drop,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Điểm đến: ${delivery.destinationAddress}',
                            style: textDefault,
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(delivery.startedTime.toStringFormat(),
                            style: textDefault)
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.car_crash,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(delivery.type.name, style: textDefault),
                        const Spacer(),
                        StatusContainer(status: delivery.status),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get floatingActionButton {
    return FloatingActionButton(
      onPressed: () async {
        context
            .read<MainCubit>()
            .logout(ApiConfig.loginResponse?.username ?? '');
      },
      child: const Text("SOS"),
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
  Widget deliveryList() {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      shrinkWrap: true,
      itemCount: _deliveries.length,
      itemBuilder: (_, index) {
        Delivery delivery = _deliveries[index];
        return renderListDelivery(delivery);
      },
    );
  }
}

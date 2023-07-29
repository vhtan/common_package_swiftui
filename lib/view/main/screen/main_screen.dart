import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/spinkit_indicator.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/delivery.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/main/wiget/status_container.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
      floatingActionButton: floatingActionButton,
      appBar: _appBar,
      body: BlocConsumer<MainCubit, GenericCubitState>(
          listener: (context, state) {
        switch (state.status) {
          case Status.failure:
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
              return const SizedBox();
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(delivery.name, style: headLine4),
                  const SizedBox(height: 10),
                  Text(delivery.email, style: headLine6)
                ],
              ),
            ),
            const SizedBox(width: 15),
            StatusContainer(status: delivery.status),
          ],
        ),
      ),
    );
  }

  Widget get floatingActionButton {
    return FloatingActionButton(
      onPressed: () async {},
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

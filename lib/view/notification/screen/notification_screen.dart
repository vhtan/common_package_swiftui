import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/notification/widget/notification_item.dart';
import 'package:mvvm_cubit/viewmodel/notification/notification_cubit.dart';
import 'package:mvvm_cubit/viewmodel/notification/notification_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  final cubit = NotificationCubit(repository: di());

  @override
  void initState() {
    super.initState();
    cubit.getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<NotificationCubit, GenericCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<NotificationCubit, GenericCubitState>(
            builder: (context, state) {
              List<NotificationResponse> list = [];
              if (state is GetNotificationListSuccess) {
                list = state.list;
              }
              if (list.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: AppColors.textDefaultLight,
                      ),
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        return NotificationItem(
                          notification: list[index],
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const EmptyWidget(
                    message: 'Hiện tại chưa có thông báo mới');
              }
            },
          );
        },
      ),
    );
  }
}

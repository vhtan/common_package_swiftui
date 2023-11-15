import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/notification/widget/notification_item.dart';
import 'package:mvvm_cubit/view/notification_details/notification_details_screen.dart';
import 'package:mvvm_cubit/viewmodel/notification/notification_cubit.dart';
import 'package:mvvm_cubit/viewmodel/notification/notification_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  final _cubit = NotificationCubit(repository: di());

  @override
  void initState() {
    super.initState();
    _cubit.getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<NotificationCubit, GenericCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<NotificationCubit, GenericCubitState>(
            builder: (context, state) {
              List<NotificationResponse> list = [];
              if (state is GetNotificationListSuccess) {
                list = state.list;
              }
              logger.d('=====NotificationScreen $list');
              if (list.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: AppColors.textDefaultLight,
                      ),
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            final item = list[index];
                            _cubit.readNotification(item.id ?? '');
                            showDialog(
                              context: context,
                              builder: (context) => NotificationDetailsScreen(
                                notification: item,
                              ),
                              barrierDismissible: false,
                            );
                          },
                          child: NotificationItem(
                            notification: list[index],
                          ),
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

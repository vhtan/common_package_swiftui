import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
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

  final GlobalKey<State> progressKey = GlobalKey<State>();
  final _scrollController = ScrollController();
  List<NotificationResponse> _list = [];
  bool _isLast = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _cubit.getNotificationList(page: _currentPage),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_isLast == false) {
          loadMore();
        }
      }
    });
  }

  Future<void> _refreshList() async {
    _isLast = false;
    _currentPage = 0;
    _cubit.getNotificationList(page: _currentPage);
  }

  void loadMore() {
    _currentPage += 1;
    _cubit.getNotificationList(page: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<NotificationCubit, GenericCubitState>(
        listener: (context, state) {
          logger.d('=====Notification ${state.status}');
          switch (state.status) {
            case Status.success:
              if (progressKey.currentContext != null) {
                Navigator.pop(context);
              }
              if (state is GetNotificationListSuccess) {
                if (state.list.isEmpty) {
                  _isLast = true;
                }
                if (_currentPage == 0) {
                  setState(() {
                    _list = state.list;
                  });
                } else {
                  setState(() {
                    _list.addAll(state.list);
                  });
                }
              }
            case Status.failure:
              if (progressKey.currentContext != null) {
                logger.d('message $progressKey');
                Navigator.pop(context);
              }
              showErrorSnackBar(
                context,
                state.error ?? '',
              );
            case Status.loading:
              if (progressKey.currentContext == null) {
                showProgressDialog(
                  context,
                  progressKey,
                );
              }
            default:
              if (progressKey.currentContext != null) {
                Navigator.pop(context);
              }
          }
        },
        builder: (context, state) {
          return BlocBuilder<NotificationCubit, GenericCubitState>(
            builder: (context, state) {
              if (_list.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: RefreshIndicator(
                      onRefresh: () => _refreshList(),
                      child: ListView.separated(
                        controller: _scrollController,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          color: AppColors.textDefaultLight,
                        ),
                        shrinkWrap: true,
                        itemCount: _list.length,
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () {
                              final item = _list[index];
                              _cubit.readNotification(item.id ?? '');
                              final dialog = showDialog(
                                context: context,
                                builder: (context) => NotificationDetailsScreen(
                                  notification: item,
                                ),
                                barrierDismissible: false,
                              );
                              dialog.then((value) {
                                _refreshList();
                              });
                            },
                            child: NotificationItem(
                              notification: _list[index],
                            ),
                          );
                        },
                      ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/manager_role/warning_list/widget/accept_warning_dialog.dart';
import 'package:mvvm_cubit/view/manager_role/warning_list/widget/manager_role_warning_item.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/warning_list/manager_role_warning_list_cubit.dart';

class ManagerRoleWrningListScreen extends StatefulWidget {
  const ManagerRoleWrningListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManagerRoleWrningListScreen();
}

class _ManagerRoleWrningListScreen extends State<ManagerRoleWrningListScreen> {
  final warningCubit = ManagerRoleWarningListCubit(repository: di());
  final authCubit = AuthCubit(repository: di());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => warningCubit,
      child: BlocConsumer<ManagerRoleWarningListCubit, GenericCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ManagerRoleWarningListCubit, GenericCubitState>(
            builder: (context, state) {
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Danh sách cảnh báo'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.power_settings_new_rounded,
                            size: Dimension.menuIconSize, color: Colors.white),
                        onPressed: () => authCubit.logout(),
                      ),
                    ],
                    bottom: const TabBar(
                      indicatorColor: AppColors.error,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          child: Text(
                            'Đang chờ xử lý',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Đã xử lý',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      waitingProcessListView(),
                      processedListView(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

extension _TabBarView on _ManagerRoleWrningListScreen {
  Widget waitingProcessListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: AppColors.textDefaultLight,
      ),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (_, index) {
        return ManagerRoleWarningItem(
          isProcessed: false,
          onTap: () async {
            bool isAccepted = await showAcceptWarningDialog(
              'Chấp nhận cảnh báo',
              'Bạn có chắc là muốn chấp nhận cảnh báo',
              context,
            );
            if (isAccepted) {}
          },
        );
      },
    );
  }

  Widget processedListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: AppColors.textDefaultLight,
      ),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (_, index) {
        return ManagerRoleWarningItem(
          isProcessed: true,
          onTap: () => {},
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/warning/warning_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/manager_role/manager_warnings_handler/manager_warnings_handler_screen.dart';
import 'package:mvvm_cubit/view/manager_role/warning_list/widget/manager_role_warning_item.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/warning_list/manager_role_warning_list_cubit.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/warning_list/manager_role_warning_list_state.dart';

class ManagerRoleWrningListScreen extends StatefulWidget {
  const ManagerRoleWrningListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ManagerRoleWrningListScreen();
}

class _ManagerRoleWrningListScreen extends State<ManagerRoleWrningListScreen> {
  final cubit = ManagerRoleWarningListCubit(
    repository: di(),
    authRepository: di(),
    secureStorageManager: di(),
  );

  @override
  void initState() {
    super.initState();
    cubit.getWarningList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ManagerRoleWarningListCubit, GenericCubitState>(
        listener: (context, state) {
          if (state is DidLogoutWarningListSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<ManagerRoleWarningListCubit, GenericCubitState>(
            builder: (context, state) {
              List<WarningResponse> list = [];
              if (state is GetWarningListSuccess) {
                list = state.warnings;
              }
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Danh sách cảnh báo'),
                  leading: null,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.power_settings_new_rounded,
                        size: Dimension.menuIconSize,
                        color: Colors.white,
                      ),
                      onPressed: () => cubit.logout(),
                    ),
                  ],
                ),
                body: list.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const EmptyWidget(
                                message: 'Hiện không có cảnh báo cần xử lý'),
                            const SizedBox(height: 20),
                            PrimaryButton(
                              title: 'Kiểm tra danh sách cảnh báo',
                              buttonHeight: 50,
                              onPressed: () => cubit.getWarningList(),
                            )
                          ],
                        ),
                      )
                    : waitingProcessListView(list),
              );
            },
          );
        },
      ),
    );
  }
}

extension _TabBarView on _ManagerRoleWrningListScreen {
  Widget waitingProcessListView(List<WarningResponse> list) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: AppColors.textDefaultLight,
      ),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (_, index) {
        return ManagerRoleWarningItem(
          warning: list[index],
          isProcessed: false,
          onTap: () => showDialog(
            context: context,
            builder: (context) => ManagerWarningsHandlerScreen(
              id: list[index].id ?? '',
            ),
          ),
        );
      },
    );
  }
}

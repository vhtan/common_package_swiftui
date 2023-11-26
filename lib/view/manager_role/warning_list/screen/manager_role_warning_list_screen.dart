import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/delete_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/temp_form_history/temp_form_history_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/account/manager_account_screen.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/manager_role/manager_temp_form_handler/manager_temp_form_handler_screen.dart';
import 'package:mvvm_cubit/view/manager_role/manager_warnings_handler/manager_warnings_handler_screen.dart';
import 'package:mvvm_cubit/view/manager_role/warning_list/widget/manager_role_warning_item.dart';
import 'package:mvvm_cubit/view/temp_form_histories/temp_form_history_item.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/warning_list/manager_role_warning_list_cubit.dart';
import 'package:mvvm_cubit/viewmodel/manager_role/warning_list/manager_role_warning_list_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ManagerRoleWrningListScreen extends StatefulWidget {
  const ManagerRoleWrningListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ManagerRoleWrningListScreen();
}

class _ManagerRoleWrningListScreen extends State<ManagerRoleWrningListScreen>
    with WidgetsBindingObserver {
  final _cubit = ManagerRoleWarningListCubit(
    repository: di(),
    authRepository: di(),
    secureStorageManager: di(),
  );

  static Timer? _fetchWarningList;
  final _timerDuration = const Duration(seconds: 10);
  List<WarningDetailsResponse> _warningList = [];
  List<TempFormHistoryResponse> _tempFormList = [];
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _cubit.getWarningList();
    startFetchingWarningList();
    _cubit.getTempFormListNeedToHandle();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void startFetchingWarningList() {
    cancelFetchingMessages();
    _fetchWarningList = Timer.periodic(
      _timerDuration,
      (timer) {
        _cubit.getWarningListForFetching();
      },
    );
  }

  static void cancelFetchingMessages() {
    _fetchWarningList?.cancel();
    _fetchWarningList = null;
  }

  @override
  void dispose() {
    cancelFetchingMessages();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
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
          if (state is GetWarningListSuccess) {
            _warningList = state.warnings;
          }

          if (state is GetTempFormWarningListState) {
            _tempFormList = state.list;
          }
        },
        builder: (context, state) {
          return BlocBuilder<ManagerRoleWarningListCubit, GenericCubitState>(
            builder: (context, state) {
              return PopScope(
                canPop: false,
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: Column(
                        children: [
                          const Text('Giám sát điều quỹ'),
                          Text(
                            'v.${_packageInfo.version}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      leading: IconButton(
                        icon: const Icon(
                          Icons.person,
                          size: Dimension.menuIconSize,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ManagerAccountScreen(),
                            ),
                          );
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(
                            Icons.logout,
                            size: Dimension.menuIconSize,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            final dialog = confirmDialog(
                                context, 'Bạn có chắc chắn muốn đăng xuất?');
                            dialog.then((value) {
                              if (value == true) {
                                _cubit.logout();
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                      bottom: const TabBar(
                        indicatorColor: AppColors.error,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(
                            child: Text(
                              'Cảnh báo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'PYC tạm',
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
                        waitingProcessWarningListView(),
                        waitingProcessTempFormListView(),
                      ],
                    ),
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
  Widget waitingProcessWarningListView() {
    return _warningList.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const EmptyWidget(message: 'Hiện không có cảnh báo cần xử lý'),
                const SizedBox(height: 20),
                PrimaryButton(
                  title: 'Kiểm tra danh sách cảnh báo',
                  buttonHeight: 50,
                  onPressed: () => _cubit.getWarningList(),
                )
              ],
            ),
          )
        : ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: AppColors.textDefaultLight,
            ),
            shrinkWrap: true,
            itemCount: _warningList.length,
            itemBuilder: (_, index) {
              return ManagerRoleWarningItem(
                warning: _warningList[index],
                isProcessed: false,
                onTap: () {
                  final handleWarning = Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagerWarningsHandlerScreen(
                        id: _warningList[index].id ?? '',
                      ),
                    ),
                  );
                  handleWarning.then((value) {
                    logger.d('===handleWarning $value');
                    if (value == true) {
                      _cubit.getWarningList();
                    }
                  });
                },
              );
            },
          );
  }

  Widget waitingProcessTempFormListView() {
    return _tempFormList.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const EmptyWidget(message: 'Hiện không có PYC tạm cần xử lý'),
                const SizedBox(height: 20),
                PrimaryButton(
                  title: 'Kiểm tra danh sách PYC tạm',
                  buttonHeight: 50,
                  onPressed: () => _cubit.getTempFormListNeedToHandle(),
                )
              ],
            ),
          )
        : ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: AppColors.textDefaultLight,
            ),
            shrinkWrap: true,
            itemCount: _tempFormList.length,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {
                  final handleWarning = Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagerTempFormHandlerScreen(
                        tempForm: _tempFormList[index],
                      ),
                    ),
                  );
                  handleWarning.then(
                    (value) {
                      if (value == true) {
                        _cubit.getTempFormListNeedToHandle();
                      }
                    },
                  );
                },
                child: TempFormHistoryItem(
                  tempFormHistoryResponse: _tempFormList[index],
                ),
              );
            },
          );
  }
}

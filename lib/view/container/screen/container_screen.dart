import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/data/model/container/menu_type.dart';
import 'package:mvvm_cubit/data/notification_service/notification_service.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/manager/hive_storage_manager.dart';
import 'package:mvvm_cubit/view/account/account_screen.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/container/widget/menu_widget.dart';
import 'package:mvvm_cubit/view/main/screen/main_screen.dart';
import 'package:mvvm_cubit/view/notification/screen/notification_screen.dart';
import 'package:mvvm_cubit/view/report_sos/screen/report_sos_screen.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/container/container_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen>
    with WidgetsBindingObserver {
  bool isOpened = false;
  String title = 'Lộ trình';
  ContainerCubit containerCubit = ContainerCubit(repository: di());
  final HiveStorageManager _hiveStorageManager = di();
  AuthCubit authCubit = AuthCubit(
    repository: di(),
    secureStorageManager: di(),
    hiveStorageManager: di(),
  );
  LoginResponse? _loginData;

  MenuType _menuType = MenuType.trip;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  int _totalUnreadNotification = 0;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  toggleMenu([bool end = false]) {
    if (end) {
      final state = _sideMenuKey.currentState!;
      if (state.isOpened) {
        state.closeSideMenu();
      } else {
        state.openSideMenu();
      }
    } else {
      final state0 = _sideMenuKey.currentState!;
      if (state0.isOpened) {
        state0.closeSideMenu();
      } else {
        state0.openSideMenu();
      }
    }
  }

  late PushNotificationService _pushNotificationService;

  @override
  void initState() {
    super.initState();
    _initializePushNotifications();
    _hiveStorageManager.getLoginData().then(
      (value) {
        setState(() {
          _loginData = value;
        });
      },
    );

    _initPackageInfo();

    containerCubit.totalUnreadNotification();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _initializePushNotifications() async {
    _pushNotificationService = PushNotificationService();
    await _pushNotificationService.initialize(
      (token) => containerCubit.updatePushToken(token),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      containerCubit.totalUnreadNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContainerCubit>(create: (context) => containerCubit),
        BlocProvider<AuthCubit>(create: (context) => authCubit),
      ],
      child: BlocConsumer<ContainerCubit, GenericCubitState<dynamic>>(
        listener: (context, state) {
          final data = state.data;
          if (data is MenuType) {
            titlePage(data);
          } else if (data is TotalUnreadNotificationMainState) {
            logger.d('==== data ${data.total}');
            _totalUnreadNotification = data.total;
          }
        },
        builder: (context, state) {
          return BlocBuilder<ContainerCubit, GenericCubitState>(
            builder: (context, state) {
              return PopScope(
                canPop: false,
                child: SideMenu(
                  key: _sideMenuKey,
                  background: AppColors.primary,
                  type: SideMenuType.slide,
                  maxMenuWidth: 230,
                  menu: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: MenuScreen(
                      version: _packageInfo.version,
                      loginResponse: _loginData,
                      totalUnreadNoti: _totalUnreadNotification,
                      valueChanged: (value) {
                        setState(() {
                          _menuType = value;
                          titlePage(_menuType);
                        });
                      },
                    ),
                  ),
                  onChange: (isOpened) {
                    setState(() => this.isOpened = isOpened);
                  },
                  child: IgnorePointer(
                    ignoring: isOpened,
                    child: Scaffold(
                      appBar: AppBar(
                        centerTitle: true,
                        leading: IconButton(
                          icon: const Icon(Icons.menu,
                              size: Dimension.menuIconSize,
                              color: Colors.white),
                          onPressed: () => toggleMenu(true),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  backgroundColor: AppColors.error),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const ReportSOSScreen(),
                                  barrierDismissible: false,
                                );
                              },
                              child: const Icon(
                                Icons.sos,
                                color: AppColors.white,
                                size: Dimension.menuIconSize,
                              ),
                            ),
                          ),
                        ],
                        title: Text(title),
                      ),
                      body: BlocBuilder<ContainerCubit, GenericCubitState>(
                        builder: (context, state) {
                          return contentWidget(_menuType);
                        },
                      ),
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

  void titlePage(MenuType? menuType) {
    toggleMenu();
    switch (menuType) {
      case MenuType.trip:
        title = 'Lộ trình';
      case MenuType.account:
        title = 'Tài khoản';
      case MenuType.notification:
        title = 'Thông báo';
      case MenuType.logOut:
        title = '';
        forceLogout();
      default:
        break;
    }
  }

  void forceLogout() {
    authCubit.logout();
    MainScreenState.cancelFetchingTrip();
    MainScreenState.cancelFetchingWarning();
    navigateTo(const LoginScreen());
  }

  Widget contentWidget(MenuType? menuType) {
    switch (menuType) {
      case MenuType.trip:
        return const MainScreen();
      case MenuType.account:
        return const AccountScreen();
      case MenuType.notification:
        return const NotificationScreen();
      default:
        return const MainScreen();
    }
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

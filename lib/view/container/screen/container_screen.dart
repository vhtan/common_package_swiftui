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
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
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

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

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

  final _pushNotificationService = PushNotificationService();

  @override
  void initState() {
    super.initState();
    _initializePushNotifications();
    _hiveStorageManager.getLoginData().then((value) {
      setState(() {
        _loginData = value;
      });
    });
  }

  Future<void> _initializePushNotifications() async {
    await _pushNotificationService.initialize();
    final token = await _pushNotificationService.getFCMToken();
    logger.d('Firebase push token $token');
    if (token != null) {
      containerCubit.updatePushToken(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContainerCubit>(create: (context) => containerCubit),
        BlocProvider<AuthCubit>(create: (context) => authCubit),
      ],
      child: BlocConsumer<ContainerCubit, GenericCubitState<MenuType>>(
        listener: (context, state) => titlePage(state.data),
        builder: (context, state) {
          return BlocBuilder<ContainerCubit, GenericCubitState<MenuType>>(
            builder: (context, state) {
              return SideMenu(
                key: _sideMenuKey,
                background: AppColors.primary,
                type: SideMenuType.slide,
                maxMenuWidth: 230,
                menu: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: MenuScreen(
                    loginResponse: _loginData,
                    valueChanged: (value) {
                      containerCubit.menuAction(value);
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
                            size: Dimension.menuIconSize, color: Colors.white),
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
                    body: BlocBuilder<ContainerCubit,
                            GenericCubitState<MenuType>>(
                        builder: (context, state) => contentWidget(state.data)),
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

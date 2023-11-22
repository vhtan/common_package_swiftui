import 'dart:async';
import 'package:diffutil_dart/diffutil.dart' as diffutil;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/data/model/container/menu_type.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';
import 'package:mvvm_cubit/data/notification_service/notification_service.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/main.dart';
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
import 'package:mvvm_cubit/view/notification_details/notification_details_emergency_screen.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen>
    with WidgetsBindingObserver {
  bool isOpened = false;
  String title = 'Lộ trình';
  final _containerCubit = ContainerCubit(repository: di());
  final HiveStorageManager _hiveStorageManager = di();
  AuthCubit authCubit = AuthCubit(
    repository: di(),
    secureStorageManager: di(),
    hiveStorageManager: di(),
  );
  LoginResponse? _loginData;

  MenuType _menuType = MenuType.trip;

  List<NotificationResponse> _emergencyList = [];
  bool _isShowEmergency = false;
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  int _totalUnreadNotification = 0;
  static Timer? _fetchEmergency;
  final _timerDuration = const Duration(seconds: 10);

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

    _containerCubit.totalUnreadNotification();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startFetchingEmergency();
      Future.delayed(const Duration(seconds: 2), () {
        _containerCubit.getEmergencyNotificationList();
      });
    });
  }

  void startFetchingEmergency() {
    cancelFetchingEmergency();
    _fetchEmergency = Timer.periodic(
      _timerDuration,
      (timer) {
        _containerCubit.getEmergencyNotificationList();
      },
    );
  }

  static void cancelFetchingEmergency() {
    _fetchEmergency?.cancel();
    _fetchEmergency = null;
  }

  @override
  void dispose() {
    cancelFetchingEmergency();
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
      (token) => _containerCubit.updatePushToken(token),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _containerCubit.getEmergencyNotificationList();
      startFetchingEmergency();
    } else if (state == AppLifecycleState.inactive) {
      cancelFetchingEmergency();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContainerCubit>(create: (context) => _containerCubit),
        BlocProvider<AuthCubit>(create: (context) => authCubit),
      ],
      child: BlocConsumer<ContainerCubit, GenericCubitState>(
        listener: (context, state) {
          final data = state.data;
          if (data is MenuType) {
            titlePage(data);
          } else if (data is TotalUnreadNotificationMainState) {
            _totalUnreadNotification = data.total;
          } else if (data is EmergencyNotificationListSuccess) {
            var list = data.list;
            var listDiff = diffutil
                .calculateListDiff(
                  _emergencyList,
                  list,
                )
                .getUpdates();
            logger.d('===list $list');
            logger.d('===_emergencyList $_emergencyList');
            if (list.isNotEmpty &&
                _emergencyList.isNotEmpty &&
                listDiff.isEmpty) {
              return;
            } else {
              if (_isShowEmergency) {
                Navigator.pop(context);
              }
            }
            _emergencyList = List.from(list);
            final first = list.first;
            _isShowEmergency = true;
            showEmergencyDialog(first).then(
              (value) {
                _containerCubit.readNotification(first.id ?? '');
                _isShowEmergency = false;
                if (list.isNotEmpty) {
                  list.removeAt(0);
                  _containerCubit.updateEmergencyNotificationList(list);
                }
              },
            );
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
    _ContainerScreenState.cancelFetchingEmergency();
    authCubit.logout();
    AuthManager.instance.setLoggedIn(false);
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

  Future<dynamic> showEmergencyDialog(NotificationResponse item) {
    return showDialog(
      context: context,
      builder: (context) => NotificationEmergencyDetailsScreen(
        notification: item,
      ),
      barrierDismissible: false,
    );
  }

  void navigateTo(Widget screen) {
    if (!mounted) return;
    final name = screen.runtimeType.toString();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(
          name: name,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/container/menu_type.dart';
import 'package:mvvm_cubit/view/account/account_screen.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/container/widget/menu_widget.dart';
import 'package:mvvm_cubit/view/main/screen/main_screen.dart';
import 'package:mvvm_cubit/view/notification/screen/notification_screen.dart';
import 'package:mvvm_cubit/view/report_sos/screen/report_sos_screen.dart';
import 'package:mvvm_cubit/viewmodel/container/container_cubit.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  bool isOpened = false;
  String title = 'Lộ trình';

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContainerCubit, GenericCubitState<MenuType>>(
      listener: (context, state) => titlePage(state.data),
      builder: (context, state) {
        return BlocBuilder<ContainerCubit, GenericCubitState<MenuType>>(
          builder: (context, state) {
            return SideMenu(
              key: _sideMenuKey,
              inverse: false, // end side menu
              background: AppColors.primary,
              type: SideMenuType.slide,
              maxMenuWidth: 230,
              menu: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: MenuScreen(
                  valueChanged: (value) =>
                      context.read<ContainerCubit>().menuAction(value),
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
                      IconButton(
                        icon: const Icon(
                          Icons.sos,
                          color: AppColors.error,
                          size: Dimension.menuIconSize,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ReportSOSScreen(),
                            barrierDismissible: false,
                          );
                        },
                      )
                    ],
                    title: Text(title),
                  ),
                  body:
                      BlocBuilder<ContainerCubit, GenericCubitState<MenuType>>(
                          builder: (context, state) =>
                              contentWidget(state.data)),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void titlePage(MenuType? menuType) {
    toggleMenu();
    switch (menuType) {
      case MenuType.route:
        title = 'Lộ trình';
      case MenuType.account:
        title = 'Tài khoản';
      case MenuType.notification:
        title = 'Thông báo';
      case MenuType.logOut:
        title = '';
        navigateTo(const LoginScreen());
      default:
        break;
    }
  }

  Widget contentWidget(MenuType? menuType) {
    switch (menuType) {
      case MenuType.route:
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/container/container_view_status.dart';
import 'package:mvvm_cubit/view/account/account_screen.dart';
import 'package:mvvm_cubit/view/container/menu_screen.dart';
import 'package:mvvm_cubit/view/main/screen/main_screen.dart';
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
    return SideMenu(
      key: _sideMenuKey,
      inverse: false, // end side menu
      background: AppColors.primary,
      type: SideMenuType.slide,
      maxMenuWidth: 230,
      menu: const Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: MenuScreen(),
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
                onPressed: () => toggleMenu(),
              )
            ],
            title: Text(title),
          ),
          body: BlocConsumer<ContainerCubit, ContainerViewStatus>(
            listener: (context, state) {
              toggleMenu();
              switch (state) {
                case ContainerViewStatus.route:
                  title = 'Lộ trình';
                case ContainerViewStatus.account:
                  title = 'Tài khoản';
                case ContainerViewStatus.logout:
                  title = '';
              }
            },
            builder: (context, state) {
              return BlocBuilder<ContainerCubit, ContainerViewStatus>(
                builder: (context, state) {
                  switch (state) {
                    case ContainerViewStatus.route:
                      return const MainScreen();
                    case ContainerViewStatus.account:
                      return const AccountScreen();
                    default:
                      return const MainScreen();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

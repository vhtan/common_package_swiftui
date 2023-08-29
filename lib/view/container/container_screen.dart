import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/data/model/container/container_view_status.dart';
import 'package:mvvm_cubit/view/main/screen/main_screen.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
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
      menu: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: buildMenu(),
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
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<ContainerCubit, ContainerViewStatus>(
                builder: (context, state) {
                  print(state);
                  return const MainScreen();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildMenu() {
    return SingleChildScrollView(
      // padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50.0,
                  child: Image.asset(
                    AppAsset.user,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Hello, John Doe",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          const Divider(
            thickness: 0.5,
          ),
          ListTile(
            onTap: () {
              title = 'Lộ trình';
              context.read<ContainerCubit>().showRoute();
              toggleMenu();
            },
            leading: const Icon(Icons.home,
                size: Dimension.menuIconSize, color: Colors.white),
            title: const Text(
              "Lộ trình",
              style: menuTextStyle,
            ),
            textColor: Colors.white,
            dense: true,
            selectedColor: AppColors.error,
            selected: true,
          ),
          ListTile(
            onTap: () {
              title = 'Tài khoản';
              context.read<ContainerCubit>().showAccount();
              toggleMenu();
            },
            leading: const Icon(Icons.person,
                size: Dimension.menuIconSize, color: Colors.white),
            title: const Text(
              'Tài khoản',
              style: menuTextStyle,
            ),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () => toggleMenu(),
            leading: const Icon(Icons.logout,
                size: Dimension.menuIconSize, color: Colors.white),
            title: const Text(
              "Đăng xuất",
              style: menuTextStyle,
            ),
            textColor: Colors.white,
            dense: true,
          ),
        ],
      ),
    );
  }
}

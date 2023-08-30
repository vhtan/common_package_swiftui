import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/viewmodel/container/container_cubit.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContainerCubit, GenericCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
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
              _MenuListTile(
                title: 'Lộ trình',
                icon: Icons.home,
                onTap: () => context.read<ContainerCubit>().showRoute(),
              ),
              _MenuListTile(
                title: 'Tài khoản',
                icon: Icons.person,
                onTap: () => context.read<ContainerCubit>().showAccount(),
              ),
              _MenuListTile(
                title: 'Đăng xuất',
                icon: Icons.logout,
                onTap: () => context.read<ContainerCubit>().logOut(),
              ),
            ],
          ),
        );
      },
    );
  }
}

typedef TapCallback = void Function();

class _MenuListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final TapCallback onTap;
  const _MenuListTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: Dimension.menuIconSize, color: Colors.white),
      title: Text(
        title,
        style: menuTextStyle,
      ),
      textColor: Colors.white,
      dense: true,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/dialog/delete_dialog.dart';
import 'package:mvvm_cubit/config/app_config.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/data/model/container/menu_type.dart';

class MenuScreen extends StatelessWidget {
  final LoginResponse? loginResponse;
  final ValueChanged<MenuType> valueChanged;
  final String version;
  final int totalUnreadNoti;

  const MenuScreen({
    super.key,
    required this.loginResponse,
    required this.valueChanged,
    required this.version,
    required this.totalUnreadNoti,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text(
                loginResponse?.name?.decodeHtml ?? '',
                style: const TextStyle(color: Colors.white),
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
          icon: const Icon(
            Icons.home,
            size: Dimension.menuIconSize,
            color: Colors.white,
          ),
          onTap: () => valueChanged(MenuType.trip),
        ),
        _MenuListTile(
          title: 'Lịch sử SOS',
          icon: const Icon(
            Icons.sos_sharp,
            size: Dimension.menuIconSize,
            color: Colors.white,
          ),
          onTap: () => valueChanged(MenuType.sosHistories),
        ),
        _MenuListTile(
          title: 'Lịch sử PYC tạm',
          icon: const Icon(
            Icons.edit_document,
            size: Dimension.menuIconSize,
            color: Colors.white,
          ),
          onTap: () => valueChanged(MenuType.requestForm),
        ),
        _MenuListTile(
          title: 'Lịch sử cảnh báo',
          icon: const Icon(
            Icons.warning,
            size: Dimension.menuIconSize,
            color: Colors.white,
          ),
          onTap: () => valueChanged(MenuType.warnings),
        ),
        _MenuListTile(
          title: 'Lỗi không tuân thủ',
          icon: const Icon(
            Icons.block,
            size: Dimension.menuIconSize,
            color: Colors.white,
          ),
          onTap: () => valueChanged(MenuType.fault),
        ),
        _MenuListTile(
          title: 'Tài khoản',
          icon: const Icon(
            Icons.person,
            size: Dimension.menuIconSize,
            color: Colors.white,
          ),
          onTap: () => valueChanged(MenuType.account),
        ),
        _MenuListTile(
          title: 'Thông báo',
          icon: totalUnreadNoti > 0
              ? Image.asset(
                  AppAsset.icNotificationDot,
                  width: Dimension.menuIconSize,
                  height: Dimension.menuIconSize,
                )
              : Image.asset(
                  AppAsset.icNotification,
                  width: Dimension.menuIconSize,
                  height: Dimension.menuIconSize,
                ),
          onTap: () => valueChanged(MenuType.notification),
        ),
        _MenuListTile(
          title: 'Đăng xuất',
          icon: const Icon(
            Icons.logout,
            size: Dimension.menuIconSize,
            color: Colors.white,
          ),
          onTap: () {
            final dialog =
                confirmDialog(context, 'Bạn có chắc chắn muốn đăng xuất?');
            dialog.then((value) {
              if (value == true) {
                valueChanged(MenuType.logOut);
              }
            });
          },
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            (environment.environmentConfig == Env.DEV)
                ? 'dev.v.$version'
                : 'v.$version',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}

class _MenuListTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  const _MenuListTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      title: Text(
        title,
        style: menuTextStyle,
      ),
      textColor: Colors.white,
      dense: true,
    );
  }
}

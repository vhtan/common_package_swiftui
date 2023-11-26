import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/manager/hive_storage_manager.dart';
import 'package:mvvm_cubit/core/app_extension.dart';

class ManagerAccountScreen extends StatefulWidget {
  const ManagerAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ManagerAccountScreenState();
}

class _ManagerAccountScreenState extends State<ManagerAccountScreen> {
  LoginResponse? _loginResponse;
  final _hiveStorageManager = di<HiveStorageManager>();

  @override
  void initState() {
    super.initState();
    _hiveStorageManager.getLoginData().then((value) => {
          setState(() {
            _loginResponse = value;
          })
        });
  }

  PreferredSizeWidget get _appBar {
    return AppBar(
      leading: const BackButton(
        color: AppColors.white,
      ),
      automaticallyImplyLeading: true,
      title: const Text(
        "Thông tin tài khoản",
        style: headLine1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppAsset.user,
              width: 160,
              height: 160,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _loginResponse?.name?.decodeHtml ?? '',
              style: headLine1,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              _loginResponse?.email?.decodeHtml ?? '',
              style: textDefault,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _loginResponse?.role?.name?.decodeHtml ?? '',
              style: textDefault,
            )
          ],
        ),
      ),
    );
  }
}

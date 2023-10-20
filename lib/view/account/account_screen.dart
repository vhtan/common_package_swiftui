import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/manager/hive_storage_manager.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _loginResponse?.name ?? '',
            style: headLine1,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            _loginResponse?.email ?? '',
            style: textDefault,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            _loginResponse?.role?.name ?? '',
            style: textDefault,
          )
        ],
      ),
    );
  }
}

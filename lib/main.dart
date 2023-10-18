import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/container/screen/container_screen.dart';
import 'package:mvvm_cubit/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_cubit/view/manager_role/warning_list/screen/manager_role_warning_list_screen.dart';

import 'di.dart';

void main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? loginToken = await secureStorage.read(key: StoreKey.loginToken);
  String? roleCode = await secureStorage.read(key: StoreKey.roleCode);
  ApiConfig.header['Authorization'] = loginToken;
  final osVersion = await _getOSVersion();
  ApiConfig.header['os-version'] = osVersion;

  AuthManager.setTokenExpiredCallback(() {
    runApp(
      const MyApp(),
    );
  });

  runApp(
    MyApp(token: loginToken, roleCode: roleCode),
  );
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? roleCode;

  const MyApp({
    Key? key,
    this.token,
    this.roleCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightAppTheme,
      home: (token == null)
          ? const LoginScreen()
          : (roleCode == 'ATAI'
              ? const ContainerScreen()
              : const ManagerRoleWrningListScreen()),
    );
  }
}

class AuthManager {
  static late Function? onTokenExpired;

  static void setTokenExpiredCallback(Function callback) {
    onTokenExpired = callback;
  }

  static void notifyTokenExpired() {
    _clearLoginToken();
    if (onTokenExpired != null) {
      onTokenExpired!();
    }
  }

  static void _clearLoginToken() {
    try {
      di<FlutterSecureStorage>().delete(
        key: StoreKey.loginToken,
      );
    } on DioException catch (e) {
      logger.e(e.message);
    }
  }
}

Future<String> _getOSVersion() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    }
  } catch (e) {
    logger.d('Error getting device info: $e');
  }
  return 'unsupport';
}

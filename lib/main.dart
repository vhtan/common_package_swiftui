import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/container/screen/container_screen.dart';
import 'package:mvvm_cubit/core/app_theme.dart';
import 'package:flutter/material.dart';

import 'di.dart';

void main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? loginToken = await secureStorage.read(key: StoreKey.loginToken);
  ApiConfig.header['Authorization'] = loginToken;
  final osVersion = await getOSVersion();
  ApiConfig.header['os-version'] = osVersion;
  runApp(
    MyApp(
      token: loginToken,
    ),
  );
}

Future<String> getOSVersion() async {
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

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightAppTheme,
      home: (token == null) ? const LoginScreen() : const ContainerScreen(),
      // home: const LoginScreen(),
      // home: const ManagerRoleWrningListScreen(),
    );
  }
}

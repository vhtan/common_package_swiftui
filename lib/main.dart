import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/config/app_config.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/firebase_options.dart';
import 'package:mvvm_cubit/manager/hive_storage_manager.dart';
import 'package:mvvm_cubit/manager/secure_storage_manager.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/container/screen/container_screen.dart';
import 'package:mvvm_cubit/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_cubit/view/manager_role/warning_list/screen/manager_role_warning_list_screen.dart';

import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await di<HiveStorageManager>().initHive();
  await environment.initConfig();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  String? loginToken = await di<SecureStorageManager>().getToken();
  final loginData = await di<HiveStorageManager>().getLoginData();
  final isManager = loginData?.manager ?? false;

  AuthManager.instance.setLoggedIn(true);

  ApiConfig.header['Authorization'] = loginToken;
  final osVersion = await _getOSVersion();
  ApiConfig.header['os-version'] = osVersion;

  runApp(
    MyApp(
      token: loginToken,
      isManager: isManager,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? token;
  final bool isManager;

  const MyApp({
    super.key,
    required this.token,
    required this.isManager,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightAppTheme,
        home: (token == null)
            ? const LoginScreen()
            : (isManager
                ? const ManagerRoleWrningListScreen()
                : const ContainerScreen()));
  }
}

class AuthManager {
  static List<Function> onTokenExpireds = [];

  bool _isLoggedIn = false;

  AuthManager._();

  static final AuthManager _instance = AuthManager._();

  static AuthManager get instance => _instance;

  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
  }

  void setTokenExpiredCallback(Function callback) {
    onTokenExpireds.add(callback);
  }

  void notifyTokenExpired() {
    for (final onTokenExpired in onTokenExpireds) {
      onTokenExpired();
    }
    di<SecureStorageManager>().deleteAll();
    ApiConfig.header['Authorization'] = null;
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

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
  await init();

  await environment.initConfig();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setConfigSettings();

  FirebaseRemoteConfig.instance.fetch();
  FirebaseRemoteConfig.instance.onConfigUpdated.listen(
    (event) async {
      await FirebaseRemoteConfig.instance.activate();
    },
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  String? loginToken = await di<SecureStorageManager>().getToken();
  String? roleCode = await di<SecureStorageManager>().getRole();

  ApiConfig.header['Authorization'] = loginToken;
  final osVersion = await _getOSVersion();
  ApiConfig.header['os-version'] = osVersion;

  di<HiveStorageManager>().initHive();

  runApp(
    MyApp(token: loginToken, roleCode: roleCode),
  );
}

Future<void> setConfigSettings() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? roleCode;

  const MyApp({
    super.key,
    this.token,
    this.roleCode,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightAppTheme,
        home: (token == null)
            ? const LoginScreen()
            : (roleCode == 'ATAI'
                ? const ContainerScreen()
                : const ManagerRoleWrningListScreen()));
  }
}

class AuthManager {
  static List<Function> onTokenExpireds = [];

  static void setTokenExpiredCallback(Function callback) {
    onTokenExpireds.add(callback);
  }

  static void notifyTokenExpired() {
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

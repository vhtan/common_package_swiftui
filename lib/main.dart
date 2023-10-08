import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/container/screen/container_screen.dart';
import 'package:mvvm_cubit/view/manager_role/warning_list/screen/manager_role_warning_list_screen.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_cubit.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/check_point/check_point_cubit.dart';
import 'package:mvvm_cubit/viewmodel/container/container_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_sos_cubit.dart';

import 'di.dart';

void main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? loginToken = await secureStorage.read(key: StoreKey.loginToken);
  runApp(
    MyApp(
      token: loginToken,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(create: (context) => di()),
        BlocProvider<AuthCubit>(create: (context) => di()),
        BlocProvider<ContainerCubit>(
          create: (context) => di(),
        ),
        BlocProvider<ReportSOSCubit>(
          create: (context) => di(),
        ),
        BlocProvider<CheckPointCubit>(
          create: (context) => di(),
        ),
        BlocProvider<AddTripCubit>(
          create: (context) => di(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightAppTheme,
        home: (token == null) ? const LoginScreen() : const ContainerScreen(),
        // home: const LoginScreen(),
        // home: const ManagerRoleWrningListScreen(),
      ),
    );
  }
}

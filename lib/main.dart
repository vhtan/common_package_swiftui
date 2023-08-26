import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/main/screen/main_screen.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/core/app_theme.dart';
import 'package:flutter/material.dart';

import 'di.dart';

void main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(create: (context) => getIt<MainCubit>()),
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightAppTheme,
        home: const LoginScreen(),
      ),
    );
  }
}

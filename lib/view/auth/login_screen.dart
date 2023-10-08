import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/container/screen/container_screen.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthCubit authCubit = AuthCubit(repository: di());
  PreferredSizeWidget get _appBar {
    return AppBar(
      automaticallyImplyLeading: false,
      // leading: IconButton(
      //   onPressed: () => Navigator.pop(context),
      //   icon: const Icon(Icons.arrow_back),
      // ),
      title: const Text("Đăng nhập"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit,
      child: Scaffold(
        appBar: _appBar,
        body: BlocConsumer<AuthCubit, GenericCubitState>(
          listener: (context, state) {
            switch (state.status) {
              case Status.failure:
                showErrorSnackBar(
                  context,
                  state.error ?? AppString.sendTimeOut,
                );
              case Status.success:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContainerScreen(),
                  ),
                );
              default:
                break;
            }
          },
          builder: (context, state) {
            return BlocBuilder<AuthCubit, GenericCubitState<AuthState>>(builder:
                (BuildContext context, GenericCubitState<AuthState> state) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      AppAsset.appLogo,
                      height: 50,
                    ),
                    const SizedBox(height: 40),
                    TextInput(
                      hint: 'Nhập tên đăng nhập',
                      labelText: 'Tên đăng nhập',
                      icon: const Icon(Icons.person),
                      controller: _usernameTextController,
                      obscureText: false,
                      validator: (value) => state.data?.errorText(),
                      onChanged: (value) =>
                          context.read<AuthCubit>().usernameChanged(value),
                    ),
                    const SizedBox(height: 20),
                    TextInput(
                      hint: 'Nhập mật khẩu',
                      labelText: 'Mật khẩu',
                      icon: const Icon(Icons.lock),
                      controller: _passwordTextController,
                      obscureText: true,
                      maxLines: 1,
                      onChanged: (value) =>
                          context.read<AuthCubit>().passwordChanged(value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                      title: 'Đăng nhập',
                      buttonHeight: 50,
                      onPressed: (state.data?.isValid()) == true
                          ? () {
                              context.read<AuthCubit>().login(LoginRequest(
                                    username: _usernameTextController.text,
                                    password: _passwordTextController.text,
                                  ));
                            }
                          : null,
                    ),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }
}

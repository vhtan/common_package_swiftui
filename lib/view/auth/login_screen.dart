import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';
import 'package:mvvm_cubit/view/container/screen/container_screen.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

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
    return Scaffold(
      appBar: _appBar,
      body: BlocConsumer<AuthCubit, GenericCubitState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            // cached login response success
            ApiConfig.loginResponse = state.data;
            print('login success ${ApiConfig.loginResponse}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContainerScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<AuthCubit, GenericCubitState<LoginResponse>>(
              builder: (BuildContext context,
                  GenericCubitState<LoginResponse> state) {
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
                  _UsernameField(
                    usernameTextController: _usernameTextController,
                    onChanged: (value) =>
                        context.read<AuthCubit>().usernameChanged(value),
                  ),
                  const SizedBox(height: 20),
                  _PasswordField(
                    passwordTextController: _passwordTextController,
                    onChanged: (value) =>
                        context.read<AuthCubit>().passwordChanged(value),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryButton(
                    title: 'Đăng nhập',
                    buttonHeight: 50,
                    onPressed: () {
                      context.read<AuthCubit>().login(LoginRequest(
                          username: _usernameTextController.text,
                          password: _passwordTextController.text,
                          requestId: const Uuid().v4(),
                          requestTime: DateTime.now().microsecondsSinceEpoch));
                    },
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  final TextEditingController usernameTextController;
  final ValueChanged<String>? onChanged;
  const _UsernameField(
      {required this.usernameTextController, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return MaterialTextField(
        keyboardType: TextInputType.text,
        hint: 'Nhập tên đăng nhập',
        labelText: 'Tên đăng nhập',
        textInputAction: TextInputAction.next,
        prefixIcon: const Icon(Icons.person),
        controller: usernameTextController,
        onChanged: onChanged,
        obscureText: false);
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController passwordTextController;
  final ValueChanged<String>? onChanged;
  const _PasswordField(
      {required this.passwordTextController, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return MaterialTextField(
      keyboardType: TextInputType.visiblePassword,
      hint: 'Nhập mật khẩu',
      labelText: 'Mật khẩu',
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.lock),
      controller: passwordTextController,
      onChanged: onChanged,
      obscureText: true,
    );
  }
}

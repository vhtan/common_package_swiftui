import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
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
  final TextEditingController _phoneTextController = TextEditingController();
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
                  _PhoneField(_phoneTextController),
                  const SizedBox(height: 20),
                  _PasswordField(_passwordTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  const _CustomButton(
                    buttonHeight: 50,
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

class _PhoneField extends StatelessWidget {
  final TextEditingController phoneTextController;

  const _PhoneField(this.phoneTextController);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, GenericCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        return MaterialTextField(
            keyboardType: TextInputType.phone,
            hint: 'Nhập tên đăng nhập',
            labelText: 'Tên đăng nhập',
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.phone_outlined),
            controller: phoneTextController,
            onChanged: (value) => context.read<AuthCubit>().phoneChanged(value),
            obscureText: false);
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController passwordTextController;

  const _PasswordField(this.passwordTextController);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, GenericCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        return MaterialTextField(
          keyboardType: TextInputType.visiblePassword,
          hint: 'Nhập mật khẩu',
          labelText: 'Mật khẩu',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.lock),
          controller: passwordTextController,
          onChanged: (value) =>
              context.read<AuthCubit>().passwordChanged(value),
          obscureText: true,
        );
      },
    );
  }
}

class _CustomButton extends StatelessWidget {
  final double buttonHeight;

  const _CustomButton({required this.buttonHeight});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, GenericCubitState<LoginResponse>>(
      listener: (context, state) {},
      builder: (context, state) {
        return SizedBox(
          height: buttonHeight,
          child: FilledButton(
            onPressed: state.data?.username?.isNotEmpty == true &&
                    state.data?.password?.isNotEmpty == true
                ? () {
                    context.read<AuthCubit>().login(LoginRequest(
                        username: 'acb',
                        password: 'somePass',
                        requestId: const Uuid().v4(),
                        requestTime: DateTime.now().microsecondsSinceEpoch));
                  }
                : null,
            child: const Row(children: [
              Spacer(),
              Text(
                "Đăng nhập",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Spacer()
            ]),
          ),
        );
      },
    );
  }
}

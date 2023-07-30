import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/auth/user.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PreferredSizeWidget get _appBar {
    return AppBar(
      automaticallyImplyLeading: false,
      // leading: IconButton(
      //   onPressed: () => Navigator.pop(context),
      //   icon: const Icon(Icons.arrow_back),
      // ),
      title: const Text("Login"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: BlocConsumer<AuthCubit, GenericCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<AuthCubit, GenericCubitState<List<User>>>(builder:
              (BuildContext context, GenericCubitState<List<User>> state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _PhoneField(),
                  const SizedBox(height: 20),
                  _PasswordField(),
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
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, GenericCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        return MaterialTextField(
          keyboardType: TextInputType.phone,
          hint: 'Nhập số điện thoại',
          labelText: 'Số điện thoại',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.phone_outlined),
          controller: _emailTextController,
          validator: null,
          obscureText: false,
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController _passwordTextController = TextEditingController();

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
          controller: _passwordTextController,
          validator: null,
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
    return BlocConsumer<AuthCubit, GenericCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SizedBox(
          height: buttonHeight,
          child: FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Row(children: [
              Spacer(),
              Text(
                "Đăng nhập",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
              Spacer()
            ]),
          ),
        );
      },
    );
  }
}

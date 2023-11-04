import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/dialog/progress_dialog.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/common/snack_bar/error_snack_bar.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/config/app_config.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_string.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';
import 'package:mvvm_cubit/di.dart';
import 'package:mvvm_cubit/view/container/screen/container_screen.dart';
import 'package:mvvm_cubit/view/manager_role/warning_list/screen/manager_role_warning_list_screen.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = '';
  String _password = '';

  final GlobalKey<State> progressKey = GlobalKey<State>();

  AuthCubit authCubit = AuthCubit(
    repository: di(),
    secureStorageManager: di(),
    hiveStorageManager: di(),
  );

  PreferredSizeWidget get _appBar {
    return AppBar(
      automaticallyImplyLeading: false,
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
              case Status.loading:
                showProgressDialog(
                  context,
                  progressKey,
                );
              case Status.failure:
                if (progressKey.currentContext != null) {
                  logger.d('message $progressKey');
                  Navigator.pop(context);
                }
                showErrorSnackBar(
                  context,
                  state.error ?? AppString.sendTimeOut,
                );
              case Status.success:
                final loginSuccess = state.data;
                logger.d('loginSuccess => $loginSuccess');
                if (loginSuccess is LoginStateSuccess) {
                  if (loginSuccess.isManager) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ManagerRoleWrningListScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContainerScreen(),
                      ),
                    );
                  }
                }
              default:
                break;
            }
          },
          builder: (context, state) {
            return BlocBuilder<AuthCubit, GenericCubitState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(environment.fullUrl()),
                        Image.asset(
                          AppAsset.appLogo,
                          height: 50,
                        ),
                        const SizedBox(height: 40),
                        TextInput(
                          keyboardType: TextInputType.emailAddress,
                          hint: 'Nhập tên đăng nhập',
                          labelText: 'Tên đăng nhập',
                          icon: const Icon(Icons.person),
                          obscureText: false,
                          // validator: (value) => inputData?.errorText(),
                          onChanged: (value) {
                            setState(() {
                              _username = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        TextInput(
                          hint: 'Nhập mật khẩu',
                          labelText: 'Mật khẩu',
                          icon: const Icon(Icons.lock),
                          obscureText: true,
                          maxLines: 1,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PrimaryButton(
                          title: 'Đăng nhập',
                          buttonHeight: 50,
                          // onPressed: _isValidLogin()
                          //     ? () {
                          //         authCubit.login(
                          //           LoginRequest(
                          //             username: _username,
                          //             password: _password,
                          //           ),
                          //         );
                          //       }
                          //     : null,
                          onPressed: () {
                            authCubit.login(
                              LoginRequest(
                                username: 'user02',
                                password: 'Abc@123456',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  bool _isValidLogin() {
    bool isValidPassword = false;
    bool isValidUsername = false;

    if (_password.isNotEmpty) {
      isValidPassword = true;
    }

    if (_username.isNotEmpty) {
      isValidUsername = true;
    }
    return isValidPassword && isValidUsername;
  }
}

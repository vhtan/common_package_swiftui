import 'package:mvvm_cubit/common/network/api_helper.dart';
import 'package:mvvm_cubit/common/network/dio_client.dart';
import 'package:mvvm_cubit/data/model/auth/user.dart';
import 'package:mvvm_cubit/core/api_config.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';

class AuthApi with ApiHelper<User> {
  final DioClient client;

  AuthApi({required this.client});

  Future<dynamic> login(LoginRequest request) async {
    return await makePostRequest(
        client.dio.post(ApiConfig.login, data: request));
  }
}

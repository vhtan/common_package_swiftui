import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/auth/auth_api.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';

class AuthRepository with RepositoryHelper<LoginResponse> {
  final AuthApi api;

  const AuthRepository({required this.api});

  Future<dynamic> login(LoginRequest request) async {
    return api.login(request);
  }
}

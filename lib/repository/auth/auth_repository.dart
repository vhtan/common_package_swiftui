import 'package:mvvm_cubit/common/repository/repository_helper.dart';
import 'package:mvvm_cubit/data/api/auth/auth_api.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';

class AuthRepository with RepositoryHelper<LoginResponse> {
  final AuthApi _api;

  const AuthRepository({required AuthApi api}) : _api = api;

  Future<dynamic> login(LoginRequest request) async {
    return _api.login(request);
  }

  Future<dynamic> logout() async {
    return _api.logout();
  }
}

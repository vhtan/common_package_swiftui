import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/data/model/auth/user.dart';
import 'package:mvvm_cubit/data/request/auth/login_request.dart';
import 'package:mvvm_cubit/repository/auth/auth_repository.dart';

class AuthCubit extends GenericCubit<User> {
  final AuthRepository repository;

  AuthCubit({required this.repository});

  Future<void> getPosts(LoginRequest request) async {
    createItem(repository.login(request));
  }
}

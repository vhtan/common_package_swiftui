import 'package:material_text_fields/utils/extensions.dart';

class AuthState {
  final String? username;
  final String? password;
  final bool? isManager;

  AuthState({
    this.username,
    this.password,
    this.isManager,
  });

  String? errorText() {
    if (username == null) {
      return null;
    }
    if (username?.isEmpty == true) {
      return 'Vui lòng nhập tên đăng nhập';
    } else {
      return null;
    }
  }

  bool isValid() {
    bool isValidPassword = false;
    bool isValidUsername = false;

    if ((password ?? '').isNotEmpty) {
      isValidPassword = true;
    }

    if ((username ?? '').isNotEmpty) {
      isValidUsername = true;
    }
    return isValidPassword && isValidUsername;
  }
}

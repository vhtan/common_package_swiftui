class AuthState {}

class LoginStateInput extends AuthState {
  final String? username;
  final String? password;

  LoginStateInput({
    this.username,
    this.password,
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

class LoginStateSuccess extends AuthState {
  bool isManager;
  LoginStateSuccess([
    isManager,
  ]) : isManager = false;
}

class LogoutStateSuccess extends AuthState {}

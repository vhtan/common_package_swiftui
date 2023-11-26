class AuthState {}

class LoginStateSuccess extends AuthState {
  bool isManager;
  LoginStateSuccess({
    required this.isManager,
  });
}

class LogoutStateSuccess extends AuthState {}

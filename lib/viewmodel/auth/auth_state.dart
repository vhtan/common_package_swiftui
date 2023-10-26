class AuthState {}

class LoginStateSuccess extends AuthState {
  bool isManager;
  LoginStateSuccess(
    this.isManager,
  );
}

class LogoutStateSuccess extends AuthState {}

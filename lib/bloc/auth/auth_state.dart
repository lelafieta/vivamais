abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AppStartState extends AuthState {}

class AuthLoading extends AuthState {}

class AuthCheckVersion extends AuthState {}

class AuthCheckRootDevice extends AuthState {
  final bool isRoot;
  AuthCheckRootDevice(this.isRoot);
}

class AuthSuccess extends AuthState {
  final String token;

  AuthSuccess(this.token);
}

class AuthSuccessToken extends AuthState {
  final String token;

  AuthSuccessToken(this.token);
}

class AuthFailure extends AuthState {
  final String error;
  final int code;

  AuthFailure(this.error, this.code);
}

class AuthLogout extends AuthState {}

class AuthResetCode extends AuthState {
  final String identfyed;

  AuthResetCode({required this.identfyed});
}

class AuthSuccessResetCodeState extends AuthState {}

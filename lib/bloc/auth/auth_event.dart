part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AppLoaded extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;
  final String phoneCode;

  AuthLoginRequested(
      {required this.phoneCode,
      required this.username,
      required this.password});
}

class AuthCheckCode extends AuthEvent {
  final String identfyed;
  final String code;

  AuthCheckCode({required this.identfyed, required this.code});
}

class UserLoggedOut extends AuthEvent {}

class AuthCheckToken extends AuthEvent {}

class AuthResetCodeEvent extends AuthEvent {
  final String identfyed;
  final String phoneCode;

  AuthResetCodeEvent({required this.phoneCode, required this.identfyed});
}

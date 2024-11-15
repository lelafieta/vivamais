import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial implements AuthState {}

class Authenticated implements AuthState {
  final String uid;

  const Authenticated({required this.uid});
}

class AuthenticatedWithGoogle implements AuthState {
  final UserCredential user;

  const AuthenticatedWithGoogle({required this.user});
}

class AuthLoading implements AuthState {}

class UnAuthenticated implements AuthState {}

class AuthError implements AuthState {
  final String error;

  AuthError({required this.error});
}

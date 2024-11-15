import 'package:firebase_auth/firebase_auth.dart';

abstract class CredencialState {}

class CredencialInitial implements CredencialState {}

class Credencialenticated implements CredencialState {
  final String uid;

  const Credencialenticated({required this.uid});
}

class CredencialenticatedWithGoogle implements CredencialState {
  final UserCredential user;

  const CredencialenticatedWithGoogle({required this.user});
}

class CredencialLoading implements CredencialState {}

class UnCredencialenticated implements CredencialState {}

class CredencialError implements CredencialState {
  final String error;

  CredencialError({required this.error});
}

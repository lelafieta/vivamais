class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final bool isUserExists;

  UserSuccess({required this.isUserExists});
}

class UserFailure extends UserState {
  final String error;
  UserFailure(this.error);
}

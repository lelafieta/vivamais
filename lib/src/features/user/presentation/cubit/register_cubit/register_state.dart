class RegisterState {}

class UserInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  RegisterSuccess();
}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}

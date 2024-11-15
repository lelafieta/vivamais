class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthCodeSent extends PhoneAuthState {
  final String verificationId;
  PhoneAuthCodeSent({required this.verificationId});
}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthSuccess extends PhoneAuthState {}

class PhoneAuthFailure extends PhoneAuthState {
  final String error;
  PhoneAuthFailure(this.error);
}

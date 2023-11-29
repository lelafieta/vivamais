class BiometricState {
//AppLifecycleState state;
  const BiometricState();
}

class BiometricSuccessState extends BiometricState {}

class BiometricFailureState extends BiometricState {
  final String error;

  BiometricFailureState({required this.error});
}

class BiometricStartingState extends BiometricState {}

class BiometricWaitingState extends BiometricState {}

class BiometricEvent {
  const BiometricEvent();
}

class BiometricSuccessEvent extends BiometricEvent {}

class BiometricFailureEvent extends BiometricEvent {}

class BiometricStartingEvent extends BiometricEvent {}

class BiometricWaitingEvent extends BiometricEvent {}

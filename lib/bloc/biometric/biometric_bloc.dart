import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maxalert/bloc/biometric/biometric_event.dart';
import 'package:maxalert/bloc/biometric/biometric_state.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  BiometricBloc() : super(BiometricStartingState()) {
    on<BiometricStartingEvent>((event, emit) async {
      //emit(BiometricWaitingState());
      final LocalAuthentication _localAuthentication = LocalAuthentication();
      try {
        final isAuthenticated = await _localAuthentication.authenticate(
            localizedReason:
                'Por favor, autentique-se para acessar o aplicativo.',
            options: const AuthenticationOptions(useErrorDialogs: false),
            authMessages: const <AuthMessages>[
              AndroidAuthMessages(
                signInTitle: 'Oops! Autenticação biometrica obrigatória!',
                cancelButton: 'Obrigado',
                biometricHint: "Verificação de identidade",
              ),
              IOSAuthMessages(
                cancelButton: 'Obrigado',
              ),
            ]);

        if (isAuthenticated) {
          print("Biometric Status");
          print(isAuthenticated);
          emit(BiometricSuccessState());
        } else {
          emit(BiometricFailureState(
              error: 'Falha na autenticação biométrica.'));
        }
      } catch (e) {
        emit(BiometricSuccessState());
        print("Biometric Status");
        //emit(BiometricFailureState(error: 'Falha na autenticação biométrica.'));
      }
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/usecases/sign_in_with_credential_usecase.dart';
import '../../domain/usecases/verify_phone_number_usecase.dart';
import 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;
  final SignInWithCredentialUseCase signInWithCredentialUseCase;
  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  PhoneAuthCubit({
    required this.verifyPhoneNumberUseCase,
    required this.signInWithCredentialUseCase,
  }) : super(PhoneAuthInitial());

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      emit(PhoneAuthLoading());
      await verifyPhoneNumberUseCase.call(phoneNumber,
          (verificationId, resendToken) {
        emit(PhoneAuthCodeSent(verificationId: verificationId));
      });
    } catch (e) {
      emit(PhoneAuthFailure(e.toString()));
    }
  }

  Future<void> signInWithSmsCode(String verificationId, String smsCode) async {
    emit(PhoneAuthLoading());
    try {
      final String? uid =
          await signInWithCredentialUseCase.call(verificationId, smsCode);
      await secureStorage.write(key: "uid", value: uid);
      emit(PhoneAuthSuccess());
    } catch (e) {
      emit(PhoneAuthFailure(e.toString()));
    }
  }
}

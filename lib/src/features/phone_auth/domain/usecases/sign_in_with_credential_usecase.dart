import '../repositories/i_phone_auth_repository.dart';

class SignInWithCredentialUseCase {
  final IPhoneAuthRepository repository;

  SignInWithCredentialUseCase({required this.repository});

  Future<String?> call(String verificationId, String smsCode) async {
    return await repository.signInWithCredential(verificationId, smsCode);
  }
}

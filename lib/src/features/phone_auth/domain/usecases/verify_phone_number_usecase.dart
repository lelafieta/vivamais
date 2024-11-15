import '../repositories/i_phone_auth_repository.dart';

class VerifyPhoneNumberUseCase {
  final IPhoneAuthRepository repository;

  VerifyPhoneNumberUseCase({required this.repository});

  Future<bool> call(String phoneNumber,
      Function(String verificationId, int? resendToken) codeSent) async {
    return await repository.verifyPhoneNumber(phoneNumber, codeSent);
  }
}

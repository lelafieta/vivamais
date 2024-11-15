import '../repositories/i_user_repository.dart';

class SendOtpNumberUseCase {
  final IUserRepository repository;

  SendOtpNumberUseCase({required this.repository});

  Future<bool> call(String code, String verificationId) async {
    return await repository.sendOtpNumber(code, verificationId);
  }
}

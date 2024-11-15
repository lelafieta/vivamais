import '../repositories/i_user_repository.dart';

class VerifyNumberUseCase {
  final IUserRepository repository;

  VerifyNumberUseCase({required this.repository});

  Future<void> call(String number) {
    return repository.verifyNumber(number);
  }
}

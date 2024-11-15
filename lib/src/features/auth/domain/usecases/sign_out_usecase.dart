import '../repositories/i_user_repository.dart';

class SignOutUseCase {
  final IUserRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}

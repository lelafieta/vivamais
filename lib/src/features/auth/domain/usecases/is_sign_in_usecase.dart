import '../repositories/i_user_repository.dart';

class IsSignInUseCase {
  final IUserRepository repository;

  IsSignInUseCase({required this.repository});

  Future<bool> call() {
    return repository.isSignIn();
  }
}

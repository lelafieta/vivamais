import '../repositories/i_user_repository.dart';

class GetCurrentUidUseCase {
  final IUserRepository repository;

  GetCurrentUidUseCase({required this.repository});

  Future<String> call() {
    return repository.getCurrentUid();
  }
}

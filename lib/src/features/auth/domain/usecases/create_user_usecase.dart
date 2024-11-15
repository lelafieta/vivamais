import '../../../user/domain/entities/user_entity.dart';
import '../repositories/i_user_repository.dart';

class CreateUserUseCase {
  final IUserRepository repository;

  CreateUserUseCase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.createUser(user);
  }
}

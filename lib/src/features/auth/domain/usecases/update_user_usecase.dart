import '../../../user/domain/entities/user_entity.dart';
import '../repositories/i_user_repository.dart';

class UpdateUserUseCase {
  final IUserRepository repository;

  UpdateUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.updateUser(userEntity);
  }
}

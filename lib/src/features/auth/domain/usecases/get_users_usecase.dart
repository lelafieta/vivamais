import '../../../user/domain/entities/user_entity.dart';
import '../repositories/i_user_repository.dart';

class GetUsersUseCase {
  final IUserRepository repository;

  GetUsersUseCase({required this.repository});

  Stream<List<UserEntity>> call(UserEntity userEntity) {
    return repository.getUsers(userEntity);
  }
}

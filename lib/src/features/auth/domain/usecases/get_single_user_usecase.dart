import '../../../user/domain/entities/user_entity.dart';
import '../repositories/i_user_repository.dart';

class GetSingleUserUseCase {
  final IUserRepository repository;

  GetSingleUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String uid) {
    return repository.getSingleUser(uid);
  }
}

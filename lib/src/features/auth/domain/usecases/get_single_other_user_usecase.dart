import '../../../user/domain/entities/user_entity.dart';
import '../repositories/i_user_repository.dart';

class GetSingleOtherUserUseCase {
  final IUserRepository repository;

  GetSingleOtherUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String otherUid) {
    return repository.getSingleOtherUser(otherUid);
  }
}

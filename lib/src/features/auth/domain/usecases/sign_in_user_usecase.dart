import '../../../user/domain/entities/user_entity.dart';
import '../repositories/i_user_repository.dart';

class SignInUserUseCase {
  final IUserRepository repository;

  SignInUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.signInUser(userEntity);
  }
}

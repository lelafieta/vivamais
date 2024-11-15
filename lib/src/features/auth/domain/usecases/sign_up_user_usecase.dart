import '../../../user/domain/entities/user_entity.dart';
import '../repositories/i_user_repository.dart';

class SignUpUseCase {
  final IUserRepository repository;

  SignUpUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.signUpUser(userEntity);
  }
}

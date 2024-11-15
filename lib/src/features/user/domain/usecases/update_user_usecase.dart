import 'package:vivamais/src/features/user/domain/repositories/i_user_repository.dart';

import '../entities/user_entity.dart';

class UpdateUserUseCase {
  final IUserRepository repository;

  UpdateUserUseCase({required this.repository});

  Future<void> call(UserEntity user) async {
    return await repository.updateUser(user);
  }
}

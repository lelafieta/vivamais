import 'package:vivamais/src/features/user/domain/repositories/i_user_repository.dart';

import '../entities/user_entity.dart';

class GetUserByIdUseCase {
  final IUserRepository repository;

  GetUserByIdUseCase({required this.repository});

  Future<UserEntity?> call(String id) async {
    return await repository.getUserById(id);
  }
}

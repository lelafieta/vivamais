import 'dart:io';

import 'package:vivamais/src/features/user/domain/repositories/i_user_repository.dart';

import '../entities/user_entity.dart';

class CreateUserUseCase {
  final IUserRepository repository;

  CreateUserUseCase({required this.repository});

  Future<void> call(UserEntity user, {File? image}) async {
    return await repository.createUser(user, image: image);
  }
}

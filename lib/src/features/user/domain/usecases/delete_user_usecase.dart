import 'package:vivamais/src/features/user/domain/repositories/i_user_repository.dart';

class DeleteUserUseCase {
  final IUserRepository repository;

  DeleteUserUseCase({required this.repository});

  Future<void> call(String id) async {
    return await repository.deleteUser(id);
  }
}

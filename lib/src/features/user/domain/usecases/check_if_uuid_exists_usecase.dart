import 'package:vivamais/src/features/user/domain/repositories/i_user_repository.dart';

class CheckIfUuidExistsUseCase {
  final IUserRepository repository;

  CheckIfUuidExistsUseCase({required this.repository});

  Future<bool> call() async {
    return await repository.checkIfUuidExists();
  }
}

import 'package:firebase_auth/firebase_auth.dart';

import '../../../user/domain/entities/user_entity.dart';
import '../repositories/i_user_repository.dart';

class SignInWithGoogleUserUseCase {
  final IUserRepository repository;

  SignInWithGoogleUserUseCase({required this.repository});

  Future<UserCredential> call() async {
    return repository.signWithGoogle();
  }
}

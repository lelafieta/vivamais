import 'dart:io';

import '../repositories/i_user_repository.dart';

class UploadImageProfileToStorageUseCase {
  final IUserRepository repository;

  UploadImageProfileToStorageUseCase({required this.repository});

  Future<String> call(File file) {
    return repository.uploadImageProfileToStorage(file);
  }
}

import 'dart:io';

import 'package:vivamais/src/features/donation/domain/entities/request_entity.dart';
import 'package:vivamais/src/features/donation/domain/repositories/i_request_repository.dart';

class CreateRequestUsecase {
  final IRequestRepository repository;

  const CreateRequestUsecase({required this.repository});

  Future<void> call(RequestEntity request, {File? file}) async {
    return await repository.createRequest(request, file: file);
  }
}

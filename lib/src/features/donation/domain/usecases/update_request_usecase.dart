import 'package:vivamais/src/features/donation/domain/entities/request_entity.dart';
import 'package:vivamais/src/features/donation/domain/repositories/i_request_repository.dart';

class UpdateRequestUsecase {
  final IRequestRepository repository;

  const UpdateRequestUsecase({required this.repository});

  Future<void> call(RequestEntity request) async {
    return await repository.updateRequest(request);
  }
}

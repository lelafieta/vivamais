import 'package:vivamais/src/features/donation/domain/entities/request_entity.dart';
import 'package:vivamais/src/features/donation/domain/repositories/i_request_repository.dart';

class FetchReceivedRequestsUsecase {
  final IRequestRepository repository;

  const FetchReceivedRequestsUsecase({required this.repository});

  Stream<List<RequestEntity>> call() {
    return repository.fetchReceivedRequests();
  }
}

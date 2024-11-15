import 'package:vivamais/src/features/donation/domain/entities/request_entity.dart';
import 'package:vivamais/src/features/donation/domain/repositories/i_request_repository.dart';

class FetchSentRequestsUsecase {
  final IRequestRepository repository;

  const FetchSentRequestsUsecase({required this.repository});

  Stream<List<RequestEntity>> call() {
    return repository.fetchSentRequests();
  }
}

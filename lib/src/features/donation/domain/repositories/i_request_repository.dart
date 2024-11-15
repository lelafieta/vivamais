import 'dart:io';

import 'package:vivamais/src/features/donation/domain/entities/request_entity.dart';

abstract class IRequestRepository {
  Future<void> createRequest(RequestEntity request, {File? file});
  Stream<List<RequestEntity>> fetchSentRequests();
  Stream<List<RequestEntity>> fetchReceivedRequests();
  Future<void> updateRequest(RequestEntity request);
}

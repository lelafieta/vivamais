import 'dart:io';

import '../../domain/entities/request_entity.dart';

abstract class IFirebaseDatasourceRepository {
  Future<void> createRequest(RequestEntity request, {File? file});
  Stream<List<RequestEntity>> fetchSentRequests();
  Stream<List<RequestEntity>> fetchReceivedRequests();
  Future<void> updateRequest(RequestEntity request);
}

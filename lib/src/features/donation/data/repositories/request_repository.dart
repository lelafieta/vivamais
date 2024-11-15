import 'dart:io';

import 'package:vivamais/src/features/donation/data/datasources/request_datasource.dart';
import 'package:vivamais/src/features/donation/domain/entities/request_entity.dart';
import 'package:vivamais/src/features/donation/domain/repositories/i_request_repository.dart';

class RequestRespository extends IRequestRepository {
  final FirebaseRequestDatasource requestDatasource;

  RequestRespository({required this.requestDatasource});

  @override
  Future<void> createRequest(RequestEntity request, {File? file}) async {
    await requestDatasource.createRequest(request, file: file);
  }

  @override
  Stream<List<RequestEntity>> fetchReceivedRequests() {
    return requestDatasource.fetchReceivedRequests();
  }

  @override
  Stream<List<RequestEntity>> fetchSentRequests() {
    return requestDatasource.fetchSentRequests();
  }

  @override
  Future<void> updateRequest(RequestEntity request) async {
    await requestDatasource.updateRequest(request);
  }
}

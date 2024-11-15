import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vivamais/src/core/api/firebase_const.dart';
import 'package:vivamais/src/features/donation/data/datasources/i_request_datasource.dart';
import 'package:vivamais/src/features/donation/data/models/request_model.dart';
import 'package:vivamais/src/features/donation/domain/entities/request_entity.dart';

import '../../../../core/utils/app_utils.dart';

class FirebaseRequestDatasource extends IFirebaseDatasourceRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseRequestDatasource(
      {required this.auth, required this.firestore, required this.storage});

  @override
  Future<void> createRequest(RequestEntity request, {File? file}) async {
    final requestCollection = firestore.doc(FirebaseConst.requests);
    String? fileUrl;

    if (file != null) {
      try {
        final storageRef =
            storage.ref().child('user_avatars/file_${DateTime.now()}.jpg');
        final uploadTask = await storageRef.putFile(file);
        fileUrl = await uploadTask.ref.getDownloadURL();
      } catch (e) {
        AppConstants.toast("Error uploading image: $e");
        return;
      }
    }

    try {
      final newRequest = RequestModel(
        latitude: request.latitude,
        longitude: request.latitude,
        address: request.address,
        file: fileUrl,
        blood: request.blood,
        status: request.status,
        description: request.description,
        userId: auth.currentUser!.uid,
        donorId: request.donorId,
        date: request.date,
        createdAt: request.createdAt,
        updatedAt: request.updatedAt,
      ).toMap();

      await requestCollection.set(newRequest);
    } on SocketException catch (_) {
      AppConstants.toast("Verifique a internet");
    } catch (e) {
      AppConstants.toast("Ouve um erro inesperado, tenta mais tarde");
    }
  }

  @override
  Stream<List<RequestEntity>> fetchReceivedRequests() {
    throw UnimplementedError();
  }

  @override
  Stream<List<RequestEntity>> fetchSentRequests() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateRequest(RequestEntity request) {
    throw UnimplementedError();
  }
}

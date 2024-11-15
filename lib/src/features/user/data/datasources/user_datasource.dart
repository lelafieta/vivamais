import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vivamais/src/core/api/firebase_const.dart';
import 'package:vivamais/src/features/user/domain/entities/user_entity.dart';
import '../../../../core/utils/app_utils.dart';
import '../models/user_model.dart';
import 'i_user_datasource.dart';

class FirebaseUserDatasource extends IFirebaseUserDatasource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseUserDatasource(
      {required this.auth, required this.firestore, required this.storage});

  @override
  Future<bool> checkIfUuidExists() async {
    final currentUUid = auth.currentUser!.uid;
    final querySnapshot = await firestore
        .collection('user')
        .where('uid', isEqualTo: currentUUid)
        .limit(1)
        .get();

    // Se a consulta retornar pelo menos um documento, o UUID existe
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Future<void> createUser(UserEntity user, {File? image}) async {
    final userCollection = firestore.collection(FirebaseConst.profiles);
    final bloodColection = firestore.collection(FirebaseConst.blood);
    final uid = auth.currentUser!.uid;

    String? avatarUrl;

    if (image != null) {
      try {
        final storageRef = storage.ref().child('user_avatars/$uid.jpg');
        final uploadTask = await storageRef.putFile(image);
        avatarUrl = await uploadTask.ref.getDownloadURL();
      } catch (e) {
        AppConstants.toast("Error uploading image: $e");
        return;
      }
    }

    try {
      final newUser = UserModel(
        uid: uid,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        phone: user.phone,
        avatar_url: avatarUrl ?? user.avatar_url,
        password: "",
        gender: user.gender,
        blood: user.blood,
        address: user.address,
        latitude: user.latitude,
        longitude: user.longitude,
        is_donor: user.is_donor,
        isValiable: user.isValiable,
        birth: user.birth,
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
      ).toSnapshot();
      await userCollection.doc(uid).set(newUser).whenComplete(() {
        bloodColection.doc(user.blood).get().then((value) {
          final qtdUsers = value["qtd_users"] as num;
          final qtdAdd = qtdUsers + 1;
          bloodColection.doc(user.blood).update({"qtd_users": qtdAdd});
        });
      });
    } on SocketException catch (_) {
      AppConstants.toast("Verifique a internet");
    } catch (e) {
      AppConstants.toast("Ouve um erro inesperado, tenta mais tarde");
    }
  }

  @override
  Future<UserEntity?> getUserById(String uid) async {
    final snapshot =
        await firestore.collection(FirebaseConst.profiles).doc(uid).get();
    if (snapshot.exists) {
      return UserModel.fromSnapshot(snapshot);
    }
    return null;
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    // await firestore.collection('users').doc(user.uid).update(user.tosnapshot());
  }

  @override
  Future<void> deleteUser(String uid) async {
    await firestore.collection(FirebaseConst.profiles).doc(uid).delete();
  }
}

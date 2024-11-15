import 'package:firebase_auth/firebase_auth.dart';

import '../../../user/domain/entities/user_entity.dart';

import 'dart:io';

import '../../domain/repositories/i_user_repository.dart';
import '../firebase_data_sources/i_firebase_data_sources.dart';

class UserRepository implements IUserRepository {
  final IFirebaseDataSources firebaseDataSources;

  UserRepository({required this.firebaseDataSources});

  @override
  Future<void> createUser(UserEntity user) async =>
      firebaseDataSources.createUser(user);

  @override
  Future<String> getCurrentUid() async => firebaseDataSources.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      firebaseDataSources.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) =>
      firebaseDataSources.getUsers(user);
  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) =>
      firebaseDataSources.getSingleOtherUser(otherUid);

  @override
  Future<bool> isSignIn() async => firebaseDataSources.isSignIn();

  @override
  Future<void> signInUser(UserEntity user) async =>
      firebaseDataSources.signInUser(user);

  @override
  Future<void> signOut() async => firebaseDataSources.signOut();

  @override
  Future<void> signUpUser(UserEntity user) async =>
      firebaseDataSources.signUpUser(user);

  @override
  Future<void> updateUser(UserEntity user) async =>
      firebaseDataSources.updateUser(user);

  @override
  Future<void> followUnFollowUser(UserEntity user) async =>
      firebaseDataSources.followUnFollowUser(user);

  @override
  Future<String> uploadImageProfileToStorage(
    File? file,
  ) async =>
      firebaseDataSources.uploadImageProfileToStorage(file);

  @override
  Future<bool> sendOtpNumber(String code, String verificationId) async {
    return await firebaseDataSources.sendOtpNumber(code, verificationId);
  }

  @override
  Future<bool> verifyNumber(String number) async {
    return await firebaseDataSources.verifyNumber(number);
  }

  @override
  Future<UserCredential> signWithGoogle() async {
    return await firebaseDataSources.signInWithGoogle();
  }

  // @override
  // Stream<List<UserEntity>> getMyChat(String uid) =>
  //     firebaseDataSources.getMyChat(uid);
}

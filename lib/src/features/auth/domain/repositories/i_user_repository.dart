import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../user/domain/entities/user_entity.dart';

abstract class IUserRepository {
  // Credential Features
  Future<void> signInUser(UserEntity user);
  Future<UserCredential> signWithGoogle();
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();
  Future<bool> verifyNumber(String number);
  Future<bool> sendOtpNumber(String code, String verificationId);

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);

  // Cloud Storage Feature
  Future<String> uploadImageProfileToStorage(File? file);
}

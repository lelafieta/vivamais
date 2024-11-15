import 'dart:io';

import '../../domain/entities/user_entity.dart';

abstract class IFirebaseUserDatasource {
  Future<bool> checkIfUuidExists();
  Future<void> createUser(UserEntity user, {File? image});
  Future<UserEntity?> getUserById(String uid);
  Future<void> updateUser(UserEntity user);
  Future<void> deleteUser(String uid);
}

import 'dart:io';

import 'package:vivamais/src/features/user/domain/entities/user_entity.dart';

import '../../domain/repositories/i_user_repository.dart';
import '../datasources/i_user_datasource.dart';

class UserRepository extends IUserRepository {
  final IFirebaseUserDatasource userDatasource;

  UserRepository({required this.userDatasource});

  @override
  Future<bool> checkIfUuidExists() async {
    return await userDatasource.checkIfUuidExists();
  }

  @override
  Future<void> createUser(UserEntity user, {File? image}) async {
    await userDatasource.createUser(user, image: image);
  }

  @override
  Future<void> deleteUser(String uid) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity?> getUserById(String uid) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(UserEntity user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}

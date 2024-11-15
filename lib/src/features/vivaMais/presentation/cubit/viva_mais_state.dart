import 'package:vivamais/src/features/user/domain/entities/user_entity.dart';

abstract class VivaMaisState {}

class VivaMaisInitial implements VivaMaisState {}

class VivaMaisLoading implements VivaMaisState {}

class VivaMaisStarted implements VivaMaisState {
  final UserEntity currentUser;

  VivaMaisStarted({required this.currentUser});
}

class VivaMaisError implements VivaMaisState {
  final String error;

  VivaMaisError({required this.error});
}

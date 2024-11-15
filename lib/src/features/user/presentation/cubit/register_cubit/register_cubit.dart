import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/create_user_usecase.dart';
import '../../../domain/usecases/delete_user_usecase.dart';
import '../../../domain/usecases/get_user_by_id_usecase .dart';
import '../../../domain/usecases/update_user_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final CreateUserUseCase createUserUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  RegisterCubit({
    required this.createUserUseCase,
    required this.getUserByIdUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
  }) : super(UserInitial());

  Future<void> createUser(UserEntity user, {File? image}) async {
    emit(RegisterLoading());
    try {
      await createUserUseCase.call(user, image: image);
      emit(RegisterSuccess());
    } on SocketException catch (_) {
      emit(RegisterFailure(_.toString()));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  // Future<void> getUser(String uid) async {
  //   try {
  //     emit(RegisterLoading());
  //     final user = await getUserByIdUseCase.call(uid);
  //     if (user != null) {
  //       emit(UserLoaded(user));
  //     } else {
  //       emit(RegisterFailure("User not found"));
  //     }
  //   } catch (e) {
  //     emit(RegisterFailure(e.toString()));
  //   }
  // }

  Future<void> updateUser(UserEntity user) async {
    try {
      emit(RegisterLoading());
      await updateUserUseCase.call(user);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      emit(RegisterLoading());
      await deleteUserUseCase.call(uid);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}

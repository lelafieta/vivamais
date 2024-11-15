import 'dart:io';

import 'package:vivamais/src/core/error/error_handle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivamais/src/features/auth/domain/usecases/sign_in_with_google_user_usecase.dart';

import '../../../user/domain/entities/user_entity.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogleUserUseCase signInWithGoogleUserUseCase;
  AuthCubit({required this.signInWithGoogleUserUseCase}) : super(AuthInitial());

  Future<void> register(UserEntity user, File? image) async {
    emit(AuthLoading());
    // final res = await registerUserCase.call(user, image);

    // res.fold((failure) => emit(AuthError(error: ErrorHandle.handle(failure))),
    //     (uid) => emit(Authenticated(uid: uid.toString())));
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    try {
      final res = await signInWithGoogleUserUseCase.call();
      emit(AuthenticatedWithGoogle(user: res));
    } catch (e) {
      emit(AuthError(error: "error"));
    }
    // final res = await registerUserCase.call(user, image);

    // res.fold((failure) => emit(AuthError(error: ErrorHandle.handle(failure))),
    //     (uid) => emit(Authenticated(uid: uid.toString())));
  }
}

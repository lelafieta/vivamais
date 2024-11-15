import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivamais/src/features/user/domain/usecases/check_if_uuid_exists_usecase.dart';

import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final CheckIfUuidExistsUseCase checkIfUuidExistsUseCase;

  UserCubit({
    required this.checkIfUuidExistsUseCase,
  }) : super(UserInitial());

  Future<void> checkIfUuidExists() async {
    emit(UserLoading());
    try {
      final isUserExists = await checkIfUuidExistsUseCase.call();
      emit(UserSuccess(isUserExists: isUserExists));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }
}

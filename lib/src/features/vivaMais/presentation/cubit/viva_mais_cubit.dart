import 'package:flutter_bloc/flutter_bloc.dart';

import 'viva_mais_state.dart';

class VivaMaisCubit extends Cubit<VivaMaisState> {
  // final GetCurrentUserCase getCurrentUserCase;
  VivaMaisCubit() : super(VivaMaisInitial());

  // Future<void> appStart() async {
  //   emit(VivaMaisLoading());
  //   final res = await getCurrentUserCase.call();

  //   res.fold((failure) {
  //     print(failure);
  //     emit(VivaMaisError(error: ErrorHandle.handle(failure)));
  //   }, (user) => emit(VivaMaisStarted(currentUser: user!)));
  // }
}

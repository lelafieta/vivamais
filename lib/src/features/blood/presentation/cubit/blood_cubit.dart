import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivamais/src/features/blood/domain/usecases/fetch_bloods_usecase.dart';
import 'package:vivamais/src/features/blood/presentation/cubit/blood_state.dart';

class BloodCubit extends Cubit<BloodState> {
  final FetchBloodsUsecase fetchBloodsUsecase;
  BloodCubit({required this.fetchBloodsUsecase}) : super(BloodState());

  Future<void> fetchBloods() async {
    emit(BloodLoading());

    fetchBloodsUsecase.call().listen((bloods) {
      emit(BloodLoaded(bloods: bloods));
    });
  }
}

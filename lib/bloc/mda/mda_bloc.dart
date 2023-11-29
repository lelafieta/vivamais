import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maxalert/bloc/mda/mda_state.dart';
import 'package:maxalert/data/repositories/mda_repository.dart';
import 'package:maxalert/data/services/api_error.dart';
import 'package:maxalert/models/mda_model.dart';

part 'mda_event.dart';

class MdaBloc extends Bloc<MdaEvent, MdaState> {
  MdaRepository mdaRepository;

  final secureStorage = FlutterSecureStorage();
  List<MdaModel> mdas = [];

  MdaBloc({required this.mdaRepository}) : super(MdaInitialState()) {
    on<MdaLoadingEvent>((event, emit) async {
      try {
        final response = await mdaRepository.fatchMda();
        mdas = response;

        emit(MdaSuccessState(mdas: mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        } else
          // print(e);
          emit(MdaFailureState(e.toString()));
      }
    });

    on<MdaDetailLoadingEvent>((event, emit) async {
      emit(MdaInitialState());
      try {
        final response = await mdaRepository.fatchStatus(event.mdaId);
        mdas = response;

        emit(MdaDetailSuccessState(status: mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        } else
          emit(MdaFailureState(e.toString()));
      }
    });

    on<MdaReloadEvent>((event, emit) async {
      emit(MdaInitialState());

      try {
        final response = await mdaRepository
            .searchFilter(event.mdas, event.indexSearch!, query: event.query!);
        mdas = response;

        emit(MdaSuccessState(mdas: mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        } else
          emit(MdaFailureState(e.toString()));
      }
    });

    on<MdaOnlineEvent>((event, emit) {
      emit(MdaLoadingState());
      try {
        final response = mdaRepository.searchFilter(event.mdas, 1);
        List<MdaModel> _mdas = response;

        emit(MdaSuccessState(mdas: _mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(MdaFailureState(e.toString()));
      }
    });

    on<MdaAnomaliaEvent>((event, emit) {
      emit(MdaLoadingState());
      try {
        final response = mdaRepository.searchFilter(event.mdas, 3);
        List<MdaModel> _mdas = response;

        emit(MdaSuccessState(mdas: _mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(MdaFailureState(e.toString()));
      }
    });

    on<MdaOfflineEvent>((event, emit) {
      emit(MdaLoadingState());
      try {
        final response = mdaRepository.searchFilter(event.mdas, 2);
        List<MdaModel> _mdas = response;

        emit(MdaSuccessState(mdas: _mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(MdaFailureState(e.toString()));
      }
    });

    // on<MdaOnlineEvent>((event, emit) {
    //   emit(MdaLoadingState());
    //   try {
    //     final response = mdaRepository.searchFilter(mdas, 1);
    //     List<MdaModel> _mdas = response;

    //     emit(MdaSuccessState(mdas: _mdas));
    //   } catch (e) {
    //     if (e is ApiError) {
    //       emit(MdaFailureState(e.message.toString(), code: e.statusCode));
    //     }
    //     emit(MdaFailureState(e.toString()));
    //   }
    // });

    /////
    ///
    on<MdaComPapelEvent>((event, emit) {
      emit(MdaLoadingState());
      try {
        final response = mdaRepository.searchFilter(event.mdas, 4);
        List<MdaModel> _mdas = response;

        emit(MdaSuccessState(mdas: _mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(MdaFailureState(e.toString()));
      }
    });
    on<MdaPoucoPapelEvent>((event, emit) {
      emit(MdaLoadingState());
      try {
        final response = mdaRepository.searchFilter(event.mdas, 5);
        List<MdaModel> _mdas = response;

        emit(MdaSuccessState(mdas: _mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(MdaFailureState(e.toString()));
      }
    });

    on<MdaSemPapelEvent>((event, emit) {
      emit(MdaLoadingState());
      try {
        final response = mdaRepository.searchFilter(event.mdas, 6);
        List<MdaModel> _mdas = response;

        emit(MdaSuccessState(mdas: _mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(MdaFailureState(e.toString()));
      }
    });

    on<MdaAcima3MilhoesEvent>((event, emit) {
      emit(MdaLoadingState());
      try {
        final response = mdaRepository.searchFilter(event.mdas, 7);
        List<MdaModel> _mdas = response;

        emit(MdaSuccessState(mdas: _mdas));
      } catch (e) {
        print(e);
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(MdaFailureState(e.toString()));
      }
    });

    on<MdaAbaixo3MilhoesEvent>((event, emit) {
      emit(MdaLoadingState());
      try {
        final response = mdaRepository.searchFilter(event.mdas, 8);
        List<MdaModel> _mdas = response;

        emit(MdaSuccessState(mdas: _mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(MdaFailureState(e.toString()));
      }
    });

    on<MdaSearchEvent>((event, emit) {
      emit(MdaLoadingState());
      try {
        final response = mdaRepository.searchFilter(
            event.mdas, event.indexSearch!,
            query: event.query.toString());
        List<MdaModel> _mdas = response;

        emit(MdaSuccessState(mdas: _mdas));
      } catch (e) {
        if (e is ApiError) {
          emit(MdaFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(MdaFailureState(e.toString()));
      }
    });
  }
}

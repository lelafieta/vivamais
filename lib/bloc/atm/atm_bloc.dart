import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maxalert/bloc/atm/atm_state.dart';
import 'package:maxalert/data/repositories/atm_repository.dart';
import 'package:maxalert/data/services/api_error.dart';
import 'package:maxalert/data/services/api_service.dart';
import 'package:maxalert/models/atm_data_model.dart';
import 'package:maxalert/models/atm_with_status.dart';

part 'atm_event.dart';

class AtmBloc extends Bloc<AtmEvent, AtmState> {
  final AtmRepository atmRepository;

  final secureStorage = FlutterSecureStorage();
  List<AtmWithStatus> atms = [];
  final authService = AuthService();

  AtmBloc({required this.atmRepository}) : super(AtmInitialState()) {
    on<AtmLoadingEvent>((event, emit) async {
      try {
        final response = await atmRepository.fatchAtm();
        atms = response;

        emit(AtmSuccessState(atms: atms));
      } catch (e) {
        if (e is ApiError) {
          emit(AtmFailureState(e.message.toString(), code: e.statusCode));
        } else
          emit(AtmFailureState(e.toString()));
      }
    });

    on<AtmReloadDetailsEvent>((event, emit) async {
      emit(AtmInitialState());
      try {
        final response = await atmRepository.fatchAtm();
        atms = response;

        emit(AtmSuccessState(atms: atms));
      } catch (e) {
        print(e);
        if (e is ApiError) {
          emit(AtmFailureState(e.message.toString(), code: e.statusCode));
        } else
          emit(AtmFailureState(e.toString()));
      }
    });

    on<AtmReloadEvent>((event, emit) async {
      emit(AtmInitialState());
      try {
        final response = await atmRepository.fatchAtmReload(
          event.atms,
          event.indexSearch,
          event.type,
          query: event.query!,
        );
        atms = response;

        emit(AtmSuccessState(atms: atms));
      } catch (e) {
        print(e);
        if (e is ApiError) {
          emit(AtmFailureState(e.message.toString(), code: e.statusCode));
        } else
          emit(AtmFailureState(e.toString()));
      }
    });

    on<AtmDetailLoadingEvent>((event, emit) async {
      emit(AtmInitialState());
      try {
        final response = await atmRepository.getAtmDetail(event.atmId);
        Dados atm = response;

        emit(AtmDetailSuccessState(atm: atm));
      } catch (e) {
        print(e);
        if (e is ApiError) {
          emit(AtmFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(AtmFailureState(e.toString()));
      }
    });

    on<AtmLoadListEvent>((event, emit) async {
      print("VV");
      emit(AtmLoadingState());
      try {
        final response = atmRepository.searchFilter(event.atms, 0, event.type);
        List<AtmWithStatus> _atms = response;

        emit(AtmSuccessState(atms: _atms));
      } catch (e) {
        print(e);
        if (e is ApiError) {
          emit(AtmFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(AtmFailureState(e.toString()));
      }
    });

    on<AtmFilterEvent>((event, emit) {
      emit(AtmLoadingState());
      try {
        final response = atmRepository.searchFilter(
            event.atms, event.indexSearch, event.type);
        List<AtmWithStatus> _atms = response;
        print("VV14 ${response.length}");
        emit(AtmSuccessState(atms: _atms));
      } catch (e) {
        print(e);
        if (e is ApiError) {
          emit(AtmFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(AtmFailureState(e.toString()));
      }
    });

    on<AtmSearchEvent>((event, emit) {
      print("VV2");
      emit(AtmLoadingState());
      try {
        final response = atmRepository.searchFilter(
            atms, event.indexSearch!, event.type,
            query: event.query.toString());
        List<AtmWithStatus> _atms = response;

        emit(AtmSuccessState(atms: _atms));
      } catch (e) {
        print(e);
        if (e is ApiError) {
          emit(AtmFailureState(e.message.toString(), code: e.statusCode));
        }
        emit(AtmFailureState(e.toString()));
      }
    });
  }
}

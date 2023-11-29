import 'package:maxalert/models/atm_data_model.dart';
import 'package:maxalert/models/atm_with_status.dart';

abstract class AtmState {
  const AtmState();
}

class AtmInitialState extends AtmState {}

class AtmLoadingState extends AtmState {}

class AtmSuccessState extends AtmState {
  List<AtmWithStatus> atms;

  AtmSuccessState({required this.atms});
}

class AtmSearchSuccessState extends AtmState {
  List<AtmWithStatus> atms;

  AtmSearchSuccessState({required this.atms});
}

class AtmDetailSuccessState extends AtmState {
  Dados atm;

  AtmDetailSuccessState({required this.atm});
}

class AtmFailureState extends AtmState {
  String error;
  final int? code;

  AtmFailureState(this.error, {this.code});
}

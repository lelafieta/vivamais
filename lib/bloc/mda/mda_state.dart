import 'package:maxalert/models/mda_model.dart';

abstract class MdaState {
  const MdaState();
}

class MdaInitialState extends MdaState {}

class MdaLoadingState extends MdaState {}

class MdaSuccessState extends MdaState {
  List<MdaModel> mdas;

  MdaSuccessState({required this.mdas});
}

class MdaFailureState extends MdaState {
  String error;
  final int? code;

  MdaFailureState(this.error, {this.code});
}

class MdaDetailSuccessState extends MdaState {
  List<MdaModel> status;

  MdaDetailSuccessState({required this.status});
}

class MdaNotFoundState extends MdaState {
  final String error;

  MdaNotFoundState({required this.error});
}

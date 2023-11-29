part of 'atm_bloc.dart';

abstract class AtmEvent {
  const AtmEvent();
}

class AtmLoadingEvent extends AtmEvent {}

class AtmReloadEvent extends AtmEvent {
  List<AtmWithStatus> atms;
  int type;
  String? query;
  int indexSearch;
  AtmReloadEvent(
      {required this.atms,
      required this.type,
      this.query,
      required this.indexSearch});
}

class AtmReloadDetailsEvent extends AtmEvent {}

class AtmDetailLoadingEvent extends AtmEvent {
  final String atmId;

  AtmDetailLoadingEvent({required this.atmId});
}

class AtmLoadListEvent extends AtmEvent {
  List<AtmWithStatus> atms;
  final int type;

  AtmLoadListEvent(this.type, {required this.atms});
}

class AtmFilterEvent extends AtmEvent {
  List<AtmWithStatus> atms;
  int type;
  int indexSearch;
  AtmFilterEvent(
      {required this.atms, required this.type, required this.indexSearch});
}

class AtmSearchEvent extends AtmEvent {
  List<AtmWithStatus> atms;
  String? query;
  int? indexSearch;
  int type;

  AtmSearchEvent(
      {required this.atms, this.query, this.indexSearch, required this.type});
}

class AtmSearchFilterEvent extends AtmEvent {
  List<AtmWithStatus> atms;
  String? query;
  int? indexSearch;

  AtmSearchFilterEvent({required this.atms, this.query, this.indexSearch});
}

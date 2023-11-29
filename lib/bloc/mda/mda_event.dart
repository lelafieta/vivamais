part of 'mda_bloc.dart';

abstract class MdaEvent {
  const MdaEvent();
}

class MdaLoadingEvent extends MdaEvent {}

class MdaDetailLoadingEvent extends MdaEvent {
  final String mdaId;

  MdaDetailLoadingEvent({required this.mdaId});
}

class MdaReloadEvent extends MdaEvent {
  List<MdaModel> mdas;
  String? query;
  int? indexSearch;
  int? type;

  MdaReloadEvent({required this.mdas, this.query, this.indexSearch, this.type});
}

class MdaComPapelEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaComPapelEvent({required this.mdas});
}

class MdaSemPapelEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaSemPapelEvent({required this.mdas});
}

class MdaPoucoPapelEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaPoucoPapelEvent({required this.mdas});
}

class MdaComDinheiroEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaComDinheiroEvent({required this.mdas});
}

class MdaSemDinheiroEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaSemDinheiroEvent({required this.mdas});
}

class MdaOnlineEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaOnlineEvent({required this.mdas});
}

class MdaOfflineEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaOfflineEvent({required this.mdas});
}

class MdaAnomaliaEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaAnomaliaEvent({required this.mdas});
}

class MdaAcima3MilhoesEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaAcima3MilhoesEvent({required this.mdas});
}

class MdaAbaixo3MilhoesEvent extends MdaEvent {
  List<MdaModel> mdas;

  MdaAbaixo3MilhoesEvent({required this.mdas});
}

class MdaSearchEvent extends MdaEvent {
  List<MdaModel> mdas;
  String? query;
  int? indexSearch;

  MdaSearchEvent({required this.mdas, this.query, this.indexSearch});
}

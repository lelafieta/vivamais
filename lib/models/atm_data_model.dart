class Dados {
  final List<Alarme>? alarmes;
  final List<Transacao>? transacoes;

  Dados({required this.alarmes, required this.transacoes});

  factory Dados.fromJson(Map<String, dynamic> json) {
    final List<dynamic> alarmesJson = json['alarmes'];
    final List<dynamic> transacoesJson = json['transacoes'];

    List<Alarme> alarmes = alarmesJson.map((e) => Alarme.fromJson(e)).toList();
    List<Transacao> transacoes =
        transacoesJson.map((e) => Transacao.fromJson(e)).toList();

    return Dados(alarmes: alarmes, transacoes: transacoes);
  }
}

class Alarme {
  int? statusId;
  String? statusAnomPeriod;
  String? statusAnomTxId;
  String? statusAnomDataOcorrencia;
  String? statusAnomType;
  String? statusAnomCode;
  String? statusAnomDescription;
  String? statusAnomHardwareCode;
  String? statusAnomErrorText;
  String? statusMontanteDisponivel;
  int? montanteLimpo;
  String? statusLastTransaction;
  int? statusPeriodNumberReceived;
  String? statusTransactionNumberReceived;
  String? statusPeriodNumberSent;
  String? statusTransactionNumberSent;
  String? statusAtmStatus;
  String? currentDatetime;
  int? atmCode;
  int? infoSource;
  int? isTratado;

  Alarme({
    this.statusId,
    this.statusAnomPeriod,
    this.statusAnomTxId,
    this.statusAnomDataOcorrencia,
    this.statusAnomType,
    this.statusAnomCode,
    this.statusAnomDescription,
    this.statusAnomHardwareCode,
    this.statusAnomErrorText,
    this.statusMontanteDisponivel,
    this.montanteLimpo,
    this.statusLastTransaction,
    this.statusPeriodNumberReceived,
    this.statusTransactionNumberReceived,
    this.statusPeriodNumberSent,
    this.statusTransactionNumberSent,
    this.statusAtmStatus,
    this.currentDatetime,
    this.atmCode,
    this.infoSource,
    this.isTratado,
  });

  factory Alarme.fromJson(Map<String, dynamic> json) {
    return Alarme(
      statusId: json['status_id'],
      statusAnomPeriod: json['status_anom_period'],
      statusAnomTxId: json['status_anom_tx_id'],
      statusAnomDataOcorrencia: json['status_anom_dataocorrencia'],
      statusAnomType: json['status_anom_type'],
      statusAnomCode: json['status_anom_code'],
      statusAnomDescription: json['status_anom_description'],
      statusAnomHardwareCode: json['status_anom_hardware_code'],
      statusAnomErrorText: json['status_anom_error_text'],
      statusMontanteDisponivel: json['status_montante_disponivel'],
      montanteLimpo: json['montante_limpo'],
      statusLastTransaction: json['status_last_Transaction'],
      statusPeriodNumberReceived: json['status_period_number_recieved'],
      statusTransactionNumberReceived:
          json['status_transaction_number_recieved'],
      statusPeriodNumberSent: json['status_period_number_sent'],
      statusTransactionNumberSent: json['status_transcation_number_sent'],
      statusAtmStatus: json['status_atmstatus'],
      currentDatetime: json['current_datatime'],
      atmCode: json['atm_code'],
      infoSource: json['info_source'],
      isTratado: json['is_tratado'],
    );
  }
}

class Transacao {
  String? statusMontanteDisponivel;
  String? currentDatetime;

  Transacao({
    this.statusMontanteDisponivel,
    this.currentDatetime,
  });

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      statusMontanteDisponivel: json['status_montante_disponivel'],
      currentDatetime: json['current_datatime'],
    );
  }
}

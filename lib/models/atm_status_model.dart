class AtmStatusModel {
  int id;
  int? atm_id;
  int? isHorasOffline;
  int? isHoraSleeping;
  int? isHorasOnline;
  String? lastTransactionData;
  String? estado;
  int? estadoPapel;
  String? errorDescriptionPapel;
  String? errorTextPapel;
  String? bgColorPapel;
  int? estadoCartao;
  String? errorDescriptionCartao;
  String? errorTextCartao;
  int? estadoDinheiro;
  int? valorActual;
  String? errorTextDinheiro;
  String? bgColorDinheiro;
  String? descriptionDinheiro;
  String? infoEmis;
  int? estadoTecnico;
  String? errorTextTecnico;
  String? bgColorTecnico;
  String? iconeTecnico;
  String? descriptionTecnico;
  String? createdAt;
  String? updatedAt;
  String? rsv1;
  String? rsv2;
  String? rsv3;
  String? rsv4;
  String? rsv5;
  String? rsv6;
  String? rsv7;
  String? rsv8;
  String? rsv9;
  String? rsv10;
  String? bgColorCartao;
  String? currentDatetime;

  AtmStatusModel({
    required this.id,
    this.atm_id,
    this.isHorasOffline,
    this.isHoraSleeping,
    this.isHorasOnline,
    this.lastTransactionData,
    this.estado,
    this.estadoPapel,
    this.errorDescriptionPapel,
    this.errorTextPapel,
    this.bgColorPapel,
    this.estadoCartao,
    this.errorDescriptionCartao,
    this.errorTextCartao,
    this.estadoDinheiro,
    this.valorActual,
    this.errorTextDinheiro,
    this.bgColorDinheiro,
    this.descriptionDinheiro,
    this.infoEmis,
    this.estadoTecnico,
    this.errorTextTecnico,
    this.bgColorTecnico,
    this.iconeTecnico,
    this.descriptionTecnico,
    this.createdAt,
    this.updatedAt,
    this.rsv1,
    this.rsv2,
    this.rsv3,
    this.rsv4,
    this.rsv5,
    this.rsv6,
    this.rsv7,
    this.rsv8,
    this.rsv9,
    this.rsv10,
    this.bgColorCartao,
    this.currentDatetime,
  });

  factory AtmStatusModel.fromJson(Map<String, dynamic> json) {
    return AtmStatusModel(
      id: json['id'],
      atm_id: json['atm_id'],
      isHorasOffline: json['is_Horas_ofline'],
      isHoraSleeping: json['is_Hora_slepping'],
      isHorasOnline: json['is_Horas_online'],
      lastTransactionData: json['last_transaction_data'],
      estado: json['estado'],
      estadoPapel: json['estado_papel'],
      errorDescriptionPapel: json['error_description_papel'],
      errorTextPapel: json['error_text_papel'],
      bgColorPapel: json['bg_color_papel'],
      estadoCartao: json['estado_cartao'],
      errorDescriptionCartao: json['error_description_cartao'],
      errorTextCartao: json['error_text_cartao'],
      estadoDinheiro: json['estado_dinheiro'],
      valorActual: json['valor_actual'],
      errorTextDinheiro: json['error_text_dinheiro'],
      bgColorDinheiro: json['bg_color_dinheiro'],
      descriptionDinheiro: json['description_dinheiro'],
      infoEmis: json['info_emis'],
      estadoTecnico: json['estado_tecnico'],
      errorTextTecnico: json['error_text_tecnico'],
      bgColorTecnico: json['bg_color_tecnico'],
      iconeTecnico: json['icone_tecnico'],
      descriptionTecnico: json['description_tecnico'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      rsv1: json['rsv1'],
      rsv2: json['rsv2'],
      rsv3: json['rsv3'],
      rsv4: json['rsv4'],
      rsv5: json['rsv5'],
      rsv6: json['rsv6'],
      rsv7: json['rsv7'],
      rsv8: json['rsv8'],
      rsv9: json['rsv9'],
      rsv10: json['rsv10'],
      bgColorCartao: json['bg_color_cartao'],
      currentDatetime: json['current_datatime'],
    );
  }
}

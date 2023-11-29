class MdaModel {
  final String? nome;
  final int? id;
  final String? mdaConta;
  final String? mdaFacturaProforma;
  final String? mdaDataInstalacao;
  final String? mdaDataActivacao;
  final String? mdaObsContacto;
  final String? denominacao;
  final String? codAgencia;
  final String? idMda;
  final String? ccb;
  final String? createdAt;
  final String? modelo;
  final String? provedor;
  final String? direccaoRegional;
  final String? zona;
  final String? responsavel;
  final String? municipio;
  final String? provincia;
  final String? obs;
  final String? isActivade;
  final String? updatedAt;
  final double? lat;
  final double? lng;
  final String? mdaStatus;
  final String? mdaName;
  final String? mdaIp;
  final String? mdaCode;
  final String? mdaCassetStatus;
  final String? mdaImpressoraRecepcaoStatus;
  final String? mdaMontanteActual;
  final String? mdaTotalNotas;
  final String? mdaPapel;
  final String? mdaFrontBottomDoor;
  final String? mdaFrontTopDoor;
  final String? mdaPortaCofre;
  final String? mdaBarcodeReaderStatus;
  final String? currentDatetime;
  final int? estado;

  MdaModel({
    this.nome,
    this.id,
    this.mdaConta,
    this.mdaFacturaProforma,
    this.mdaDataInstalacao,
    this.mdaDataActivacao,
    this.mdaObsContacto,
    this.denominacao,
    this.codAgencia,
    this.idMda,
    this.ccb,
    this.createdAt,
    this.modelo,
    this.provedor,
    this.direccaoRegional,
    this.zona,
    this.responsavel,
    this.municipio,
    this.provincia,
    this.obs,
    this.isActivade,
    this.updatedAt,
    this.lat,
    this.lng,
    this.mdaStatus,
    this.mdaName,
    this.mdaIp,
    this.mdaCode,
    this.mdaCassetStatus,
    this.mdaImpressoraRecepcaoStatus,
    this.mdaMontanteActual,
    this.mdaTotalNotas,
    this.mdaPapel,
    this.mdaFrontBottomDoor,
    this.mdaFrontTopDoor,
    this.mdaPortaCofre,
    this.mdaBarcodeReaderStatus,
    this.currentDatetime,
    this.estado,
  });

  factory MdaModel.fromJson(Map<String, dynamic> json) {
    return MdaModel(
      nome: json['nome'],
      id: json['id'],
      mdaConta: json['mda_conta'],
      mdaFacturaProforma: json['mda_factura_proforma'],
      mdaDataInstalacao: json['mda_data_instalacao'],
      mdaDataActivacao: json['mda_data_activacao'],
      mdaObsContacto: json['mda_obs_contacto'],
      denominacao: json['denominacao'],
      codAgencia: json['cod_agencia'],
      idMda: json['id_mda'],
      ccb: json['ccb'],
      createdAt: json['created_at'],
      modelo: json['modelo'],
      provedor: json['provedor'],
      direccaoRegional: json['direccao_regional'],
      zona: json['zona'],
      responsavel: json['responsavel'],
      municipio: json['municipio'],
      provincia: json['provincia'],
      obs: json['obs'],
      isActivade: json['is_activade'],
      updatedAt: json['updated_at'],
      lat: json['lat'],
      lng: json['lng'],
      mdaStatus: json['mda_status'],
      mdaName: json['mda_name'],
      mdaIp: json['mda_ip'],
      mdaCode: json['mda_code'],
      mdaCassetStatus: json['mda_casset_status'],
      mdaImpressoraRecepcaoStatus: json['mda_impressora_recepcao_status'],
      mdaMontanteActual: json['mda_montante_actual'],
      mdaTotalNotas: json['mda_total_notas'],
      mdaPapel: json['mda_papel'],
      mdaFrontBottomDoor: json['mda_front_bottom_door'],
      mdaFrontTopDoor: json['mda_front_top_door'],
      mdaPortaCofre: json['mda_porta_cofre'],
      mdaBarcodeReaderStatus: json['mda_barcode_reader_status'],
      currentDatetime: json['current_datatime'],
      estado: json['estado'],
    );
  }
}

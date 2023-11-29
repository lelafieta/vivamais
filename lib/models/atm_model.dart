import 'package:maxalert/models/atm_config_model.dart';

class AtmModel {
  int? atmSigitCode;
  int? atmSigitCodeAgencia;
  String? atmSimgreLastalivedata;
  String? denominacao;
  String? ccb;
  String? provedor;
  String? atmSigitProvinciaTexto;
  String? atmSigitLocalizacao;
  int? tipoLocal;
  String? lat;
  String? long;

  AtmConfigModel? config;

  AtmModel({
    this.atmSigitCode,
    this.atmSigitCodeAgencia,
    this.atmSimgreLastalivedata,
    this.denominacao,
    this.ccb,
    this.provedor,
    this.atmSigitProvinciaTexto,
    this.atmSigitLocalizacao,
    this.tipoLocal,
    this.config,
    this.lat,
    this.long,
  });

  factory AtmModel.fromJson(Map<String, dynamic> json) {
    return AtmModel(
      atmSigitCode: json['atm_sigit_code'],
      atmSigitCodeAgencia: json['atm_sigit_code_agencia'],
      atmSimgreLastalivedata: json['atm_simgre_lastalivedata'],
      denominacao: json['denominacao'],
      ccb: json['ccb'],
      provedor: json['provedor'],
      atmSigitProvinciaTexto: json['atm_sigit_provincia_texto'],
      atmSigitLocalizacao: json['atm_sigit_localizacao'],
      tipoLocal: json['tipo_local'],
      config: json['config'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}

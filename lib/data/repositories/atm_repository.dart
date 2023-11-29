import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:maxalert/data/services/PinSSL.dart';
import 'package:maxalert/data/services/api_error.dart';
import 'package:maxalert/data/services/my_encryption.dart';
import 'package:maxalert/data/services/my_pinning_logic.dart';
import 'package:maxalert/models/atm_data_model.dart';
import 'package:maxalert/models/atm_data_status_model.dart';
import 'package:maxalert/models/atm_with_status.dart';
import 'package:maxalert/utils/app_constants.dart';
import 'package:maxalert/utils/app_utils.dart';

class AtmRepository {
  final _endPoint = 'api/atm/all';
  final _endPointDetail = 'api/atm/status/historico';

  List<AtmWithStatus> atmStatusList = [];
  List<String> allowedSHAFingerprints = [AppConstants.FINGERPRINT];

  final secureStorage = FlutterSecureStorage();
  Future<List<AtmWithStatus>> fatchAtm() async {
    final client = await getSSLPinningClient();
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPoint}');
    String? token = await secureStorage.read(key: "access_token");
    String? identfyed = await secureStorage.read(key: "identfyed");

    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPoint}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(
          _url,
          body: {
            "identfyed": identfyed,
            'plataforma': AppUtils.getPlatform().toString(),
          },
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ).timeout(Duration(seconds: 50));

        if (response.statusCode == 401) {
          throw ApiError(
              statusCode: 401,
              message: "Utilizador sem permissão, porfavor faça login");
        }

        final dataModel = AtmDataModel.fromJson(jsonDecode(response.body));
        atmStatusList = dataModel.getStatusWithMatchingAtmCodes();

        return atmStatusList;
      } on TimeoutException {
        throw "Utilizador sem permissão, porfavor faça login";
      } on SocketException {
        throw "Verifica sua internet ou servidor";
      } catch (e) {
        throw e;
      }
    }
    throw "Erro do servidor";
  }

  Future<List<AtmWithStatus>> fatchAtmReload(
      List<AtmWithStatus> atms, int type, int atmType,
      {String query = ""}) async {
    final client = await getSSLPinningClient();
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPoint}');
    String? token = await secureStorage.read(key: "access_token");
    String? identfyed = await secureStorage.read(key: "identfyed");
    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPoint}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(
          _url,
          body: {
            "identfyed": identfyed,
            'plataforma': AppUtils.getPlatform().toString(),
          },
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ).timeout(Duration(seconds: 50));

        if (response.statusCode == 401) {
          throw ApiError(
              statusCode: 401,
              message: "Utilizador sem permissão, porfavor faça login");
        }

        final dataModel = AtmDataModel.fromJson(jsonDecode(response.body));
        atmStatusList = dataModel.getStatusWithMatchingAtmCodes();

        return searchFilter(atmStatusList, type, atmType, query: query);
      } on TimeoutException {
        throw "Utilizador sem permissão, porfavor faça login";
      } on SocketException {
        throw "Verifica sua internet ou servidor";
      } catch (e) {
        print(e);
        throw e;
      }
    }
    throw "Erro do servidor";
  }

  Future<Dados> getAtmDetail(String id) async {
    final client = await getSSLPinningClient();
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPointDetail}');
    String? token = await secureStorage.read(key: "access_token");
    String? identfyed = await secureStorage.read(key: "identfyed");

    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPointDetail}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(
          _url,
          body: {
            "codigo": id.toString(),
            "identfyed": identfyed,
            'plataforma': AppUtils.getPlatform().toString(),
          },
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ).timeout(Duration(seconds: 20));

        if (response.statusCode == 401) {
          throw "Utilizador sem permissão, porfavor faça login";
        }
        var data = jsonDecode(response.body)['dados'];

        Dados dados = Dados.fromJson(data);

        return dados;
      } on TimeoutException {
        throw "Verifica sua conexão de internet";
      } catch (e) {
        throw "Erro, verifique sua internet ou problema no servidor";
      }
    }
    throw "Erro do servidor";
  }

  List<AtmWithStatus> searchFilter(
      List<AtmWithStatus> atms, int type, int atmType,
      {String query = ""}) {
    List<AtmWithStatus> list = [];

    if (type == 1) {
      atms.forEach((element) {
        if (atmType == 0) {
          if (element.status.estadoDinheiro == 1) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        } else if (element.status.estadoDinheiro == 1 &&
            atmType == element.atm.tipoLocal) {
          if (query != null) {
            final s = element.atm.atmSigitCode.toString().toLowerCase();
            final input = query.toLowerCase();

            if (s.contains(input) ||
                element.atm.atmSigitCodeAgencia
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.denominacao
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.atmSigitCode
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.ccb.toString().toLowerCase().contains(input) ||
                element.atm.atmSigitProvinciaTexto
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.isHorasOffline
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.currentDatetime
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.valorActual
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.estadoPapel
                    .toString()
                    .toLowerCase()
                    .contains(input)) {
              list.add(element);
            }
          } else {
            list.add(element);
          }
        }
      });
    } else if (type == 2) {
      atms.forEach((element) {
        if (atmType == 0) {
          if (element.status.estadoDinheiro != 1 &&
              element.status.estadoDinheiro != 2) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        } else if (element.status.estadoDinheiro != 1 &&
            element.status.estadoDinheiro != 2 &&
            atmType == element.atm.tipoLocal) {
          if (query != null) {
            final s = element.atm.atmSigitCode.toString().toLowerCase();
            final input = query.toLowerCase();

            if (s.contains(input) ||
                element.atm.atmSigitCodeAgencia
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.denominacao
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.atmSigitCode
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.ccb.toString().toLowerCase().contains(input) ||
                element.atm.atmSigitProvinciaTexto
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.isHorasOffline
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.currentDatetime
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.valorActual
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.estadoPapel
                    .toString()
                    .toLowerCase()
                    .contains(input)) {
              list.add(element);
            }
          } else {
            list.add(element);
          }
        }
      });
    } else if (type == 3) {
      atms.forEach((element) {
        if (atmType == 0) {
          if (element.status.estadoDinheiro == 2) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        } else if (element.status.estadoDinheiro == 2 &&
            atmType == element.atm.tipoLocal) {
          if (query != null) {
            final s = element.atm.atmSigitCode.toString().toLowerCase();
            final input = query.toLowerCase();

            if (s.contains(input) ||
                element.atm.atmSigitCodeAgencia
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.denominacao
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.atmSigitCode
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.ccb.toString().toLowerCase().contains(input) ||
                element.atm.atmSigitProvinciaTexto
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.isHorasOffline
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.currentDatetime
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.valorActual
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.estadoPapel
                    .toString()
                    .toLowerCase()
                    .contains(input)) {
              list.add(element);
            }
          } else {
            list.add(element);
          }
        }
      });
    } else if (type == 4) {
      atms.forEach((element) {
        if (atmType == 0) {
          if (element.status.estadoCartao != 1) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        } else if (element.status.estadoCartao != 1) {
          if (query != null) {
            final s = element.atm.atmSigitCode.toString().toLowerCase();
            final input = query.toLowerCase();

            if (s.contains(input) ||
                element.atm.atmSigitCodeAgencia
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.denominacao
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.atmSigitCode
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.ccb.toString().toLowerCase().contains(input) ||
                element.atm.atmSigitProvinciaTexto
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.isHorasOffline
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.currentDatetime
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.valorActual
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.estadoPapel
                    .toString()
                    .toLowerCase()
                    .contains(input)) {
              list.add(element);
            }
          } else {
            list.add(element);
          }
        }
      });
    } else if (type == 5) {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (element.status.estado != "S") {
              if (element.status.isHorasOffline! > 0) {
              } else if (element.status.isHorasOnline! >= 1) {
                if (query != null) {
                  final s = element.atm.atmSigitCode.toString().toLowerCase();
                  final input = query.toLowerCase();

                  if (s.contains(input) ||
                      element.atm.atmSigitCodeAgencia
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.denominacao
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.atmSigitCode
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.ccb
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.atmSigitProvinciaTexto
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.isHorasOffline
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.currentDatetime
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.valorActual
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.estadoPapel
                          .toString()
                          .toLowerCase()
                          .contains(input)) {
                    list.add(element);
                  }
                } else {
                  list.add(element);
                }
              } else if (element.status.isHoraSleeping! > 0) {
                if (query != null) {
                  final s = element.atm.atmSigitCode.toString().toLowerCase();
                  final input = query.toLowerCase();

                  if (s.contains(input) ||
                      element.atm.atmSigitCodeAgencia
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.denominacao
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.atmSigitCode
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.ccb
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.atmSigitProvinciaTexto
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.isHorasOffline
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.currentDatetime
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.valorActual
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.estadoPapel
                          .toString()
                          .toLowerCase()
                          .contains(input)) {
                    list.add(element);
                  }
                } else {
                  list.add(element);
                }
              } else if (element.status.isHorasOnline! * 60 > 20) {
                if (query != null) {
                  final s = element.atm.atmSigitCode.toString().toLowerCase();
                  final input = query.toLowerCase();

                  if (s.contains(input) ||
                      element.atm.atmSigitCodeAgencia
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.denominacao
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.atmSigitCode
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.ccb
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.atmSigitProvinciaTexto
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.isHorasOffline
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.currentDatetime
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.valorActual
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.estadoPapel
                          .toString()
                          .toLowerCase()
                          .contains(input)) {
                    list.add(element);
                  }
                } else {
                  list.add(element);
                }
              } else {
                if (query != null) {
                  final s = element.atm.atmSigitCode.toString().toLowerCase();
                  final input = query.toLowerCase();

                  if (s.contains(input) ||
                      element.atm.atmSigitCodeAgencia
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.denominacao
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.atmSigitCode
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.ccb
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.atm.atmSigitProvinciaTexto
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.isHorasOffline
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.currentDatetime
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.valorActual
                          .toString()
                          .toLowerCase()
                          .contains(input) ||
                      element.status.estadoPapel
                          .toString()
                          .toLowerCase()
                          .contains(input)) {
                    list.add(element);
                  }
                } else {
                  list.add(element);
                }
              }
            }
          } else if (element.status.estado != "S") {
            if (element.status.isHorasOffline! > 0 &&
                element.atm.tipoLocal == atmType) {
            } else if (element.status.isHorasOnline! >= 1) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            } else if (element.status.isHoraSleeping! > 0) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            } else if (element.status.isHorasOnline! * 60 > 20) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            } else {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          }
        },
      );
    } else if (type == 7) {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (element.status.valorActual! < 3000000) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } else if (element.status.valorActual! < 3000000 &&
              element.atm.tipoLocal == atmType) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 8) {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (element.status.isHorasOffline! > 0) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } else if (element.status.isHorasOffline! > 0 &&
              element.atm.tipoLocal == atmType) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 9) {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (element.status.estadoPapel == 1) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } else if (element.status.estadoPapel == 1 &&
              element.atm.tipoLocal == atmType) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 10) {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (element.status.estadoPapel != 1 &&
                element.status.estadoPapel != 2) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } else if (element.status.estadoPapel != 1 &&
              element.status.estadoPapel != 2 &&
              element.atm.tipoLocal == atmType) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 11) {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (element.status.estadoPapel == 2) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } else if (element.status.estadoPapel == 2 &&
              element.atm.tipoLocal == atmType) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 12) {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (element.atm.tipoLocal == 3) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } else if (element.atm.tipoLocal == 3) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 13) {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (element.atm.tipoLocal == 1) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } else if (element.atm.tipoLocal == 1 && element.atm.tipoLocal == 0) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 14) {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (element.atm.tipoLocal == 2) {
              if (query != null) {
                final s = element.atm.atmSigitCode.toString().toLowerCase();
                final input = query.toLowerCase();

                if (s.contains(input) ||
                    element.atm.atmSigitCodeAgencia
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.atmSigitCode
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.atm.ccb.toString().toLowerCase().contains(input) ||
                    element.atm.atmSigitProvinciaTexto
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.isHorasOffline
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.currentDatetime
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.valorActual
                        .toString()
                        .toLowerCase()
                        .contains(input) ||
                    element.status.estadoPapel
                        .toString()
                        .toLowerCase()
                        .contains(input)) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } else if (element.atm.tipoLocal == 2 &&
              element.atm.tipoLocal == atmType) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else {
      atms.forEach(
        (element) {
          if (atmType == 0) {
            if (query != null) {
              final s = element.atm.atmSigitCode.toString().toLowerCase();
              final input = query.toLowerCase();

              if (s.contains(input) ||
                  element.atm.atmSigitCodeAgencia
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.atmSigitCode
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.atm.ccb.toString().toLowerCase().contains(input) ||
                  element.atm.atmSigitProvinciaTexto
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.isHorasOffline
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.currentDatetime
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.valorActual
                      .toString()
                      .toLowerCase()
                      .contains(input) ||
                  element.status.estadoPapel
                      .toString()
                      .toLowerCase()
                      .contains(input)) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          } else if (query != null && element.atm.tipoLocal == atmType) {
            final s = element.atm.atmSigitCode.toString().toLowerCase();
            final input = query.toLowerCase();

            if (s.contains(input) ||
                element.atm.atmSigitCodeAgencia
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.denominacao
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.atmSigitCode
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.atm.ccb.toString().toLowerCase().contains(input) ||
                element.atm.atmSigitProvinciaTexto
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.isHorasOffline
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.currentDatetime
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.valorActual
                    .toString()
                    .toLowerCase()
                    .contains(input) ||
                element.status.estadoPapel
                    .toString()
                    .toLowerCase()
                    .contains(input)) {
              list.add(element);
            }
          } else {
            if (element.atm.tipoLocal == atmType) {
              list.add(element);
            } else if (element.atm.tipoLocal == atmType) {
              list.add(element);
            }
          }
        },
      );
    }

    return list;
  }

  AtmWithStatus getAtmByCode(int atmSigitCode, List<AtmWithStatus> atms) {
    AtmWithStatus? atm = null;
    atms.forEach((element) {
      if (element.atm.atmSigitCode == atmSigitCode) {
        atm = element;
      }
    });
    return atm!;
  }

  List<AtmWithStatus> search(String query, List<AtmWithStatus> atms, int type) {
    List<AtmWithStatus> searchResults = [];

    searchResults = atms.where((element) {
      final s = element.atm.atmSigitLocalizacao.toString().toLowerCase();
      final input = query.toLowerCase();

      return s.contains(input);
    }).toList();

    return searchResults;
  }
}

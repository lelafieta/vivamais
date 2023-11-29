import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:maxalert/data/services/PinSSL.dart';
import 'package:maxalert/data/services/api_error.dart';
import 'package:maxalert/data/services/my_encryption.dart';
import 'package:maxalert/data/services/my_pinning_logic.dart';
import 'package:maxalert/models/mda_model.dart';
import 'package:maxalert/utils/app_constants.dart';
import 'package:maxalert/utils/app_utils.dart';

class MdaRepository {
  final _endPoint = 'api/mda/all';
  final _endPointStatus = 'api/mda/status';

  List<MdaModel> mdaList = [];
  List<String> allowedSHAFingerprints = [AppConstants.FINGERPRINT];

  final secureStorage = FlutterSecureStorage();

  Future<List<MdaModel>> fatchMda() async {
    final client = await getSSLPinningClient();
    String? identfyed = await secureStorage.read(key: "identfyed");
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPoint}');
    String? token = await secureStorage.read(key: "access_token");

    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPoint}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(
          _url,
          body: {
            'identfyed': identfyed,
            'plataforma': AppUtils.getPlatform().toString(),
          },
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ).timeout(Duration(seconds: 10));

        if (response.statusCode == 401) {
          throw ApiError(
              statusCode: 401,
              message: "Utilizador sem permissão, porfavor faça login");
        } else if (response.statusCode == 467) {
          throw ApiError(statusCode: 467, message: "Sem MDAs");
        }
        var data = jsonDecode(response.body)['mdas'] as List<dynamic>;

        mdaList = data.map((mda) {
          return MdaModel.fromJson(mda);
        }).toList();

        return mdaList;
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

  Future<List<MdaModel>> fatchMdaReload(List<MdaModel> mdas, int type,
      {String query = ""}) async {
    final client = await getSSLPinningClient();
    String? identfyed = await secureStorage.read(key: "identfyed");
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPoint}');
    String? token = await secureStorage.read(key: "access_token");
    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPoint}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(
          _url,
          body: {
            'identfyed': identfyed,
            'plataforma': AppUtils.getPlatform().toString(),
          },
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ).timeout(Duration(seconds: 10));

        if (response.statusCode == 401) {
          throw ApiError(
              statusCode: 401,
              message: "Utilizador sem permissão, porfavor faça login");
        } else if (response.statusCode == 467) {
          throw ApiError(statusCode: 467, message: "Sem MDAs");
        }
        var data = jsonDecode(response.body)['mdas'] as List<dynamic>;

        mdaList = data.map((mda) {
          return MdaModel.fromJson(mda);
        }).toList();

        return searchFilter(mdaList, type, query: query);
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

  Future<List<MdaModel>> fatchStatus(String codigo) async {
    final client = await getSSLPinningClient();
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPointStatus}');
    String? token = await secureStorage.read(key: "access_token");
    String? identfyed = await secureStorage.read(key: "identfyed");

    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPointStatus}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(
          _url,
          body: {"codigo": codigo, "identfyed": identfyed},
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ).timeout(Duration(seconds: 10));

        if (response.statusCode == 401) {
          throw "Utilizador sem permição, porfavor faça login";
        }
        if (response.statusCode == 467) {
          throw "Sem MDAs";
        }
        var data = jsonDecode(response.body)['status'] as List<dynamic>;

        mdaList = data.map((mda) {
          return MdaModel.fromJson(mda);
        }).toList();

        return mdaList;
      } on TimeoutException {
        throw "Verifica sua internet";
      } catch (e) {
        throw e;
      }
    }
    throw "Erro de servidor";
  }

  List<MdaModel> searchFilter(List<MdaModel> mdas, int type,
      {String query = ""}) {
    //loadAtmStatusList();
    List<MdaModel> list = [];

    if (type == 1) {
      mdas.forEach(
        (element) {
          if (element.mdaStatus == "success_state") {
            if (query != null) {
              if (element.ccb
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.mdaCode
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase())) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 2) {
      mdas.forEach((element) {
        if (element.mdaStatus == "warning_state") {
          if (query != null) {
            if (element.ccb
                    .toString()
                    .toLowerCase()
                    .contains(query.toString().toLowerCase()) ||
                element.mdaCode
                    .toString()
                    .toLowerCase()
                    .contains(query.toString().toLowerCase()) ||
                element.denominacao
                    .toString()
                    .toLowerCase()
                    .contains(query.toString().toLowerCase())) {
              list.add(element);
            }
          } else {
            list.add(element);
          }
        }
      });
    } else if (type == 3) {
      mdas.forEach(
        (element) {
          if (element.mdaStatus != "success_state" &&
              element.mdaStatus != "warning_state") {
            if (query != null) {
              if (element.ccb
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.mdaCode
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase())) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 4) {
      mdas.forEach(
        (element) {
          if (element.mdaPapel == "PAPER_FULL") {
            if (query != null) {
              if (element.ccb
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.mdaCode
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase())) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 5) {
      mdas.forEach(
        (element) {
          if (element.mdaPapel == "PAPER_LOW") {
            if (query != null) {
              if (element.ccb
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.mdaCode
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase())) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 6) {
      mdas.forEach(
        (element) {
          if (element.mdaPapel == "PAPER_OUT") {
            if (query != null) {
              if (element.ccb
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.mdaCode
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase()) ||
                  element.denominacao
                      .toString()
                      .toLowerCase()
                      .contains(query.toString().toLowerCase())) {
                list.add(element);
              }
            } else {
              list.add(element);
            }
          }
        },
      );
    } else if (type == 7) {
      mdas.forEach(
        (element) {
          try {
            if (num.parse(element.mdaMontanteActual.toString()) >= 20000000) {
              if (query != null) {
                if (element.ccb
                        .toString()
                        .toLowerCase()
                        .contains(query.toString().toLowerCase()) ||
                    element.mdaCode
                        .toString()
                        .toLowerCase()
                        .contains(query.toString().toLowerCase()) ||
                    element.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(query.toString().toLowerCase())) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } catch (e) {
            print(e);
          }
        },
      );
    } else if (type == 8) {
      mdas.forEach(
        (element) {
          try {
            if (num.parse(element.mdaMontanteActual.toString()) < 3000000) {
              if (query != null) {
                if (element.ccb
                        .toString()
                        .toLowerCase()
                        .contains(query.toString().toLowerCase()) ||
                    element.mdaCode
                        .toString()
                        .toLowerCase()
                        .contains(query.toString().toLowerCase()) ||
                    element.denominacao
                        .toString()
                        .toLowerCase()
                        .contains(query.toString().toLowerCase())) {
                  list.add(element);
                }
              } else {
                list.add(element);
              }
            }
          } catch (e) {
            print(e);
          }
        },
      );
    } else {
      mdas.forEach(
        (element) {
          if (query != null) {
            if (element.ccb
                    .toString()
                    .toLowerCase()
                    .contains(query.toString().toLowerCase()) ||
                element.mdaCode
                    .toString()
                    .toLowerCase()
                    .contains(query.toString().toLowerCase()) ||
                element.denominacao
                    .toString()
                    .toLowerCase()
                    .contains(query.toString().toLowerCase())) {
              list.add(element);
            }
          } else {
            list.add(element);
          }
        },
      );
    }

    return list;
  }
}

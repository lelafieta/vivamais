import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maxalert/data/services/PinSSL.dart';

import 'package:maxalert/data/services/api_error.dart';
import 'package:maxalert/data/services/my_pinning_logic.dart';
import 'package:maxalert/utils/app_constants.dart';
import 'package:maxalert/utils/app_utils.dart';

class AuthService {
  final _endPoint = 'api/auth/login';
  final _endPointCode = 'api/auth/verification/code';
  final _endPointLogout = 'api/auth/logout';
  final _endPointResetCode = 'api/auth/resetCode';
  final _endPointUser = 'api/auth/user';

  final secureStorage = FlutterSecureStorage();
  List<String> allowedSHAFingerprints = [AppConstants.FINGERPRINT];

  Future<Object?> authenticate(
      String username, String password, String phoneCode) async {
    final client = await getSSLPinningClient();
    final _url = Uri.parse('${AppConstants.BASE_URL}${_endPoint}');

    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPoint}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(
          _url,
          body: {
            'email': username,
            'password': password,
            'phoneCode': phoneCode,
            'plataforma': AppUtils.getPlatform().toString(),
          },
          headers: {"Accept": "application/json"},
        );

        if (response.statusCode == 200) {
          final userData = json.decode(response.body);

          await secureStorage.write(
              key: "identfyed", value: userData['identfyed'].toString());

          return await secureStorage.read(key: "identfyed");
        } else if (response.statusCode == 463) {
          final data = json.decode(response.body);

          return ApiError(statusCode: 463, message: data['alert'].toString());
        }
      } catch (e) {
        print("ERROR");
        throw e;
      }

      return null;
    } else {}
  }

  Future saveUser() async {
    final client = await getSSLPinningClient();
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPointUser}');

    String? token = await secureStorage.read(key: "access_token");
    String? identfyed = await secureStorage.read(key: "identfyed");

    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPointUser}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(
          _url,
          body: {
            'identfyed': identfyed,
            'plataforma': AppUtils.getPlatform(),
          },
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        );

        if (response.statusCode == 200) {
          await secureStorage.write(
            key: "user",
            value:
                response.body.toString().substring(1, response.body.length - 1),
          );
        }
      } catch (e) {
        throw e;
      }
    }

    return null;
  }

  Future<Object?> validate_otp(String token, String code) async {
    final client = await getSSLPinningClient();
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPointCode}');

    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPointCode}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(_url, body: {
          'identfyed': token,
          'code': code,
          'plataforma': AppUtils.getPlatform().toString(),
        }, headers: {
          "Accept": "application/json"
        }).timeout(Duration(seconds: 20));

        if (response.statusCode == 200) {
          final userData = json.decode(response.body);

          secureStorage.write(
              key: 'access_token', value: userData['access_token']);
          secureStorage.write(key: 'token_type', value: userData['token_type']);
          secureStorage.write(
              key: 'expires_in', value: userData['expires_in'].toString());

          final expiration =
              DateTime.now().add(Duration(hours: 1)).toIso8601String();

          await secureStorage.write(key: 'expiration', value: expiration);

          await saveUser();
          return userData['access_token'].toString();
        } else if (response.statusCode == 463) {
          final data = json.decode(response.body);
          return ApiError(statusCode: 463, message: data['alert'].toString());
        } else if (response.statusCode == 462) {
          final data = json.decode(response.body);
          return ApiError(statusCode: 462, message: data['error'].toString());
        } else if (response.statusCode == 461) {
          final data = json.decode(response.body);
          return ApiError(statusCode: 462, message: data['error'].toString());
        }
      } on TimeoutException {
        throw "Tempo de requisição terminado por favor tenta novamente";
      } catch (e) {
        throw e;
      }
    }

    return null;
  }

  Future<bool> reset_code(String identfyed, String phoneCode) async {
    final client = await getSSLPinningClient();
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPointResetCode}');

    if (await checkSSL('${AppConstants.BASE_URL}${_endPointResetCode}',
        allowedSHAFingerprints)) {
      try {
        await client.post(_url, body: {
          'identfyed': identfyed,
          'phoneCode': phoneCode,
          'plataforma': AppUtils.getPlatform().toString(),
        }, headers: {
          "Accept": "application/json"
        }).timeout(Duration(seconds: 20));

        return true;
      } catch (e) {
        throw e;
      }
    }
    return false;
  }

  Future<bool> logout() async {
    final client = await getSSLPinningClient();
    var _url = Uri.parse('${AppConstants.BASE_URL}${_endPointLogout}');
    String? identfyed = await secureStorage.read(key: "identfyed");

    if (await checkSSL(
        '${AppConstants.BASE_URL}${_endPointLogout}', allowedSHAFingerprints)) {
      try {
        final response = await client.post(
          _url,
          body: {
            'identfyed': identfyed,
            'plataforma': AppUtils.getPlatform().toString(),
          },
          headers: {
            "Accept": "application/json",
            "Authorization":
                "Bearer ${secureStorage.read(key: "access_token")}",
          },
        ).timeout(Duration(seconds: 20));

        if (response.statusCode == 200) {
          await secureStorage.delete(key: "identfyed");
          await secureStorage.delete(key: "access_token");
          await secureStorage.delete(key: "token_type");
          await secureStorage.delete(key: "expires_in");
          return true;
        }
      } catch (e) {
        throw e;
      }
    }

    return false;
  }
}

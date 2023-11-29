import 'package:bloc/bloc.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maxalert/bloc/auth/auth_state.dart';
import 'package:maxalert/data/services/api_error.dart';
import 'package:maxalert/data/services/api_service.dart';
import 'package:maxalert/data/services/my_encryption.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:root/root.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  final secureStorage = FlutterSecureStorage();

  AuthBloc({required this.authService}) : super(AppStartState()) {
    on<AuthCheckToken>((event, emit) async {
      emit(AuthLoading());

      try {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String appName = packageInfo.appName;
        String packageName = packageInfo.packageName;
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;

        final newVersion = NewVersionPlus(
          androidId: 'com.afrizona.maxalerts_app',
          androidPlayStoreCountry: "pt_PT",
        );

        String? token;
        final status = await newVersion.getVersionStatus();
        String localVersion = status!.localVersion;
        String storeVersion = status.storeVersion;

        token = await secureStorage.read(key: 'access_token');

        //await MyEncryptionDecription.retrieveDecryptedData('access_token');

        final expiration = await secureStorage.read(key: 'expiration');
        // MyEncryptionDecription.retrieveDecryptedData('expiration');
        // secureStorage.read(key: 'expiration');
        // MyEncryptionDecription.storeEncryptedData("name", "LINGARD");
        bool? result = await Root.isRooted();

        if (result! == true) {
          emit(AuthCheckRootDevice(true));
        } else {
          if (localVersion != storeVersion) {
            emit(AuthCheckVersion());
          } else {
            if (token != null && expiration != null) {
              final expirationTime = DateTime.parse(expiration);

              if (DateTime.now().isBefore(expirationTime)) {
                emit(AuthSuccess(
                    secureStorage.read(key: 'access_token').toString()));
              } else {
                emit(AuthInitial());
              }
            } else {
              emit(AuthInitial());
            }
          }
        }
      } catch (e) {
        emit(AuthFailure("Erro", 500));
      }
    });

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final response = await authService.authenticate(
            event.username, event.password, event.phoneCode);

        if (response != null) {
          if (response is ApiError) {
            emit(
                AuthFailure(response.message.toString(), response.statusCode!));
          } else {
            emit(AuthSuccessToken(response.toString()));
          }
        } else {
          emit(AuthFailure('E-mail ou password incorreta', 422));
        }
      } catch (e) {
        print(e);
        emit(AuthFailure('Erro no login verifique sua internet', 500));
      }
    });

    on<AuthCheckCode>(
      (event, emit) async {
        emit(AuthLoading());

        try {
          final response =
              await authService.validate_otp(event.identfyed, event.code);

          if (response != null) {
            if (response is ApiError) {
              emit(AuthFailure(
                  response.message.toString(), response.statusCode!));
            } else {
              emit(AuthSuccessToken(response.toString()));
            }
          } else {
            emit(AuthFailure('Verifica a internet', 500));
          }
        } catch (e) {
          print(e);
          emit(AuthFailure(
              'Erro na verificação do código, verifique sua internet', 500));
        }
      },
    );

    on<UserLoggedOut>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          final response = await authService.logout();

          if (response) {
            emit(AuthLogout());
          } else {
            emit(AuthFailure('Ouve um erro ao sair', 400));
          }
        } catch (e) {
          print(e);
          emit(AuthFailure('Erro no login verifique sua internet', 500));
        }
      },
    );

    on<AuthResetCodeEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          final response =
              await authService.reset_code(event.identfyed, event.phoneCode);

          if (response) {
            // await MyEncryptionDecription.storeEncryptedData(
            //     'identfyed', event.identfyed);
            secureStorage.write(key: 'identfyed', value: event.identfyed);

            emit(AuthSuccessResetCodeState());
          } else {
            emit(AuthFailure('Ouve um erro no reenvio do code', 400));
          }
        } catch (e) {
          emit(AuthFailure('Erro no login verifique sua internet', 500));
        }
      },
    );
  }
}

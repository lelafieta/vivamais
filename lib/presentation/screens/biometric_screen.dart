import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/bloc/auth/auth_bloc.dart';
import 'package:maxalert/bloc/biometric/biometric_bloc.dart';
import 'package:maxalert/bloc/biometric/biometric_event.dart';
import 'package:maxalert/bloc/biometric/biometric_state.dart';
import 'package:maxalert/data/services/api_service.dart';
import 'package:maxalert/presentation/screens/splash_screen.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_images.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  ValueNotifier<bool> callBiometric = ValueNotifier<bool>(false);

  ValueNotifier<int> segundosRestantes = ValueNotifier<int>(0);

  late BiometricBloc bioBloc;
  final AuthService authService = AuthService();

  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(authService: authService);
    authBloc.add(AuthCheckToken());
    _getLocation();
  }

  void _getLocation() async {
    var status = await Geolocator.requestPermission();
    // var position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);

    // setState(() {
    //   _currentLocation = LatLng(position.latitude, position.longitude);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BiometricBloc>(context);
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: BlocListener<BiometricBloc, BiometricState>(
          listener: (context, state) {
            print("STATE $state");
            if (state is BiometricSuccessState) {
              Get.to(() => SplashScreen());
            }
          },
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(AppImages.SPLASH)),
                ),
              ),
              Positioned(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.MAIN_COLOR.withOpacity(.5),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 8,
                        sigmaY:
                            10), // Ajuste o valor de sigmaX e sigmaY para controlar a intensidade do desfoque
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(top: 100, bottom: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.lock,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            FittedBox(
                              child: Text(
                                "Desbloquea para acessar",
                                style: GoogleFonts.rajdhani(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 60),
                          child: InkWell(
                            onTap: () async {
                              //await _authenticateWithBiometrics();
                              //authBloc
                              bloc.add(BiometricStartingEvent());
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Clica para autenticar com biometria",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rajdhani(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.fingerprint,
                                    size: 45,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

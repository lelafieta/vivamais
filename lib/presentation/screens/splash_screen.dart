import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/bloc/auth/auth_bloc.dart';
import 'package:maxalert/bloc/auth/auth_state.dart';
import 'package:maxalert/bloc/theme/theme_bloc.dart';
import 'package:maxalert/bloc/theme/theme_event.dart';
import 'package:maxalert/bloc/theme/theme_state.dart';
import 'package:maxalert/data/services/api_service.dart';
import 'package:maxalert/presentation/main_screen.dart';
import 'package:maxalert/presentation/screens/error_conection_screen.dart';
import 'package:maxalert/presentation/screens/login_screen.dart';
import 'package:maxalert/presentation/screens/otp_screen.dart';
import 'package:maxalert/presentation/screens/root_screen.dart';
import 'package:maxalert/presentation/screens/update_screen.dart';
import 'package:maxalert/utils/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();

  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(authService: authService);
    authBloc.add(AuthCheckToken());
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is AuthSuccess) {
                Get.off(() => MainScreen());
              } else if (state is AuthInitial) {
                Get.off(() => LoginScreen());
              } else if (state is AuthLoading) {
                //EasyLoading.show(status: 'loading...');
              } else if (state is AuthCheckVersion) {
                Get.off(() => UpgradeScreen());
              } else if (state is AuthFailure) {
                Get.off(ErrorConectionScreen());
              } else if (state is AuthCheckRootDevice) {
                Get.off(() => RootScreen());
              }
            },
            builder: (context, state) {
              if (state is AuthFailure) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        AppImages.MAIN_LOGO_WHITE,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Verifique a internet.",
                          style: GoogleFonts.rajdhani(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          authBloc.add(AuthCheckToken());
                        },
                        child: Text(
                          "RECARREGAR",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is AuthLoading) {
                return Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (themeBloc.state == ToggleDarkTheme)
                            ? AssetImage(
                                AppImages.MAIN_LOGO_WHITE,
                              )
                            : AssetImage(
                                AppImages.MAIN_LOGO,
                              ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              }
              return Center(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (themeBloc.state == ToggleDarkTheme)
                          ? AssetImage(
                              AppImages.MAIN_LOGO_WHITE,
                            )
                          : AssetImage(
                              AppImages.MAIN_LOGO,
                            ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

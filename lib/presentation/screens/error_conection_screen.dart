import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/bloc/auth/auth_bloc.dart';
import 'package:maxalert/bloc/auth/auth_state.dart';
import 'package:maxalert/bloc/theme/theme_bloc.dart';
import 'package:maxalert/bloc/theme/theme_event.dart';
import 'package:maxalert/data/services/api_service.dart';
import 'package:maxalert/presentation/main_screen.dart';
import 'package:maxalert/presentation/screens/login_screen.dart';
import 'package:maxalert/presentation/screens/otp_screen.dart';
import 'package:maxalert/presentation/screens/splash_screen.dart';
import 'package:maxalert/presentation/screens/update_screen.dart';
import 'package:maxalert/utils/app_images.dart';

class ErrorConectionScreen extends StatefulWidget {
  const ErrorConectionScreen({super.key});
  @override
  State<ErrorConectionScreen> createState() => _ErrorConectionScreenState();
}

class _ErrorConectionScreenState extends State<ErrorConectionScreen> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Center(
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
                      Get.off(() => SplashScreen());
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
            ),
          ),
        ),
      ),
    );
  }
}

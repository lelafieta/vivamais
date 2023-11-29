import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/bloc/auth/auth_bloc.dart';
import 'package:maxalert/bloc/auth/auth_state.dart';
import 'package:maxalert/bloc/theme/theme_bloc.dart';
import 'package:maxalert/bloc/theme/theme_state.dart';
import 'package:maxalert/data/services/api_service.dart';
import 'package:maxalert/presentation/main_screen.dart';
import 'package:maxalert/presentation/screens/otp_screen.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';
import 'package:maxalert/utils/app_utils.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget with OTPStrategy {
  @override
  State<LoginScreen> createState() => _LoginScreenState();

  @override
  Future<String> listenForCode() {
    return Future.delayed(
      const Duration(seconds: 4),
      () => 'Your code is 54321',
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  String? phoneSmsAppSignature;

  @override
  void initState() {
    super.initState();
    valueSignature();
  }

  void valueSignature() async {
    phoneSmsAppSignature = await _listenOtp();

    OTPInteractor _otpInteractor = OTPInteractor();
    _otpInteractor.getAppSignature().then((value) {
      phoneSmsAppSignature = value;
    });
    OTPTextEditController controller = OTPTextEditController(
      codeLength: 5,
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{5})');
          print(code);
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          // SampleStrategy(),
        ],
      );
  }

  void _abrirContatos() async {
    String numeroTelefone = '+244922547030';
    final Uri _url = Uri.parse("tel:$numeroTelefone");

    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Não foi possível abrir $_url';
    }
  }

  @override
  void dispose() {
    _usernameController.clear();
    _passwordController.clear();
    super.dispose();
  }

  void _abrirPoliticas() async {
    final Uri _url = Uri.parse("https://grs.max-alerts.com/static/_policy");

    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Não foi possível abrir $_url';
    }
  }

  void _abrirWhatsApp() async {
    String numeroTelefone = '+244922547030';
    String mensagem = 'Saudações suporte técnico, tenho desafios no Maxalerts';
    String url =
        'https://wa.me/$numeroTelefone?text=${Uri.encodeFull(mensagem)}';

    final Uri _url = Uri.parse(url);
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  void _abrirTeams() async {
    String mensagem = 'Saudações suporte técnico, tenho desafios no Maxalerts';
    const url =
        "https://teams.microsoft.com/l/chat/0/0?users=suporte@afrizona.co.ao&message=Saudações suporte técnico, tenho desafios no Maxalerts";

    final Uri _url = Uri.parse(url);
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  void _abrirOutlook() async {
    String mensagem = 'Saudações suporte técnico, tenho desafios no Maxalerts';

    final String email = 'suporte@afrizona.co.ao';
    final String subject = 'Desafios no Maxalerts';
    final String body = mensagem;

    final Uri mailUrl = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );
    if (await canLaunchUrl(mailUrl)) {
      await launchUrl(mailUrl);
    } else {
      throw 'Não foi possível abrir $mailUrl';
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    FocusNode textFieldFocusNode = FocusNode();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  EasyLoading.dismiss();
                  Get.to(() => MainScreen());
                } else if (state is AuthSuccessToken) {
                  EasyLoading.dismiss();
                  Get.to(() => OTPScreen(state.token));
                } else if (state is AuthLoading) {
                  EasyLoading.show(
                    status: 'Processando...',
                    maskType: EasyLoadingMaskType.black,
                  );
                } else if (state is AuthFailure) {
                  EasyLoading.dismiss();
                  if (state.code == 500) {
                    EasyLoading.showError('${state.error}');
                    // AnimatedSnackBar.material(
                    //   '${state.error}',
                    //   type: AnimatedSnackBarType.error,
                    //   mobilePositionSettings: const MobilePositionSettings(
                    //     topOnAppearance: 50,
                    //   ),
                    // ).show(context);
                  } else {
                    EasyLoading.showError(
                      '${state.error}',
                      duration: Duration(seconds: 5),
                    );
                    // AnimatedSnackBar.material(
                    //   '${state.error}',
                    //   type: AnimatedSnackBarType.warning,
                    //   mobilePositionSettings: const MobilePositionSettings(
                    //     topOnAppearance: 50,
                    //   ),
                    // ).show(context);
                  }
                }
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 250,
                        height: 150,
                        decoration: BoxDecoration(
                          image: (themeBloc.state is ThemeDarkState)
                              ? DecorationImage(
                                  image: AssetImage(
                                    AppImages.MAIN_LOGO_WHITE,
                                  ),
                                  fit: BoxFit.contain,
                                )
                              : DecorationImage(
                                  image: AssetImage(
                                    AppImages.MAIN_LOGO,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "ENTRAR",
                            style: GoogleFonts.rajdhani(
                              fontSize: 35,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null) {
                              return 'Password inválida';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.GRAY_COLOR,
                            hintText: "E-mail",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ), // Set your border radius here
                              borderSide: BorderSide.none,
                              // Hide the border
                            ),
                            hintStyle: TextStyle(
                              color: AppColors.CONTENT_COLOR,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 5) {
                              return 'Porfavor entre com uma password válida.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.GRAY_COLOR,
                            hintText: "Senha",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ), // Set your border radius here
                              borderSide: BorderSide.none,
                              // Hide the border
                            ),
                            hintStyle: TextStyle(
                              color: AppColors.CONTENT_COLOR,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double
                            .infinity, // Define a largura do Container para preencher a tela
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final username = _usernameController.text;
                              final password = _passwordController.text;
                              authBloc.add(AuthLoginRequested(
                                phoneCode: phoneSmsAppSignature!,
                                username: username,
                                password: password,
                              ));
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.MAIN_COLOR,
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                            ),
                          ),
                          child: Text(
                            'ENTRAR',
                            style: GoogleFonts.rajdhani(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async => _abrirPoliticas(),
                            child: Text(
                              "Políticas de privacidade",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.8),
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.8),
                                fontWeight: FontWeight.w700,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      'Para mais informações ou desafios entre em contacto',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  _abrirTeams();
                                },
                                child: SvgPicture.asset(
                                  AppIcons.TEAMS,
                                  width: 30,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  _abrirOutlook();
                                },
                                child: SvgPicture.asset(
                                  AppIcons.OUTLOOK,
                                  width: 30,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  _abrirWhatsApp();
                                },
                                child: SvgPicture.asset(
                                  AppIcons.WHATSAPP,
                                  width: 30,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  _abrirContatos();
                                },
                                child: SvgPicture.asset(
                                  AppIcons.PHONE_CALL,
                                  width: 30,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Todos direitos reservados, Afrizona © ${DateTime.now().year}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(.8),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _listenOtp() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      //return await SmsAutoFill().getAppSignature;
    }
    return "";
  }

  Future _openTeamsChat() async {
    var user = 'suporte@afrizona.co.ao';
    var url = '$user';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final webUrl = ' https://teams.microsoft.com/l/chat/0/0?users=$user';
      if (await canLaunch(webUrl)) {
        await launch(webUrl);
      } else {
        throw 'Não foi possível abrir o Teams.';
      }
    }
  }
}

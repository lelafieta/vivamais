import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/bloc/auth/auth_bloc.dart';
import 'package:maxalert/bloc/auth/auth_state.dart';
import 'package:maxalert/data/services/api_service.dart';
import 'package:maxalert/presentation/main_screen.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:otp_text_field/otp_text_field.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPScreen extends StatefulWidget with OTPStrategy {
  final String token;

  const OTPScreen(this.token);

  @override
  State<OTPScreen> createState() => _OTPScreenState();

  @override
  Future<String> listenForCode() {
    return Future.delayed(
      const Duration(seconds: 4),
      () => 'Your code is 54321',
    );
  }
}

class _OTPScreenState extends State<OTPScreen> {
  final AuthService authService = AuthService();
  FocusNode textFieldFocusNode = FocusNode();
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  ValueNotifier<int> _secondsRemaining = ValueNotifier<int>(30);

  String _otpValue = '';
  bool _timerRunning = true;
  String? phoneSmsAppSignature;
  //OTPTextEditController controller = OTPTextEditController(codeLength: 6);

  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  void valueSignaturee() async {
    phoneSmsAppSignature = await _listenOtp();
  }

  @override
  void initState() {
    super.initState();
    _initInteractor();
    controller = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) {
        final authBloc = BlocProvider.of<AuthBloc>(context);
        authBloc.add(
          AuthCheckCode(
            identfyed: widget.token,
            code: code.toString(),
          ),
        );
        //print('Your Application receive code - $code');
      },
      otpInteractor: _otpInteractor,
      autoStop: false,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          //SampleStrategy(),
        ],
      );
    _startTimer();
  }

  Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();
  }

  void valueSignature() async {
    //phoneSmsAppSignature = await _listenOtp();

    final authBloc = BlocProvider.of<AuthBloc>(context);

    OTPInteractor _otpInteractor = OTPInteractor();

    _otpInteractor.getAppSignature();
    String _code = "";

    controller = OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) {
        if (code.length == 6) {
          _code = code;
          authBloc.add(
            AuthCheckCode(
              identfyed: widget.token,
              code: code.toString(),
            ),
          );
        }
      },
      onTimeOutException: () {
        controller.startListenUserConsent;
      },
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          final authBloc = BlocProvider.of<AuthBloc>(context);
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          // SampleStrategy(),
        ],
      );
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);

    Timer.periodic(oneSecond, (timer) {
      if (_secondsRemaining.value == 1) {
        setState(() {
          _timerRunning = false;
          timer.cancel();
        });
      } else {
        _secondsRemaining.value--;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _secondsRemaining.value = 0;
  }

  OtpFieldController _controller = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    FocusScopeNode textFieldFocusNode = FocusScopeNode();

    return Container(
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Get.off(() => MainScreen());
                } else if (state is AuthLoading) {
                  EasyLoading.show(
                    status: 'Processando...',
                    maskType: EasyLoadingMaskType.black,
                  );
                } else if (state is AuthSuccessResetCodeState) {
                  EasyLoading.dismiss();
                }

                if (state is AuthSuccessToken) {
                  Get.off(() => MainScreen());
                } else if (state is AuthFailure) {
                  EasyLoading.dismiss();

                  if (state.code == 500) {
                    EasyLoading.showError(
                      '${state.error}',
                      duration: Duration(seconds: 5),
                    );

                    // AnimatedSnackBar.material(

                    //   '${state.error}',

                    //   type: AnimatedSnackBarType.error,

                    //   mobilePositionSettings: const MobilePositionSettings(

                    //     topOnAppearance: 50,

                    //   ),

                    // ).show(context);
                  } else {
                    // AnimatedSnackBar.material(

                    //   '${state.error}',

                    //   type: AnimatedSnackBarType.warning,

                    //   mobilePositionSettings: const MobilePositionSettings(

                    //     topOnAppearance: 50,

                    //   ),

                    // ).show(context);

                    EasyLoading.showError('${state.error}');
                  }
                }
              },
              child: SingleChildScrollView(
                child: OtpPinField(
                    key: _otpPinFieldController,
                    //autoFillEnable: true,

                    ///for Ios it is not needed as the SMS autofill is provided by default, but not for Android, that's where this key is useful.

                    textInputAction: TextInputAction.done,

                    ///in case you want to change the action of keyboard

                    /// to clear the Otp pin Controller

                    onSubmit: (text) {
                      // authBloc.add(
                      //   AuthCheckCode(
                      //     identfyed: widget.token,
                      //     code: _c,
                      //   ),
                      // );
                    },
                    onChange: (text) {
                      if (text.length == 6) {
                        authBloc.add(
                          AuthCheckCode(
                            identfyed: widget.token,
                            code: text.toString(),
                          ),
                        );
                      }
                    },
                    onCodeChanged: (code) {},

                    /// to decorate your Otp_Pin_Field

                    otpPinFieldStyle: OtpPinFieldStyle(
                      /// border color for inactive/unfocused Otp_Pin_Field

                      defaultFieldBorderColor: Colors.black12,

                      /// border color for active/focused Otp_Pin_Field

                      activeFieldBorderColor: Colors.black12,

                      /// Background Color for inactive/unfocused Otp_Pin_Field

                      defaultFieldBackgroundColor: Colors.black12,

                      /// Background Color for active/focused Otp_Pin_Field

                      activeFieldBackgroundColor: Colors.black12,

                      /// Background Color for filled field pin box

                      filledFieldBackgroundColor: Colors.black12,

                      /// border Color for filled field pin box

                      filledFieldBorderColor: Colors.black12,
                    ),
                    maxLength: 6,

                    /// no of pin field

                    showCursor: true,

                    /// bool to show cursor in pin field or not

                    cursorColor: Colors.indigo,

                    /// to choose cursor color

                    upperChild: Column(
                      children: [
                        Text(
                          "Verificação",
                          style: GoogleFonts.rajdhani(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Por favor insira o código que recebeu por mensagem! $_otpValue",
                          style: GoogleFonts.rajdhani(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Fazemos de tudo para que a sua conta tenha segurança",
                          style: GoogleFonts.rajdhani(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    middleChild: Column(
                      children: [
                        SizedBox(height: 10),

                        // ElevatedButton(

                        //     onPressed: () {

                        //       _otpPinFieldController.currentState

                        //           ?.clearOtp(); // clear controller

                        //     },

                        //     child: Text('Limpar OTP')),

                        SizedBox(height: 10),

                        _timerRunning
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Caso não recebeu o seu código de confirmação, aguarde a contagem abaixo.",
                                    style: GoogleFonts.rajdhani(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: _secondsRemaining,
                                      builder: (context, value, _) {
                                        return Text(
                                          '${_secondsRemaining.value}',
                                          style: GoogleFonts.rajdhani(
                                            fontSize: 50,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(.7),
                                          ),
                                        );
                                      }),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Caso não recebeu o seu código de confirmação, aguarde a contagem abaixo.",
                                    style: GoogleFonts.rajdhani(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _secondsRemaining.value = 30;

                                      _timerRunning = true;

                                      setState(() {
                                        _startTimer();
                                      });

                                      authBloc.add(
                                        AuthResetCodeEvent(
                                          identfyed: widget.token,
                                          phoneCode:
                                              phoneSmsAppSignature.toString(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Não recebi o código",
                                      style: GoogleFonts.rajdhani(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                    showCustomKeyboard: true,

                    /// to select cursor width

                    mainAxisAlignment: MainAxisAlignment.center,

                    /// place otp pin field according to yourself

                    /// predefine decorate of pinField use  OtpPinFieldDecoration.defaultPinBoxDecoration||OtpPinFieldDecoration.underlinedPinBoxDecoration||OtpPinFieldDecoration.roundedPinBoxDecoration

                    ///use OtpPinFieldDecoration.custom  (by using this you can make Otp_Pin_Field according to yourself like you can give fieldBorderRadius,fieldBorderWidth and etc things)

                    otpPinFieldDecoration:
                        OtpPinFieldDecoration.defaultPinBoxDecoration),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _listenOtp() async {
    return await SmsAutoFill().getAppSignature;
  }

  void _listenCode() async {
    //await SmsAutoFill().unregisterListener;

    final status = await Permission.notification.request();

    if (status.isGranted) {
      await SmsAutoFill().listenForCode();
    }
  }

  @override
  void codeUpdated() {}
}

// Copyright (c) 2019-present,  SurfStudio LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: library_private_types_in_public_api, prefer-match-file-name

// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:otp_autofill/otp_autofill.dart';

// class OTPScreen extends StatefulWidget {
//   final String token;
//   const OTPScreen(this.token);

//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final scaffoldKey = GlobalKey();
//   late OTPTextEditController controller;
//   late OTPInteractor _otpInteractor;

//   @override
//   void initState() {
//     super.initState();
//     _initInteractor();
//     controller = OTPTextEditController(
//       codeLength: 5,
//       //ignore: avoid_print
//       onCodeReceive: (code) => print('Your Application receive code - $code'),
//       otpInteractor: _otpInteractor,
//     )..startListenUserConsent(
//         (code) {
//           final exp = RegExp(r'(\d{5})');
//           return exp.stringMatch(code ?? '') ?? '';
//         },
//         strategies: [
//           //SampleStrategy(),
//         ],
//       );
//   }

//   Future<void> _initInteractor() async {
//     _otpInteractor = OTPInteractor();

//     // You can receive your app signature by using this method.
//     final appSignature = await _otpInteractor.getAppSignature();

//     if (kDebugMode) {
//       print('Your app signature: $appSignature');
//     }
//   }

//   @override
//   void dispose() {
//     controller.stopListen();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         key: scaffoldKey,
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(40.0),
//             child: TextField(
//               textAlign: TextAlign.center,
//               keyboardType: TextInputType.number,
//               controller: controller,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'dart:async';

// import 'package:animated_snack_bar/animated_snack_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:maxalert/bloc/auth/auth_bloc.dart';
// import 'package:maxalert/bloc/auth/auth_state.dart';
// import 'package:maxalert/data/services/api_service.dart';
// import 'package:maxalert/presentation/main_screen.dart';
// import 'package:maxalert/utils/app_images.dart';
// import 'package:otp_autofill/otp_autofill.dart';
// import 'package:otp_text_field/otp_text_field.dart';
// import 'package:otp_text_field/style.dart';
// import 'package:sms_autofill/sms_autofill.dart';

// class OTPScreen extends StatefulWidget {
//   final String token;

//   const OTPScreen(this.token);
//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final AuthService authService = AuthService();
//   FocusNode textFieldFocusNode = FocusNode();

//   ValueNotifier<int> _secondsRemaining = ValueNotifier<int>(30);
//   bool _timerRunning = true;
//   String? phoneSmsAppSignature;

//   void valueSignature() async {
//     phoneSmsAppSignature = await _listenOtp();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // _listenOtp();
//     _listenCode();
//     //valueSignature();
//     _startTimer();
//   }

//   void _startTimer() {
//     const oneSecond = Duration(seconds: 1);
//     Timer.periodic(oneSecond, (timer) {
//       if (_secondsRemaining.value == 1) {
//         setState(() {
//           _timerRunning = false;
//           timer.cancel();
//         });
//       } else {
//         _secondsRemaining.value--;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _secondsRemaining.value = 0;
//   }

//   OtpFieldController _controller = OtpFieldController();
//   final scaffoldKey = GlobalKey();
//   late OTPTextEditController controller;
//   late OTPInteractor _otpInteractor;

//   @override
//   Widget build(BuildContext context) {
//     final authBloc = BlocProvider.of<AuthBloc>(context);
//     String _code = "";
//     FocusScopeNode textFieldFocusNode = FocusScopeNode();

//     return Container(
//       // width: double.infinity,
//       // height: double.infinity,
//       // decoration: BoxDecoration(
//       //   color: Theme.of(context).colorScheme.background.withOpacity(.5),
//       //   image: DecorationImage(
//       //     image: AssetImage(
//       //       AppImages.PARTICULAR_BACKGROUND,
//       //     ),
//       //     fit: BoxFit.cover,
//       //     opacity: .2,
//       //   ),
//       // ),
//       child: WillPopScope(
//         onWillPop: () async {
//           return true;
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//           ),
//           backgroundColor: Theme.of(context).colorScheme.background,
//           body: SafeArea(
//             child: BlocListener<AuthBloc, AuthState>(
//               listener: (context, state) {
//                 print("ESTADO ${state}");
//                 if (state is AuthSuccess) {
//                   Get.off(() => MainScreen());
//                 } else if (state is AuthLoading) {
//                   EasyLoading.show(
//                     status: 'Processando...',
//                     maskType: EasyLoadingMaskType.black,
//                   );
//                 } else if (state is AuthSuccessResetCodeState) {
//                   EasyLoading.dismiss();
//                 }
//                 if (state is AuthSuccessToken) {
//                   Get.off(() => MainScreen());
//                 } else if (state is AuthFailure) {
//                   EasyLoading.dismiss();
//                   if (state.code == 500) {
//                     AnimatedSnackBar.material(
//                       '${state.error}',
//                       type: AnimatedSnackBarType.error,
//                       mobilePositionSettings: const MobilePositionSettings(
//                         topOnAppearance: 50,
//                       ),
//                     ).show(context);
//                   } else {
//                     print("2");
//                     AnimatedSnackBar.material(
//                       '${state.error}',
//                       type: AnimatedSnackBarType.warning,
//                       mobilePositionSettings: const MobilePositionSettings(
//                         topOnAppearance: 50,
//                       ),
//                     ).show(context);
//                   }
//                 }
//               },
//               child: SingleChildScrollView(
//                 physics: ClampingScrollPhysics(),
//                 reverse: true,
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Text(
//                           "Verificação",
//                           style: GoogleFonts.rajdhani(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w900,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 6,
//                         ),
//                         Text(
//                           "Por favor insira o código que recebeu por mensagem!",
//                           style: GoogleFonts.rajdhani(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         Text(
//                           "Fazemos de tudo para que a sua conta tenha segurança",
//                           style: GoogleFonts.rajdhani(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                             color: Theme.of(context).colorScheme.onSurface,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(
//                           height: 16,
//                         ),
//                         Container(
//                           width: double.infinity,
//                           child: PinFieldAutoFill(
//                               //focusNode: textFieldFocusNode,
//                               decoration: UnderlineDecoration(
//                                 textStyle: TextStyle(
//                                   fontSize: 20,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .onBackground,
//                                 ),
//                                 colorBuilder: FixedColorBuilder(
//                                     Theme.of(context)
//                                         .colorScheme
//                                         .onBackground
//                                         .withOpacity(0.3)),
//                               ),
//                               currentCode: _code,
//                               onCodeSubmitted: (code) {},
//                               onCodeChanged: (code) {
//                                 if (code!.length == 6) {
//                                   authBloc.add(
//                                     AuthCheckCode(
//                                       identfyed: widget.token,
//                                       code: code.toString(),
//                                     ),
//                                   );
//                                 }
//                               }),
//                         ),
//                         SizedBox(
//                           height: 16,
//                         ),
//                         _timerRunning
//                             ? Column(
//                                 children: [
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Text(
//                                     "Caso não recebeu o seu código de confirmação, aguarde a contagem abaixo.",
//                                     style: GoogleFonts.rajdhani(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   ValueListenableBuilder(
//                                       valueListenable: _secondsRemaining,
//                                       builder: (context, value, _) {
//                                         return Text(
//                                           '${_secondsRemaining.value}s',
//                                           style: GoogleFonts.rajdhani(
//                                             fontSize: 50,
//                                             fontWeight: FontWeight.w600,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary
//                                                 .withOpacity(.7),
//                                           ),
//                                         );
//                                       }),
//                                 ],
//                               )
//                             : Column(
//                                 children: [
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Text(
//                                     "Caso não recebeu o seu código de confirmação, aguarde a contagem abaixo.",
//                                     style: GoogleFonts.rajdhani(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurface,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       _secondsRemaining.value = 30;
//                                       _timerRunning = true;
//                                       setState(() {
//                                         _startTimer();
//                                       });
//                                       authBloc.add(
//                                         AuthResetCodeEvent(
//                                           identfyed: widget.token,
//                                           phoneCode: phoneSmsAppSignature!,
//                                         ),
//                                       );
//                                     },
//                                     child: Text(
//                                       "Não recebi o código",
//                                       style: GoogleFonts.rajdhani(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .primary,
//                                         decoration: TextDecoration.underline,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     //Text("VOLTAR PARA LOGIN",),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<String> _listenOtp() async {
//     return await SmsAutoFill().getAppSignature;
//   }

//   void _listenCode() async {
//     //await SmsAutoFill().unregisterListener;
//     // await SmsAutoFill().listenForCode();
//     // print("CHAMOU");

//     phoneSmsAppSignature = await _listenOtp();

//     final authBloc = BlocProvider.of<AuthBloc>(context);

//     OTPInteractor _otpInteractor = OTPInteractor();

//     _otpInteractor
//         .getAppSignature()
//         .then((value) => print('signature - $value'));

//     controller = OTPTextEditController(
//       codeLength: 6,
//       onCodeReceive: (code) {
//         print("My code");

//         print(code);

//         //_otpPinFieldController = code.toString();

//         if (code.length == 6) {
//           authBloc.add(
//             AuthCheckCode(
//               identfyed: widget.token,
//               code: code.toString(),
//             ),
//           );
//         }
//       },
//       onTimeOutException: () {
//         // Lida com a exceção de tempo limite

//         controller.startListenUserConsent;
//       },
//     )..startListenUserConsent(
//         (code) {
//           final exp = RegExp(r'(\d{6})');

//           final authBloc = BlocProvider.of<AuthBloc>(context);

//           return exp.stringMatch(code ?? '') ?? '';
//         },
//         strategies: [
//           // SampleStrategy(),
//         ],
//       );
//   }

//   @override
//   void codeUpdated() {}
// }

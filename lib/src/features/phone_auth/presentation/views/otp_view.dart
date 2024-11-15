import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive/flutter_responsive.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:pinput/pinput.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:vivamais/src/core/utils/app_strings.dart';
import 'package:vivamais/src/core/utils/app_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:vivamais/src/features/user/presentation/cubit/user_cubit.dart';
import 'package:vivamais/src/features/user/presentation/cubit/user_state.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/theme/color_palette.dart';
import '../cubit/phone_auth_cubit.dart';
import '../cubit/phone_auth_state.dart';

class OtpView extends StatefulWidget {
  final String verificationId;
  final PhoneController phoneNumber;
  const OtpView({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final TextEditingController phoneCodeSms = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  late final SmsRetriever smsRetriever;

  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  TextEditingController pinController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.otp),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserSuccess) {
            if (!state.isUserExists) {
              Get.toNamed(Routes.registerRoute, arguments: widget.phoneNumber);
            } else {
              Get.toNamed(Routes.vivaMaisRoute);
            }
          }
          // else {
          //   _btnController.stop();
          // }
        },
        builder: (context, state) {
          return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
            listener: (context, state) {
              if (state is PhoneAuthSuccess) {
                _btnController.success();
                BlocProvider.of<UserCubit>(context)..checkIfUuidExists();
              } else if (state is PhoneAuthFailure) {
                _btnController.stop();
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Container(
                  padding: EdgeInsets.all(AppPadding.p14),
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppSize.s18,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              AppStrings.verifyCode,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),

                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: AppStrings.weveSendFourDigit,
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '+${widget.phoneNumber.value!.countryCode.toString()} ${widget.phoneNumber.value!.nsn.toString().substring(0, 3)}*****${widget.phoneNumber.value!.nsn.toString().substring(
                                              widget.phoneNumber.value!.nsn
                                                      .toString()
                                                      .length -
                                                  2,
                                            )}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppStrings.makeSureYouEnterCorrect,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: AppSize.s40,
                            ),
                            Pinput(
                              controller: pinController,
                              length: 6,
                              separatorBuilder: (index) =>
                                  const SizedBox(width: 8),
                              hapticFeedbackType:
                                  HapticFeedbackType.lightImpact,
                              onCompleted: (pin) {
                                debugPrint('onCompleted: $pin');
                              },
                              onChanged: (value) {
                                debugPrint('onChanged: $value');
                              },
                              cursor: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [],
                              ),
                            ),
                            // OtpTextField(
                            //   numberOfFields: 6,
                            //   fieldWidth: AppSize.s50,
                            //   fieldHeight: AppSize.s60,
                            //   borderWidth: 2,
                            //   filled: true,
                            //   borderColor: AppColors.primaryColor,
                            //   focusedBorderColor: AppColors.primaryColor,
                            //   textStyle: Theme.of(context).textTheme.headlineLarge,
                            //   showFieldAsBox: true,
                            //   //runs when a code is typed in
                            //   onCodeChanged: (String code) {
                            //     if (code.length == 6) {
                            //       phoneCodeSms.text = code.toString();
                            //       print("IGUAL");
                            //       // BlocProvider.of<OtpCubit>(context)
                            //       //   ..otp(code, widget.verificationId);
                            //     }
                            //   },
                            //   //runs when every textfield is filled
                            //   onSubmit: (String verificationCode) {
                            //     // BlocProvider.of<PhoneAuthCubit>(context)
                            //     //   ..signInWithSmsCode(
                            //     //     widget.verificationId,
                            //     //     verificationCode,
                            //     // );
                            //   }, // end onSubmit
                            // ),

                            SizedBox(
                              height: AppSize.s40,
                            ),
                            Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: AppStrings.notReciveCode,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' ${AppStrings.resendCode}',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: AppSize.s30,
                                ),
                                RoundedLoadingButton(
                                  color: AppColors.primaryColor,
                                  successColor: AppColors.green,
                                  child: Text(AppStrings.keepingOn,
                                      style: TextStyle(color: Colors.white)),
                                  controller: _btnController,
                                  onPressed: () async {
                                    print("TAMANHO ${pinController.text}");
                                    if (pinController.text.length == 6) {
                                      BlocProvider.of<PhoneAuthCubit>(context)
                                        ..signInWithSmsCode(
                                          widget.verificationId,
                                          pinController.text,
                                        );
                                    } else {
                                      print("False");
                                    }
                                  },
                                ),

                                // ElevatedButton(
                                //   onPressed: () {
                                //     // Navigator.pushNamed(context, Routes.bloodRoute);
                                //     // Navigator.of(context)
                                //     //     .pushNamed(Routes.vivaMaisRoute);
                                //     BlocProvider.of<PhoneAuthCubit>(context)
                                //       ..signInWithSmsCode(
                                //           widget.verificationId, phoneCodeSms.text);
                                //   },
                                //   child: Text(AppStrings.keepingOn),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

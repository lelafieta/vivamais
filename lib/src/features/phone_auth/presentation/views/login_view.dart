import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:vivamais/src/config/theme/color_palette.dart';
import 'package:vivamais/src/core/resources/app_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivamais/src/features/phone_auth/presentation/cubit/phone_auth_cubit.dart';
import 'package:vivamais/src/features/user/presentation/cubit/user_cubit.dart';

import '../../../../config/routes/routes.dart';
import '../../../../core/resources/app_svg.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_values.dart';
import '../cubit/phone_auth_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final PhoneController _phoneController =
      PhoneController(PhoneNumber(isoCode: IsoCode.AO, nsn: ""));
  ValueNotifier<bool> isValidate = ValueNotifier<bool>(false);
  final TextEditingController _phoneNumber = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  Future otpFaunc(String number) async {
    // Create a PhoneAuthCredential with the code

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${number}',
      verificationCompleted: (PhoneAuthCredential credential) {
        print("verification completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verify failed");
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        print("code send $verificationId");
        Get.toNamed(Routes.otpRoute, arguments: verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
        listener: (context, state) {
          _btnController.stop();
          if (state is PhoneAuthSuccess) {
            // Navigator.of(context).pushNamed(Routes.vivaMaisRoute);
          } else if (state is PhoneAuthCodeSent) {
            _btnController.stop();
            Map<String, dynamic> map = {
              "verificationId": state.verificationId,
              "phoneNumber": _phoneController
            };

            Get.toNamed(
              Routes.otpRoute,
              arguments: map,
            );

            // Navigator.of(context)
            //     .pushNamed(Routes.vivaMaisRoute, arguments: map);
          } else if (state is PhoneAuthFailure) {
            _btnController.stop();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.all(AppPadding.p10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        AppSvg.auth,
                        width: AppSize.s300,
                      ),
                    ),
                    SizedBox(
                      height: AppSize.s25,
                    ),
                    Text(
                      AppStrings.loginOrRegister,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(
                      height: AppSize.s12,
                    ),
                    Text(
                      AppStrings.authInfo,
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: AppSize.s20,
                    ),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(AppSize.s8),
                    //   child: PhoneTextField(
                    //     locale: const Locale(AppStrings.pt),
                    //     showCountryCodeAsIcon: true,
                    //     dialogTitle: AppStrings.selectCountry,
                    //     decoration: const InputDecoration(
                    //       filled: true,
                    //       contentPadding: EdgeInsets.only(
                    //           left: AppPadding.p10, top: AppPadding.p10),
                    //       border: InputBorder.none,
                    //       hintText: AppStrings.phone,
                    //       fillColor: AppColors.primaryColor20,
                    //     ),
                    //     searchFieldInputDecoration: const InputDecoration(
                    //       filled: true,
                    //       border: InputBorder.none,
                    //       suffixIcon: Icon(Icons.search),
                    //       hintText: AppStrings.searchCountry,
                    //     ),
                    //     initialCountryCode: AppStrings.ao,
                    //     onChanged: (phone) {
                    //       debugPrint(phone.completeNumber);
                    //     },
                    //   ),
                    // ),
                    Form(
                      child: PhoneFormField(
                        validator: PhoneValidator.compose([
                          // list of validators to use
                          PhoneValidator.required(
                              errorText: "Telefone obrigatório"),
                          PhoneValidator.validMobile(
                              errorText: "Número inválido"),
                          // ..
                        ]),
                        controller: _phoneController,
                        defaultCountry: IsoCode.AO,
                        decoration: const InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.only(
                              left: AppPadding.p10, top: AppPadding.p10),
                          border: InputBorder.none,
                          hintText: AppStrings.phone,
                          fillColor: AppColors.primaryColor20,
                        ),
                        countrySelectorNavigator:
                            const CountrySelectorNavigator.searchDelegate(),
                        onChanged: (phoneNumber) async {
                          _phoneNumber.text =
                              "${phoneNumber!.countryCode} ${phoneNumber.nsn}";

                          await secureStorage.write(
                              key: "phoneNumber", value: _phoneNumber.text);
                        },
                        enabled: true,
                        isCountrySelectionEnabled: true,
                        onSubmitted: (value) {
                          print(value);
                        },
                      ),
                    ),

                    SizedBox(
                      height: AppSize.s8,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "${AppStrings.forgetOrChanged} ",
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: AppSize.s14,
                          fontFamily: AppStrings.fontFamily,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: " ${AppStrings.clickHere}",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle the tap here (e.g., navigate or show a message)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Button Clicked!')),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppSize.s20,
                    ),

                    RoundedLoadingButton(
                      color: AppColors.primaryColor,
                      successColor: AppColors.green,
                      child: Text(AppStrings.keepingOn,
                          style: TextStyle(color: Colors.white)),
                      controller: _btnController,
                      onPressed: () async {
                        if (_phoneController.value!.isValid()) {
                          BlocProvider.of<PhoneAuthCubit>(context)
                            ..verifyPhoneNumber(
                                "+${_phoneController.value!.countryCode} ${_phoneController.value!.nsn}");
                          // await otpFunc(
                          //     "+${_phoneController.value!.countryCode} ${_phoneController.value!.nsn}");
                          print("true");
                        } else {
                          print("False");
                        }
                      },
                    ),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     if (_phoneController.value!.isValid()) {
                    //       BlocProvider.of<PhoneAuthCubit>(context)
                    //         ..verifyPhoneNumber(
                    //             "+${_phoneController.value!.countryCode} ${_phoneController.value!.nsn}");
                    //       // await otpFunc(
                    //       //     "+${_phoneController.value!.countryCode} ${_phoneController.value!.nsn}");
                    //       print("true");
                    //     } else {
                    //       print("False");
                    //     }
                    //     // Navigator.pushNamed(context, Routes.otpRoute);
                    //   },
                    //   child: Text(AppStrings.keepingOn),
                    // ),

                    // SizedBox(
                    //   height: AppSize.s20,
                    // ),

                    // ElevatedButton(
                    //   style: ButtonStyle(
                    //     backgroundColor: MaterialStatePropertyAll(
                    //       AppColors.whiteColor,
                    //     ),
                    //     shape: MaterialStatePropertyAll(
                    //       RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //         side: BorderSide(color: AppColors.primaryColor),
                    //       ),
                    //     ),
                    //   ),
                    //   onPressed: () async {
                    //     //BlocProvider.of<PhoneAuthCubit>(context)..signInWithGoogle();
                    //     // Navigator.pushNamed(context, Routes.otpRoute);
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       SvgPicture.asset(
                    //         AppIcons.google,
                    //         width: AppSize.s30,
                    //       ),
                    //       SizedBox(
                    //         width: AppSize.s8,
                    //       ),
                    //       Text(
                    //         AppStrings.keepingOn,
                    //         style: TextStyle(color: AppColors.primaryColor),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // RichText(
                    //   text: TextSpan(
                    //     text: "${AppStrings.doesNotHaveAccount} ",
                    //     style: TextStyle(
                    //       color: AppColors.secondaryColor,
                    //       fontSize: AppSize.s14,
                    //       fontFamily: AppStrings.fontFamily,
                    //     ),
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //         text: " ${AppStrings.createAccount}",
                    //         style: TextStyle(
                    //           color: AppColors.primaryColor,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //         recognizer: TapGestureRecognizer()
                    //           ..onTap = () {
                    //             Get.toNamed(Routes.registerRoute);
                    //           },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // floatingActionButton: ElevatedButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, Routes.otpRoute);
      //   },
      //   child: Text(AppStrings.keepingOn),
      // ),
    );
  }
}


  // ClipRRect(
  //                 borderRadius: BorderRadius.circular(AppSize.s8),
  //                 child: PhoneTextField(
  //                   locale: const Locale(AppStrings.pt),
  //                   showCountryCodeAsIcon: true,
  //                   dialogTitle: AppStrings.selectCountry,
  //                   decoration: const InputDecoration(
  //                     filled: true,
  //                     contentPadding: EdgeInsets.only(
  //                         left: AppPadding.p10, top: AppPadding.p10),
  //                     border: InputBorder.none,
  //                     hintText: AppStrings.phone,
  //                     fillColor: AppColors.primaryColor20,
  //                   ),
  //                   searchFieldInputDecoration: const InputDecoration(
  //                     filled: true,
  //                     border: InputBorder.none,
  //                     suffixIcon: Icon(Icons.search),
  //                     hintText: AppStrings.searchCountry,
  //                   ),
  //                   initialCountryCode: AppStrings.ao,
  //                   onChanged: (phone) {
  //                     debugPrint(phone.completeNumber);
  //                   },
  //                 ),
  //               ),
              
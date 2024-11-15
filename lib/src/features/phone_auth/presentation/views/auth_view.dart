import 'package:vivamais/src/config/theme/color_palette.dart';
import 'package:vivamais/src/core/resources/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phone_text_field/phone_text_field.dart';

import '../../../../config/routes/routes.dart';
import '../../../../core/resources/app_svg.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_values.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(AppPadding.p10),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.s8),
                  child: PhoneTextField(
                    locale: const Locale(AppStrings.pt),
                    showCountryCodeAsIcon: true,
                    dialogTitle: AppStrings.selectCountry,
                    decoration: const InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.only(
                          left: AppPadding.p10, top: AppPadding.p10),
                      border: InputBorder.none,
                      hintText: AppStrings.phone,
                      fillColor: AppColors.primaryColor20,
                    ),
                    searchFieldInputDecoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                      hintText: AppStrings.searchCountry,
                    ),
                    initialCountryCode: AppStrings.ao,
                    onChanged: (phone) {
                      debugPrint(phone.completeNumber);
                    },
                  ),
                ),
                SizedBox(
                  height: AppSize.s8,
                ),
                Row(
                  children: [
                    Text(
                      textAlign: TextAlign.left,
                      AppStrings.forgetOrChanged,
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: AppSize.s12,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.s120,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.otpRoute);
                  },
                  child: Text(AppStrings.keepingOn),
                ),
                SizedBox(
                  height: AppSize.s10,
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.google,
                        width: AppSize.s20,
                      ),
                      SizedBox(
                        width: AppSize.s12,
                      ),
                      Text(AppStrings.keepingWithGoogle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

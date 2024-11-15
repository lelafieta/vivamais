import 'package:animate_do/animate_do.dart';
import 'package:vivamais/src/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../config/theme/color_palette.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/resources/app_images.dart';
import '../../../../core/resources/app_svg.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_values.dart';

class BankBloodView extends StatelessWidget {
  const BankBloodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInUp(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Banco de Sangue",
              //style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(AppMargin.m16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilderTextField(
                  name: 'search',
                  decoration: const InputDecoration(
                    hintText: 'Pesquise por Localização',
                    suffixIcon: Icon(FontAwesomeIcons.searchLocation),
                  ),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                SizedBox(
                  height: AppSize.s15,
                ),
                Container(
                  padding: EdgeInsets.all(AppPadding.p16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.strokeColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    color: AppColors.primaryColor,
                                    // child: Image.asset(
                                    //   AppImages.profile,
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Azancot Menezes",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.location,
                                          width: 18,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Luanda, Camama",
                                          style: TextStyle(
                                            color: AppColors.secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "10 km",
                                          style: TextStyle(
                                            color: AppColors.secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: AppSize.s15,
                ),
                Container(
                  padding: EdgeInsets.all(AppPadding.p16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.strokeColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    color: AppColors.primaryColor,
                                    // child: Image.asset(
                                    //   AppImages.profile,
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Azancot Menezes",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.location,
                                          width: 18,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Luanda, Camama",
                                          style: TextStyle(
                                            color: AppColors.secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "10 km",
                                          style: TextStyle(
                                            color: AppColors.secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

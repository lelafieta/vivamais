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

class DonorView extends StatelessWidget {
  const DonorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInUp(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Doadores de Emergência",
              //style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(AppMargin.m16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          border: Border.all(
                            width: 1.0,
                            color: AppColors.strokeColor,
                          ),
                        ),
                        child: FormBuilderTextField(
                          name: 'search',
                          decoration: const InputDecoration(
                            hintText: 'Pesquise por um doador emergente',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          obscureText: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: AppColors.whiteColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.s15,
                ),
                Text(
                  "Sugestões",
                  style: Theme.of(context).textTheme.bodyLarge,
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
                                Container(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          child: Image.asset(
                                            AppImages.profile,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          child: SvgPicture.asset(
                                            AppIcons.crown,
                                            width: 14,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ana Martins",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      "0.7 km",
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.star,
                                          color: Colors.orange,
                                          width: 16,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "5.0",
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: SvgPicture.asset(
                              AppIcons.bp,
                              color: AppColors.primaryColor,
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
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.red,
                                    child: Image.asset(
                                      AppImages.profile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ana Martins",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      "0.7 km",
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.star,
                                          color: Colors.orange,
                                          width: 16,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "5.0",
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: SvgPicture.asset(
                              AppIcons.bp,
                              color: AppColors.primaryColor,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:vivamais/src/app/app_entity.dart';
import 'package:vivamais/src/core/utils/app_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../../../config/theme/color_palette.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/resources/app_images.dart';
import '../../../../core/resources/app_svg.dart';
import '../../../../core/utils/app_values.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 350,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.infinity,
                          height: 300,
                          color: AppColors.primaryColor,
                          child: SafeArea(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    child: Image.asset(
                                      AppImages.profile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Jesse Lingard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "9991228333",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.star,
                                      width: 14,
                                      color: Colors.yellow,
                                    ),
                                    SvgPicture.asset(
                                      AppIcons.star,
                                      width: 14,
                                      color: Colors.yellow,
                                    ),
                                    SvgPicture.asset(
                                      AppIcons.star,
                                      width: 14,
                                      color: Colors.yellow,
                                    ),
                                    SvgPicture.asset(
                                      AppIcons.star,
                                      width: 14,
                                      color: Colors.yellow,
                                    ),
                                    SvgPicture.asset(
                                      AppIcons.star,
                                      width: 14,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      "(4)",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 20,
                        right: 20,
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 1,
                              color: AppColors.lightGrey.withOpacity(.5),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.blood,
                                      width: 40,
                                      color: AppColors.primaryColor,
                                    ),
                                    Text(
                                      "Grupo B+",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.bloodTransfusion,
                                      width: 40,
                                    ),
                                    Text(
                                      "4 Vidas Salvas",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontFamily: AppStrings.fontFamily,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                            color: AppColors.primaryColor,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "20",
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " Maio",
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Prox. Doação",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        child: SafeArea(
                          child: SvgPicture.asset(
                            AppIcons.edit,
                            width: 30,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: EdgeInsets.only(left: 20),
                      //   child: Text(
                      //     "Conta",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w600,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                      ListTile(
                        leading: SvgPicture.asset(
                          AppIcons.user2,
                          width: 30,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          "Perfil",
                          style: TextStyle(
                            fontSize: AppSize.s12,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),

                      Divider(),
                      ListTile(
                        leading: SvgPicture.asset(
                          AppIcons.calendarCheck,
                          width: 35,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          "Disponível para doar",
                          style: TextStyle(
                            fontSize: AppSize.s12,
                          ),
                        ),
                        trailing: SwitcherButton(
                          onColor: AppColors.primaryColor,
                          offColor: AppColors.blackColor,
                          value: true,
                          onChange: (value) {
                            print(value);
                          },
                        ),
                      ),
                      ListTile(
                        leading: SvgPicture.asset(
                          AppIcons.location2,
                          width: 30,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          "Gerenciar Endereço",
                          style: TextStyle(
                            fontSize: AppSize.s12,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        leading: SvgPicture.asset(
                          AppIcons.trophyAward,
                          width: 30,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          "Pontos de Recompensa",
                          style: TextStyle(
                            fontSize: AppSize.s12,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        leading: SvgPicture.asset(
                          AppIcons.creditCardCheck,
                          width: 30,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          "Cartão de Doador",
                          style: TextStyle(
                            fontSize: AppSize.s12,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        leading: SvgPicture.asset(
                          AppIcons.history,
                          width: 30,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          "Histórico",
                          style: TextStyle(
                            fontSize: AppSize.s12,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        leading: SvgPicture.asset(
                          AppIcons.card,
                          width: 30,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          "Informação de Pagamento",
                          style: TextStyle(
                            fontSize: AppSize.s12,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
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

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/color_palette.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/resources/app_images.dart';
import '../../../../core/utils/app_values.dart';

class TicketView extends StatelessWidget {
  const TicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Center(
            child: Text(
              "Meus Tickets",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(AppMargin.m16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  padding: EdgeInsets.all(AppSize.s14),
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.lightGrey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pedido de Doação",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.location,
                                  width: 16,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Maria Pia",
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 15,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "11 Abril 2024",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Image.asset(AppImages.qr)
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 120,
                  padding: EdgeInsets.all(AppSize.s14),
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.lightGrey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Doação Sangue",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.location,
                                  width: 16,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Américo Boa Vida",
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 15,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "11 Abril 2024",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: AppSize.s90,
                        padding: EdgeInsets.all(AppPadding.p10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sua Fila",
                              style: TextStyle(
                                fontWeight: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .fontWeight,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .fontSize,
                              ),
                            ),
                            Expanded(
                              child: FittedBox(
                                child: Text(
                                  "20",
                                  style: TextStyle(
                                    fontSize: AppSize.s20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

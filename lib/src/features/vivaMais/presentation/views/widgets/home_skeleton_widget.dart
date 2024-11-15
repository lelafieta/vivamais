import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../config/routes/routes.dart';
import '../../../../../config/theme/color_palette.dart';
import '../../../../../core/resources/app_icons.dart';
import '../../../../../core/resources/app_images.dart';
import '../../../../../core/utils/app_values.dart';

class HomeSkeletonWidget extends StatelessWidget {
  const HomeSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: AppColors.strokeColor,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            "Feed",
                            style: TextStyle(color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("Pedidos"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppPadding.p20),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Ana Martins",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                AppIcons.location,
                                                width: 18,
                                                color: AppColors
                                                    .secondaryTextColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Azancot Menezes",
                                                style: TextStyle(
                                                  color: AppColors
                                                      .secondaryTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.hourglass_bottom,
                                                color: AppColors
                                                    .secondaryTextColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "10:20, Abril 2024",
                                                style: TextStyle(
                                                  color: AppColors
                                                      .secondaryTextColor,
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
                                    AppIcons.an,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: AppColors.strokeColor,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Negar",
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: AppColors.strokeColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(Routes.donateAcceptRoute);
                                  },
                                  child: Text(
                                    "Doar Agora",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: EdgeInsets.all(AppPadding.p20),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Ana Martins",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                AppIcons.location,
                                                width: 18,
                                                color: AppColors
                                                    .secondaryTextColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Azancot Menezes",
                                                style: TextStyle(
                                                  color: AppColors
                                                      .secondaryTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.hourglass_bottom,
                                                color: AppColors
                                                    .secondaryTextColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "10:20, Abril 2024",
                                                style: TextStyle(
                                                  color: AppColors
                                                      .secondaryTextColor,
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
                                    AppIcons.an,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: AppColors.strokeColor,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Negar",
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: AppColors.strokeColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(Routes.donateAcceptRoute);
                                  },
                                  child: Text(
                                    "Doar Agora",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

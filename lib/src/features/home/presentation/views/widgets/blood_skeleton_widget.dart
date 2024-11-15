import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../config/theme/color_palette.dart';
import '../../../../../core/resources/app_icons.dart';
import '../../../../../core/utils/app_values.dart';

class BloodSkeletonWidget extends StatelessWidget {
  const BloodSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: AppMargin.m15),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.ap,
                color: AppColors.primaryColor,
              ),
              Text(
                "10%",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 15,
          );
        },
        itemCount: 8,
      ),
    );
  }
}

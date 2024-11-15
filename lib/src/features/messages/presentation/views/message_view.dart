import 'package:animate_do/animate_do.dart';
import 'package:vivamais/src/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/color_palette.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/resources/app_images.dart';
import '../../../../core/resources/app_svg.dart';
import '../../../../core/utils/app_values.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Center(
            child: Text(
              "Mensagens",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(AppMargin.m16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.chatRoute);
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 45,
                        height: 45,
                        child: Image.asset(
                          AppImages.profile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      "Ana Martins",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      overflow: TextOverflow.ellipsis,
                      "Olá, bom dia como passou o dia??",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Agora",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(
                          height: AppSize.s8,
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "1",
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 45,
                      height: 45,
                      child: Image.asset(
                        AppImages.profile,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    "Ana Martins",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    overflow: TextOverflow.ellipsis,
                    "Olá, bom dia como passou o dia??",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Agora",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(
                        height: AppSize.s8,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            "1",
                            style: TextStyle(color: AppColors.whiteColor),
                          ),
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

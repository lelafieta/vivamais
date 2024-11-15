import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/routes/routes.dart';
import '../../../../config/theme/color_palette.dart';
import '../../../../core/resources/app_svg.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_values.dart';

class OnBoargingView extends StatefulWidget {
  OnBoargingView({super.key});

  @override
  State<OnBoargingView> createState() => _OnBoargingViewState();
}

class _OnBoargingViewState extends State<OnBoargingView> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: "Registar",
      finishButtonTextStyle: TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      onFinish: () {
        storage.write(key: "onboarding", value: "true");
        Navigator.pushNamed(context, Routes.registerRoute);
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: AppColors.primaryColor,
      ),
      skipTextButton: Text(
        AppStrings.skip,
        style: TextStyle(
          fontSize: AppSize.s16,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const Text(AppStrings.login),
          ),
        );
      },
      controllerColor: AppColors.primaryColor,
      totalPage: 3,
      headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pageBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      background: [
        SvgPicture.asset(AppSvg.onBoarding1, width: AppSize.s400),
        SvgPicture.asset(AppSvg.onBoarding2, height: AppSize.s400),
        SvgPicture.asset(AppSvg.onBoarding3, height: AppSize.s400),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Fazer um Pedido',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Obtenha a ajuda que você precisa.\nCompartilhe seu pedido de sangue e conecte-se instantaneamente com possíveis doadores.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Encontrar um Doador',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Conecte-se com milhares de potenciais doadores na comunidade turística. Pesquise por tipo sanguíneo, localização e disponibilidade.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Doar para Outros',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Juntos, podemos salvar vidas. Junte-se à nossa comunidade de doadores de sangue e cause um impacto coletivo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

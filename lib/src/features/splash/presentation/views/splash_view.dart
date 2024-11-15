import 'dart:async';

import 'package:get/get.dart';
import 'package:vivamais/src/app/app_entity.dart';
import 'package:vivamais/src/core/resources/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../config/routes/routes.dart';
import '../../../../config/theme/color_palette.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _startDelay() {
    _timer = Timer(const Duration(milliseconds: 1500), () => _goToNext());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _goToNext() async {
    final String? uid = await storage.read(key: "uid");
    final String? userProfile = await storage.read(key: "userProfile");
    final String? phoneNumber = await storage.read(key: "phoneNumber");
    if (await storage.read(key: "onboarding") == "true") {
      if (AppEntity.uid != null) {
        if (userProfile != null || userProfile != "") {
          Navigator.of(context).pushNamed(Routes.vivaMaisRoute);
        } else {
          Get.toNamed(Routes.registerRoute, arguments: phoneNumber);
        }
      } else {
        Navigator.of(context).pushNamed(Routes.loginRoute);
      }
    } else {
      Navigator.pushNamed(context, Routes.onBoardingRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.splash),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              "Viva Mais",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.whiteColor,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      offset: Offset(3, 0),
                      blurRadius: 3,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

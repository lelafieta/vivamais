import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../config/theme/color_palette.dart';

class AppConstants {
  static const int splashDelay = 2;
  static const int sliderAnimationTime = 300;
  static Widget sizeVer(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Widget sizeHor(double width) {
    return SizedBox(width: width);
  }

  static void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

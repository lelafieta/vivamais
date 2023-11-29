import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_images.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     automaticallyImplyLeading: false,
      //     backgroundColor: Theme.of(context).colorScheme.secondary,
      //     title: Center(
      //       child: Text(
      //         '',
      //         textAlign: TextAlign.center,
      //         style: GoogleFonts.rajdhani(
      //           color: Theme.of(context).colorScheme.outline,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     )),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AppImages.PARTICULAR_BACKGROUND,
              ),
              fit: BoxFit.cover,
              opacity: .4,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Center(
              //   child: Container(
              //     width: 200,
              //     height: 70,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: AssetImage(AppImages.MAIN_LOGO),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Nova versão disponível ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rajdhani(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ACTUALIZAR",
                        style: GoogleFonts.rajdhani(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.WHITE_COLOR),
                      ),
                      Icon(
                        Icons.update,
                        color: AppColors.WHITE_COLOR,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/utils/app_images.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(AppImages.ICON_APP)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Este dispositivo está em modo root, não é permitido utilizar o MAXALERTS em modo root.",
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                child: Text(
                  "OK",
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

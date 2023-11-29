import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/bloc/theme/theme_bloc.dart';
import 'package:maxalert/bloc/theme/theme_event.dart';
import 'package:maxalert/bloc/theme/theme_state.dart';
import 'package:maxalert/models/user_model.dart';
import 'package:maxalert/presentation/screens/login_screen.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_images.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static Future<void> menu(BuildContext context) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    UserModel? user;

    String? themeStorage = await storage.read(key: "theme_preference");

    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    String? userJson = await storage.read(key: 'user');
    if (userJson != null) {
      Map<String, dynamic> uaserMap = json.decode(userJson);
      user = UserModel.fromJson(uaserMap);
    } else {
      print('Nenhum dado encontrado');
    }

    Widget _buildButton(
        {VoidCallback? onTap, required String text, Color? color}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: MaterialButton(
          color: color,
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    void _abrirWhatsApp() async {
      String numeroTelefone = '+244922547030';
      String mensagem = 'Saudações estimado, tenho desafio no Maxalerts';
      String url =
          'https://wa.me/$numeroTelefone?text=${Uri.encodeFull(mensagem)}';

      final Uri _url = Uri.parse(url);
      if (await launchUrl(_url)) {
        await launchUrl(_url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    void _abrirContatos() async {
      String numeroTelefone = '+244922547030';
      final Uri _url = Uri.parse("tel:$numeroTelefone");

      if (await launchUrl(_url)) {
        await launchUrl(_url);
      } else {
        throw 'Não foi possível abrir $_url';
      }
    }

    void _abrirPoliticas() async {
      final Uri _url = Uri.parse("https://grs.max-alerts.com/static/_policy");

      if (await launchUrl(_url)) {
        await launchUrl(_url);
      } else {
        throw 'Não foi possível abrir $_url';
      }
    }

    void _abrirManuel() async {
      String numeroTelefone = '+244922547030';
      final Uri _url = Uri.parse(
          "https://afrizona.com/onboarding/documentacao/Datasheet%20Maxalerts%20ATMs%20e%20MDAs.pdf");

      if (await launchUrl(_url)) {
        await launchUrl(_url);
      } else {
        throw 'Não foi possível abrir $_url';
      }
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    "MENU",
                    style: GoogleFonts.rajdhani(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "MAXALERTS by Afrizona © ${DateTime.now().year}",
                      style: GoogleFonts.rajdhani(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Versão 2.0",
                      style: GoogleFonts.rajdhani(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                _abrirWhatsApp();
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.SECOND_COLOR
                                          .withOpacity(.2),
                                      width: 2),
                                  color: AppColors.SECOND_COLOR.withOpacity(.2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "WHATSAPP",
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.SECOND_COLOR,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        size: 20,
                                        color: AppColors.SECOND_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: Text('Maxalerts Mobile'),
                                    content:
                                        Text('Maxalerts mobile, versão 2.0'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back(); // Fechar o diálogo
                                        },
                                        child: Text('Fechar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.SECOND_COLOR
                                          .withOpacity(.2),
                                      width: 2),
                                  color: AppColors.SECOND_COLOR.withOpacity(.2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "SOBRE",
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.SECOND_COLOR,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Icon(
                                        FontAwesomeIcons.info,
                                        size: 20,
                                        color: AppColors.SECOND_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _abrirManuel();
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.SECOND_COLOR
                                          .withOpacity(.2),
                                      width: 2),
                                  color: AppColors.SECOND_COLOR.withOpacity(.2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "MANUAL",
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.SECOND_COLOR,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Icon(
                                        FontAwesomeIcons.list,
                                        size: 20,
                                        color: AppColors.SECOND_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                _abrirContatos();
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          AppColors.MAIN_COLOR.withOpacity(.2),
                                      width: 2),
                                  color: AppColors.MAIN_COLOR.withOpacity(.2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "SUPORTE TÉCNICO",
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.MAIN_COLOR,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Icon(
                                        FontAwesomeIcons.phone,
                                        size: 30,
                                        color: AppColors.MAIN_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _abrirPoliticas();
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          AppColors.MAIN_COLOR.withOpacity(.2),
                                      width: 2),
                                  color: AppColors.MAIN_COLOR.withOpacity(.2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "POLITICAS DE PRIVACIDADE",
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.MAIN_COLOR,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Icon(
                                        FontAwesomeIcons.shieldAlt,
                                        size: 30,
                                        color: AppColors.MAIN_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<ThemeBloc>(context)
                                    .add(ToggleLightTheme());

                                Get.back();
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (themeStorage == "light")
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: (themeStorage == "light")
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidSun,
                                      color: (themeStorage == "light")
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "LIGHT MODE",
                                          style: GoogleFonts.rajdhani(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: (themeStorage == "light")
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .background
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<ThemeBloc>(context)
                                    .add(ToggleDarkTheme());

                                Get.back();
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (themeStorage == "dark")
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: (themeStorage == "dark")
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidMoon,
                                      color: (themeStorage == "dark")
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "DARK MODE",
                                          style: GoogleFonts.rajdhani(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: (themeStorage == "dark")
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .background
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<ThemeBloc>(context)
                                    .add(ToggleSystemTheme());
                                Get.back();
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (themeStorage == "system")
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: (themeStorage == "system")
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: (themeStorage == 'system')
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "SYSTEM",
                                          style: GoogleFonts.rajdhani(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: (themeStorage == "system")
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .background
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final secureStorage = FlutterSecureStorage();
                          secureStorage.delete(key: "access_token");
                          secureStorage.delete(key: "identfyed");
                          Get.off(() => LoginScreen());
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.error,
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'TERMINAR SESSÃO',
                            style: GoogleFonts.rajdhani(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.outline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {});
  }

  static Future<void> profile(BuildContext context) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    UserModel? user;

    ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);

    String? themeStorage = await storage.read(key: "theme_preference");

    String? userJson = await storage.read(key: 'user');

    if (userJson != null) {
      Map<String, dynamic> uaserMap = json.decode(userJson);
      user = UserModel.fromJson(uaserMap);
    } else {
      print('Nenhum dado encontrado');
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          height: 150,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ValueListenableBuilder(
              valueListenable: isVisible,
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        "PERFIL",
                        style: GoogleFonts.rajdhani(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            right: 10,
                            top: 15,
                            child: (isVisible.value == false)
                                ? InkWell(
                                    onTap: () {
                                      isVisible.value = true;
                                    },
                                    child: Container(
                                      child: Icon(FontAwesomeIcons.eye),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      isVisible.value = false;
                                    },
                                    child: Container(
                                      child: Icon(FontAwesomeIcons.eyeSlash),
                                    ),
                                  ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                (value == true)
                                    ? Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        AppImages.USER_AVATAR),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "${user!.nome.toString().toUpperCase()}",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "${user.email.toString().toLowerCase()}",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "+244 ${user.telefone.toString()}",
                                                      style: GoogleFonts
                                                          .racingSansOne(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "------------------------",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "---------------------------------",
                                                      style:
                                                          GoogleFonts.rajdhani(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "-------------------------",
                                                      style: GoogleFonts
                                                          .racingSansOne(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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
                );
              }),
        );
      },
    ).whenComplete(() {});
  }

  static String getPlatform() {
    if (Platform.isAndroid) {
      return "1000";
    } else if (Platform.isIOS) {
      return "1001";
    } else if (Platform.isLinux) {
      return "1002";
    } else if (Platform.isMacOS) {
      return "1003";
    } else if (Platform.isWindows) {
      return "1004";
    } else {
      return "0";
    }
  }
}

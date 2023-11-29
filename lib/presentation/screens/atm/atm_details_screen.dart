import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maxalert/bloc/atm/atm_bloc.dart';
import 'package:maxalert/bloc/atm/atm_state.dart';
import 'package:maxalert/data/repositories/atm_repository.dart';
import 'package:maxalert/models/atm_data_model.dart';
import 'package:maxalert/models/atm_model.dart';
import 'package:maxalert/models/atm_status_model.dart';
import 'package:maxalert/presentation/screens/atm/widget/atm_reload_component.dart';
import 'package:maxalert/presentation/screens/login_screen.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';
import 'package:maxalert/utils/app_utils.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class AtmDetailsScreen extends StatefulWidget {
  final AtmModel atm;
  final AtmStatusModel status;
  const AtmDetailsScreen({super.key, required this.atm, required this.status});

  @override
  State<AtmDetailsScreen> createState() => _AtmDetailsScreenState();
}

class _AtmDetailsScreenState extends State<AtmDetailsScreen>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isMenuOpen = false;
  int _type = 0;

  FlutterSecureStorage storage = FlutterSecureStorage();

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  ValueNotifier<bool> _isAuthenticated = ValueNotifier<bool>(false);
  ValueNotifier<bool> callBiometric = ValueNotifier<bool>(false);

  ValueNotifier<int> segundosRestantes = ValueNotifier<int>(0);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      segundosRestantes.value = 0;
      callBiometric.value = false;
      _isAuthenticated.value = false;
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (segundosRestantes.value > 0) {
          segundosRestantes.value--;
        } else {
          timer.cancel();
        }
        // setState(() {});
      });
    } else if (state == AppLifecycleState.resumed) {
      //print(segundosRestantes);

      if (!callBiometric.value && segundosRestantes == 0) {
        //await _authenticateWithBiometrics();
      } else {
        segundosRestantes.value = 0;
      }
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool didAuthenticate = await _localAuthentication.authenticate(
        localizedReason: 'Por favor, autentique-se para continuar com o app',
      );
      _isAuthenticated.value = didAuthenticate;
      callBiometric.value = true;
      segundosRestantes.value = 0;
      // setState(() {

      // });
    } on PlatformException catch (e) {
      _isAuthenticated.value = false;
      callBiometric.value = true;
      // setState(() {});
      if (e.code == auth_error.notAvailable) {
        print("Erro na biometria");
      } else if (e.code == auth_error.notEnrolled) {
        print("A biometria não está configurada");
      } else {
        print("Erro desconhecido: $e");
      }
    }
  }

  String? themeStorage;
  void iniStorage() async {
    themeStorage = await storage.read(key: "theme_preference");
    print(themeStorage);
  }

  int index = 0;
  final AtmRepository _atmRepository = AtmRepository();

  late AtmBloc bloc;
  String? tipo;

  @override
  void dispose() {
    super.dispose();
    bloc.close();
    iniStorage();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void initState() {
    super.initState();
    bloc = AtmBloc(atmRepository: _atmRepository);
    bloc.add(AtmDetailLoadingEvent(atmId: widget.atm.atmSigitCode.toString()));
    setState(() {
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color0 = AppColors.CONTENT_UNSELECT_COLOR;
    Color color1 = AppColors.CONTENT_UNSELECT_COLOR;
    Color color2 = AppColors.CONTENT_UNSELECT_COLOR;

    if (widget.atm.tipoLocal == 1) {
      tipo = "Balcão";
    } else if (widget.atm.tipoLocal == 2) {
      tipo = "Center";
    } else if (widget.atm.tipoLocal == 3) {
      tipo = "Remoto";
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 40,
                  child: FittedBox(
                    child: Text(
                      "MAIS INFORMAÇÕES DO ATM",
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        AppUtils.menu(context);
                      },
                      child: SvgPicture.asset(
                        width: 20,
                        color: Theme.of(context).colorScheme.outline,
                        AppIcons.MORE_MENU,
                      ),
                    ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    // SvgPicture.asset(
                    //   width: 20,
                    //   color: Theme.of(context).colorScheme.primary,
                    //   AppIcons.SETTINGS,
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<AtmBloc, AtmState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is AtmInitialState) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is AtmFailureState) {
                  if (state.code == 401) {
                    return Center(
                      child: AtmReloadComponent(
                        state: state,
                        actionSumbit: () {
                          final secureStorage = FlutterSecureStorage();
                          secureStorage.delete(key: "access_token");
                          Get.to(LoginScreen());
                        },
                        text: "AUTENTICAR",
                      ),
                    );
                  }
                  return Center(
                    child: AtmReloadComponent(
                      state: state,
                      actionSumbit: () {
                        bloc.add(AtmDetailLoadingEvent(
                            atmId: widget.atm.atmSigitCode.toString()));
                      },
                      text: "CARREGAR",
                    ),
                  );
                }

                if (state is AtmDetailSuccessState) {
                  //return AtmDetailWidgetSkeleton();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            color: Theme.of(context).colorScheme.secondary,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      index = 0;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        width: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        AppIcons.MAPA_LOCAL,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "${widget.atm.atmSigitProvinciaTexto.toString().toUpperCase()} ",
                                            style: GoogleFonts.poppins(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 15,
                                              shadows: [
                                                Shadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.4),
                                                  offset: Offset(1, 1),
                                                  blurRadius: 4,
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
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      width: 25,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      AppIcons.BANK,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "${widget.atm.denominacao}",
                                          style: GoogleFonts.rajdhani(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      width: 25,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      AppIcons.ATM,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.topLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            style: GoogleFonts.rajdhani(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              fontSize: 10,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'BANCA: ',
                                                style: GoogleFonts.radioCanada(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              ValorBanca(context),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Theme.of(context).colorScheme.secondary,
                            child: Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.5),
                              thickness: 5,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            color: Theme.of(context).colorScheme.secondary,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: GoogleFonts.rajdhani(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                                fontSize: 10,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'L/Trans.: ',
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${state.atm.transacoes!.first.currentDatetime!.substring(0, 19)}',
                                                  style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.settings_applications_sharp,
                                            size: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: GoogleFonts.rajdhani(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                                fontSize: 10,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'Tipo: ',
                                                ),
                                                TextSpan(
                                                  text: '$tipo',
                                                  style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.key,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: GoogleFonts.rajdhani(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                                fontSize: 10,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'ID: ',
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${widget.atm.atmSigitCode}',
                                                  style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 100,
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: AppColors.MAIN_COLOR
                                            .withOpacity(.8),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10, left: 10),
                                                child: Text(
                                                  "MONTANTE ACTUAL",
                                                  style: GoogleFonts.rajdhani(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "AOA.",
                                                              style: GoogleFonts
                                                                  .rampartOne(
                                                                fontSize: 18,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .outline,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
                                                              style: GoogleFonts
                                                                  .rammettoOne(
                                                                fontSize: 30,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .outline,
                                                                textStyle:
                                                                    TextStyle(
                                                                  shadows: [
                                                                    Shadow(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .shadow
                                                                          .withOpacity(
                                                                              .8),
                                                                      offset:
                                                                          Offset(
                                                                              2,
                                                                              2),
                                                                      blurRadius:
                                                                          4,
                                                                    ),
                                                                  ],
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
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -5,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "ATM",
                                            style: GoogleFonts.rajdhani(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
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
                          Material(
                            elevation: 4,
                            child: Container(
                              width: double.infinity,
                              color: Theme.of(context).colorScheme.secondary,
                              padding: EdgeInsets.only(bottom: 0),
                              child: Container(
                                width: double.infinity,
                                height: 5,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.5),
                                padding: EdgeInsets.only(bottom: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Container(
                          child: ListView(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          color0 = Colors.orange;
                                          color1 =
                                              AppColors.CONTENT_UNSELECT_COLOR;
                                          color2 =
                                              AppColors.CONTENT_UNSELECT_COLOR;

                                          index = 0;
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: (index == 0)
                                                  ? Colors.orange
                                                  : color1,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.swap_horiz_outlined,
                                              color: (index == 0)
                                                  ? Colors.orange
                                                  : color0,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "TRANSAÇÕES",
                                              style: GoogleFonts.rajdhani(
                                                color: (index == 0)
                                                    ? Colors.orange
                                                    : color1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          color0 =
                                              AppColors.CONTENT_UNSELECT_COLOR;
                                          color1 = Theme.of(context)
                                              .colorScheme
                                              .error;
                                          color2 =
                                              AppColors.CONTENT_UNSELECT_COLOR;

                                          index = 1;
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: (index == 1)
                                                  ? Colors.red
                                                  : color1,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.warning_amber_rounded,
                                              color: (index == 1)
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .error
                                                  : color1,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "ALERTAS",
                                              style: GoogleFonts.rajdhani(
                                                color: (index == 1)
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .error
                                                    : color1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          color0 =
                                              AppColors.CONTENT_UNSELECT_COLOR;
                                          color1 =
                                              AppColors.CONTENT_UNSELECT_COLOR;
                                          color2 = Theme.of(context)
                                              .colorScheme
                                              .error;

                                          index = 2;
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: (index == 2)
                                                  ? AppColors.MAIN_COLOR
                                                  : color2,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              width: 30,
                                              color: (index == 2)
                                                  ? AppColors.MAIN_COLOR
                                                  : color2,
                                              AppIcons.WAVE,
                                            ),
                                            Text(
                                              "ESTATÍSTICAS",
                                              style: GoogleFonts.rajdhani(
                                                color: (index == 2)
                                                    ? AppColors.MAIN_COLOR
                                                    : color2,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              tabWidget(index, state.atm),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
        ],
      ),
    );
  }

  TextSpan ValorBanca(BuildContext context) {
    //print(widget.status.rsv10);

    try {
      var v = num.parse(widget.status.rsv10!.toString()) * (-1);

      return TextSpan(
        text:
            "${NumberFormat.currency(locale: 'pt_BR', symbol: 'AOA').format(num.parse(v.toString()))}",
        style: GoogleFonts.radioCanada(
          color: AppColors.PURPLE_COLOR,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          shadows: [
            Shadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(.4),
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      );
    } catch (e) {
      return TextSpan(
        text: "--- --- --- AOA",
        style: GoogleFonts.radioCanada(
          color: Theme.of(context).colorScheme.outline,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    }
  }

  Container tabWidget(int index, Dados dados) {
    if (index == 1) {
      return Container(
        padding: EdgeInsets.all(10),
        height: 400,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: dados.alarmes!.length,
            itemBuilder: (context, int index) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onError,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "${dados.alarmes!.elementAt(index).statusAnomDataOcorrencia!.substring(0, 10)}",
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "${dados.alarmes!.elementAt(index).statusAnomDataOcorrencia!.substring(11, 19)}",
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.key,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.rajdhani(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontSize: 10,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'ID: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )),
                                  TextSpan(
                                    text:
                                        '${dados.alarmes!.elementAt(index).atmCode}',
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      "${dados.alarmes!.elementAt(index).statusAnomDescription}",
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }
    if (index == 2) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FittedBox(
                    child: Row(
                      children: [
                        Text(
                          "INFORMAÇÕES DO ÚLTIMO CARREGAMENTO",
                          style: GoogleFonts.rajdhani(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "${DateTime.now().toString().substring(0, 10)}",
                      style: GoogleFonts.rajdhani(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Theme.of(context).colorScheme.secondary.withOpacity(.2),
            ),
            InfoCarregamento(context: context, status: widget.status),
          ],
        ),
      );
    }
    if (index == 0) {
      return Container(
        padding: EdgeInsets.all(10),
        height: 400,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: dados.transacoes!.length,
          itemBuilder: (context, int index) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                size: 14,
                                color: AppColors.MAIN_COLOR,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${dados.transacoes!.elementAt(index).currentDatetime!.substring(0, 10)}",
                                style: GoogleFonts.rajdhani(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.SECOND_COLOR,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: AppColors.MAIN_COLOR,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${dados.transacoes!.elementAt(index).currentDatetime!.substring(11, 19)}",
                                style: GoogleFonts.rajdhani(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.SECOND_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: FittedBox(
                      child: Row(
                        children: [
                          Icon(
                            Icons.credit_card_outlined,
                            size: 18,
                            color: AppColors.PURPLE_COLOR,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "${NumberFormat.currency(locale: 'pt_BR', symbol: 'AOA').format(num.parse(dados.transacoes!.elementAt(index).statusMontanteDisponivel.toString()))}",
                            style: GoogleFonts.rajdhani(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: AppColors.PURPLE_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
    return Container();
  }
}

class InfoCarregamento extends StatelessWidget {
  final BuildContext context;
  final AtmStatusModel status;
  const InfoCarregamento(
      {super.key, required this.context, required this.status});

  @override
  Widget build(BuildContext context) {
    num valorCarregado = 0;
    num valorAntes = 0;

    try {
      valorCarregado = num.parse(status.rsv1.toString());
    } catch (e) {
      valorCarregado = 0;
    }

    try {
      valorAntes = num.parse(status.rsv7.toString());
    } catch (e) {
      valorAntes = 0;
    }
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 80,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.SECOND_COLOR,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      "${status.rsv2.toString().substring(8, 10)}",
                      style: GoogleFonts.rajdhani(
                        fontSize: 50,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${theMonth(status.rsv2.toString().substring(5, 7))}",
                      style: GoogleFonts.rajdhani(
                        height: 0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${status.rsv2.toString().substring(11, 19)}",
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "VALOR CARREGADO",
                    style: GoogleFonts.rajdhani(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(valorCarregado)}",
                        style: GoogleFonts.racingSansOne(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Container(
              width: 80,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.MAIN_COLOR,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      "${status.rsv8.toString().substring(8, 10)}",
                      style: GoogleFonts.rajdhani(
                        fontSize: 50,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${theMonth(status.rsv8.toString().substring(5, 7))}",
                      style: GoogleFonts.rajdhani(
                        height: 0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${status.rsv8.toString().substring(11, 19)}",
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "VALOR ANTES",
                    style: GoogleFonts.rajdhani(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(valorAntes)}",
                        style: GoogleFonts.racingSansOne(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Container(
              width: 80,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.SECOND_COLOR,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      "${status.rsv2.toString().substring(8, 10)}",
                      style: GoogleFonts.rajdhani(
                        fontSize: 50,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${theMonth(status.rsv2.toString().substring(5, 7))}",
                      style: GoogleFonts.rajdhani(
                        height: 0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${status.rsv2.toString().substring(11, 19)}",
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "VALOR DEPOIS",
                    style: GoogleFonts.rajdhani(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(valorCarregado + valorAntes)}",
                        style: GoogleFonts.racingSansOne(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String theMonth(String mes) {
    switch (mes) {
      case "01":
        return "JANEIRO";
      case "02":
        return "FEVEREIRO";
      case "03":
        return "MARÇO";
      case "04":
        return "ABRIL";
      case "05":
        return "MAIO";
      case "06":
        return "JUNHO";
      case "07":
        return "JULHO";
      case "08":
        return "AGOSTO";
      case "09":
        return "SETEMBRO";
      case "10":
        return "OUTUBRO";
      case "11":
        return "NOVEMBRO";
      case "12":
        return "DEZEMBRO";
      default:
        return "Mês inválido";
    }
  }
}

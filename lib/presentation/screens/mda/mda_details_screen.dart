import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maxalert/bloc/atm/atm_bloc.dart';
import 'package:maxalert/bloc/atm/atm_state.dart';
import 'package:maxalert/bloc/mda/mda_bloc.dart';
import 'package:maxalert/bloc/mda/mda_state.dart';
import 'package:maxalert/data/repositories/atm_repository.dart';
import 'package:maxalert/data/repositories/mda_repository.dart';
import 'package:maxalert/models/atm_data_model.dart';
import 'package:maxalert/models/atm_model.dart';
import 'package:maxalert/models/mda_model.dart';
import 'package:maxalert/presentation/screens/atm/widget/atm_widget_skeleton.dart';
import 'package:maxalert/presentation/screens/login_screen.dart';
import 'package:maxalert/presentation/screens/mda/widget/mda_reload_component.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';
import 'package:maxalert/utils/app_utils.dart';
import 'package:intl/intl.dart';

class MdaDetailsScreen extends StatefulWidget {
  final MdaModel mda;
  const MdaDetailsScreen({super.key, required this.mda});

  @override
  State<MdaDetailsScreen> createState() => _MdaDetailsScreenState();
}

class _MdaDetailsScreenState extends State<MdaDetailsScreen> {
  int index = 0;

  final ScrollController _controller = ScrollController();

  final MdaRepository _mdaRepository = MdaRepository();

  late MdaBloc bloc;
  String? tipo;

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  void initState() {
    super.initState();
    bloc = MdaBloc(mdaRepository: _mdaRepository);
    bloc.add(MdaDetailLoadingEvent(mdaId: widget.mda.mdaCode.toString()));
    setState(() {
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color0 = Theme.of(context).colorScheme.onPrimary;
    Color color1 = Theme.of(context).colorScheme.onPrimary;
    Color color2 = Theme.of(context).colorScheme.onPrimary;
    Color underline = Theme.of(context).colorScheme.onPrimary;

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
                      "MAIS INFORMAÇÕES DO MDA",
                      style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.outline),
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
      body: BlocBuilder<MdaBloc, MdaState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is MdaInitialState) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is MdaFailureState) {
            if (state.code == 401) {
              return Center(
                child: MdaReloadComponent(
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
              child: MdaReloadComponent(
                state: state,
                actionSumbit: () {
                  bloc.add(
                    MdaDetailLoadingEvent(
                      mdaId: widget.mda.mdaCode.toString(),
                    ),
                  );
                },
                text: "CARREGAR",
              ),
            );
          }

          if (state is MdaDetailSuccessState) {
            //return MdaDetailWidgetSkeleton();
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
                                  color: Theme.of(context).colorScheme.outline,
                                  AppIcons.MAPA_LOCAL,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    "${widget.mda.provincia}",
                                    style: GoogleFonts.poppins(
                                      color:
                                          Theme.of(context).colorScheme.outline,
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
                                color: Theme.of(context).colorScheme.outline,
                                AppIcons.BANK,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.mda.denominacao.toString().toUpperCase()}",
                                  style: GoogleFonts.rajdhani(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 25,
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
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'ATIVAÇÃO ',
                                              ),
                                              TextSpan(
                                                text:
                                                    '${widget.mda.mdaDataActivacao.toString().toUpperCase()}',
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 25,
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
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'INSTALAÇÃO ',
                                              ),
                                              TextSpan(
                                                text:
                                                    '${widget.mda.mdaDataInstalacao.toString().toUpperCase()}',
                                                style: GoogleFonts.rajdhani(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
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
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.mda.nome.toString()}",
                                  style: GoogleFonts.rajdhani(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.mda.municipio.toString()}",
                                  style: GoogleFonts.rajdhani(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
                    width: double.infinity,
                    height: double.infinity,
                    child: ListView(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.swap_horiz_outlined,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "HISTÓRICOS OCORRÊNCIAS MDA",
                                      style: GoogleFonts.rajdhani(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        tabWidget(state.status),
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
        },
      ),
    );
  }

  Widget tabWidget(List<MdaModel> list) {
    num montanteActual;
    num montanteActualList;

    try {
      montanteActual = num.parse(widget.mda.mdaMontanteActual.toString());
    } catch (e) {
      montanteActual = 0;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, int index) {
          try {
            montanteActualList =
                num.parse(list.elementAt(index).mdaMontanteActual.toString());
          } catch (e) {
            montanteActualList = 0;
          }

          if (index == 0) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.MAIN_COLOR.withOpacity(.9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Text(
                                    "MONTANTE ACTUAL",
                                    style: GoogleFonts.rajdhani(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: 20, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "AOA.",
                                        style: GoogleFonts.rampartOne(
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(montanteActual)}",
                                          style: GoogleFonts.rammettoOne(
                                            fontSize: 25,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            textStyle: TextStyle(
                                              shadows: [
                                                Shadow(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow
                                                      .withOpacity(.8),
                                                  offset: Offset(2, 2),
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
                              color: Theme.of(context).colorScheme.outline,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "MDA",
                              style: GoogleFonts.rajdhani(
                                color: AppColors.SECOND_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: estadoPapel(
                            context, widget.mda.mdaPapel.toString(), 0),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: estadoCassete(
                            context, widget.mda.mdaCassetStatus.toString(), 0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: estadoCofre(
                            context, widget.mda.mdaPortaCofre.toString(), 0),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.SECOND_COLOR,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "NOTAS",
                                style: GoogleFonts.rajdhani(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${widget.mda.mdaTotalNotas}",
                                style: GoogleFonts.rajdhani(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary, // Cor da borda
                        width: 2.0, // Espessura da borda
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 30,
                              color: AppColors.SECOND_COLOR,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${widget.mda.currentDatetime.toString().substring(0, 10)}",
                              style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 30,
                              color: AppColors.SECOND_COLOR,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${widget.mda.currentDatetime.toString().substring(11, 19)}",
                              style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.MAIN_COLOR.withOpacity(.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text(
                                  "MONTANTE",
                                  style: GoogleFonts.rajdhani(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: 20, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "AOA.",
                                      style: GoogleFonts.rampartOne(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Center(
                                      child: Text(
                                        "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(montanteActualList)}",
                                        style: GoogleFonts.rammettoOne(
                                          fontSize: 25,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          textStyle: TextStyle(
                                            shadows: [
                                              Shadow(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .shadow
                                                    .withOpacity(.8),
                                                offset: Offset(2, 2),
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
                            color: Theme.of(context).colorScheme.outline,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "MDA",
                            style: GoogleFonts.rajdhani(
                              color: AppColors.SECOND_COLOR,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: estadoPapel(
                          context, widget.mda.mdaPapel.toString(), 0),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: estadoCassete(context,
                          list.elementAt(index).mdaCassetStatus.toString(), 0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: estadoCofre(context,
                          list.elementAt(index).mdaPortaCofre.toString(), 0),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.SECOND_COLOR,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "NOTAS",
                              style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${list.elementAt(index).mdaTotalNotas}",
                              style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, // Cor da borda
                      width: 2.0, // Espessura da borda
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 30,
                            color: AppColors.SECOND_COLOR,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${list.elementAt(index).currentDatetime.toString().substring(0, 10)}",
                            style: GoogleFonts.rajdhani(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 30,
                            color: AppColors.SECOND_COLOR,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${list.elementAt(index).currentDatetime.toString().substring(11, 19)}",
                            style: GoogleFonts.rajdhani(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget estadoPapel(BuildContext context, String estadoPapel, int index) {
    if (index == 0) {
      if (widget.mda.mdaPapel == "PAPER_LOW") {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "POUCO PAPEL",
                style: GoogleFonts.rajdhani(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Icon(
                Icons.remove_circle_sharp,
                color: Colors.white,
              ),
            ],
          ),
        );
      }
      if (widget.mda.mdaPapel == "PAPER_FULL") {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "COM PAPEL",
                style: GoogleFonts.rajdhani(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Icon(
                Icons.check_box,
                color: Colors.white,
              ),
            ],
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "SEM PAPEL",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    if (estadoPapel == "PAPER_LOW") {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "POUCO PAPEL",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.remove_circle_sharp,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    if (estadoPapel == "PAPER_FULL") {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "COM PAPEL",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.check_box,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "SEM PAPEL",
            style: GoogleFonts.rajdhani(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget estadoCassete(BuildContext context, String estadoCassete, int index) {
    if (index == 0) {
      if (widget.mda.mdaCassetStatus == "OK") {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "CASSETE OK",
                style: GoogleFonts.rajdhani(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CASSETE",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (estadoCassete == "OK") {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CASSETE OK",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "CASSETE",
            style: GoogleFonts.rajdhani(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget estadoCofre(BuildContext context, String estadoCofre, int index) {
    if (index == 0) {
      if (widget.mda.mdaPortaCofre == "CLOSED") {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "PORTA DO COFRE",
                style: GoogleFonts.rajdhani(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "FECHADA",
                style: GoogleFonts.rajdhani(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "PORTA DO COFRE",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "ABERTA",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ],
        ),
      );
    }
    if (estadoCofre == "CLOSED") {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "PORTA DO COFRE",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "FECHADA",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "PORTA DO COFRE",
            style: GoogleFonts.rajdhani(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "ABERTA",
            style: GoogleFonts.rajdhani(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

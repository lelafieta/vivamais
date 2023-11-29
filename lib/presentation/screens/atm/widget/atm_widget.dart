import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maxalert/models/atm_model.dart';
import 'package:maxalert/models/atm_status_model.dart';
import 'package:maxalert/models/atm_with_status.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';

class AtmWidget extends StatefulWidget {
  final AtmModel atm;
  final AtmStatusModel status;
  AtmWidget({super.key, required this.atm, required this.status});

  @override
  State<AtmWidget> createState() => _AtmWidgetState();
}

class _AtmWidgetState extends State<AtmWidget> {
  ValueNotifier<String> textPapel = ValueNotifier<String>("");
  ValueNotifier<String> textSlote = ValueNotifier<String>("");
  ValueNotifier<String> textMoney = ValueNotifier<String>("");
  ValueNotifier<String> textEstado = ValueNotifier<String>("");

  ValueNotifier<Color> colorPapel = ValueNotifier<Color>(Colors.black);
  ValueNotifier<Color> colorSlote = ValueNotifier<Color>(Colors.black);
  ValueNotifier<Color> colorMoney = ValueNotifier<Color>(Colors.black);
  ValueNotifier<Color> colorEstado = ValueNotifier<Color>(Colors.black);
  int press = 0;

  String? tipo;

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    if (widget.atm.tipoLocal == 1) {
      tipo = "Balcão";
    } else if (widget.atm.tipoLocal == 2) {
      tipo = "Center";
    } else if (widget.atm.tipoLocal == 3) {
      tipo = "Remoto";
    }

    return GestureDetector(
      onLongPress: () {
        setState(() {
          if (widget.status.estadoDinheiro == 1) {
            colorMoney.value = Colors.green;
            textMoney.value = "COM DINHEIRO";
          } else if (widget.status.estadoDinheiro == 2) {
            colorMoney.value = Colors.orange;
            textMoney.value = "POUCO DINHEIRO";
          } else {
            colorMoney.value = Colors.red;
            textMoney.value = "SEM DINHEIRO";
          }

          if (widget.status.estadoPapel == 1) {
            colorPapel.value = Colors.green;
            textPapel.value = "COM PAPEL";
          } else if (widget.status.estadoPapel == 2) {
            colorPapel.value = Colors.orange;
            textPapel.value = "POUCO PAPEL";
          } else {
            colorPapel.value = Colors.red;
            textPapel.value = "SEM PAPEL";
          }

          if (widget.status.estadoCartao == 1) {
            colorSlote.value = Colors.green;
            textSlote.value = "OK";
          } else {
            colorSlote.value = Colors.red;
            textSlote.value = "COM PROBLEMA";
          }

          if (widget.status.estado == "S") {
            colorEstado.value = Colors.grey;
            textEstado.value = "MANUTENÇÃO";
          } else {
            if (widget.status.isHorasOffline! > 0) {
              colorEstado.value = Colors.red;
              textEstado.value = "OFFLINE";
            } else if (widget.status.isHoraSleeping! > 0) {
              colorEstado.value = Colors.green;
              textEstado.value = "DORMINDO";
            } else if (widget.status.isHorasOnline! >= 1) {
              colorEstado.value = Colors.green;
              textEstado.value = "ONLINE";
            } else if (widget.status.isHorasOnline! * 60 > 20) {
              colorEstado.value = Colors.green;
              textEstado.value = "ONLINE";
            } else {
              colorEstado.value = Colors.green;
              textEstado.value = "ONLINE";
            }
          }

          press = 1;
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isDismissible: true,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "INFORMAÇÕES DO ATM (${widget.atm.atmSigitCode})",
                          style: GoogleFonts.rajdhani(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: colorPapel.value,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "PAPEL: ",
                                        style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "${textPapel.value}",
                                        style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w900,
                                          color: colorPapel.value,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: colorSlote.value,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "SLOTE CARD: ",
                                        style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "${textSlote.value}",
                                        style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w900,
                                          color: colorSlote.value,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: colorMoney.value,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "DINHEIRO: ",
                                        style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "${textMoney.value}",
                                        style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w900,
                                          color: colorMoney.value,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: colorEstado.value,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "ESTADO: ",
                                        style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "${textEstado.value}",
                                        style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w900,
                                          color: colorEstado.value,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).whenComplete(() {
            setState(() {
              press = 0;
            });
          });
        });
      },
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: (press == 1)
              ? Colors.grey.withOpacity(.1)
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.surfaceTint,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        width: 12,
                        color: Theme.of(context).colorScheme.primary,
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
                            "${widget.atm.atmSigitProvinciaTexto.toString().toUpperCase()}",
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        width: 12,
                        color: Theme.of(context).colorScheme.primary,
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
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        width: 10,
                        color: Theme.of(context).colorScheme.primary,
                        AppIcons.TIME,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.rajdhani(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 10,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Site: ',
                              ),
                              TextSpan(
                                text: '${widget.atm.atmSigitCodeAgencia}',
                                style: GoogleFonts.rajdhani(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    width: 10,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    AppIcons.SETTINGS,
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
                                                .primary,
                                            fontSize: 10,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Tipo: ',
                                            ),
                                            TextSpan(
                                              text: '$tipo',
                                              style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.key,
                                  size: 11,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.rajdhani(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 10,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'ID: ',
                                      ),
                                      TextSpan(
                                        text: '${widget.atm.atmSigitCode}',
                                        style: GoogleFonts.rajdhani(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      right: 20,
                      top: 40,
                      child:
                          DisplayWidget(atm: widget.atm, status: widget.status),
                    ),
                    Positioned(
                      left: 90,
                      right: 10,
                      top: 140,
                      child: EstadoCartao(status: widget.status),
                    ),
                    Positioned(
                      left: 10,
                      right: 60,
                      top: 140,
                      child: EstadoPapel(status: widget.status),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: EstadoDinheiro(status: widget.status),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1.0,
                        ),
                      ),
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          top: 0, left: 10, right: 10, bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          AppImages.ATM,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.values.first,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      right: 50,
                      top: 10,
                      child: EstadoWidget(status: widget.status),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayWidget extends StatelessWidget {
  final AtmStatusModel status;
  const DisplayWidget({super.key, required this.atm, required this.status});

  final AtmModel atm;

  @override
  Widget build(BuildContext context) {
    return MainContainer(atm: atm, status: status);
  }
}

class MainContainer extends StatelessWidget {
  final AtmStatusModel status;
  final AtmModel atm;
  const MainContainer({
    super.key,
    required this.atm,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color cor = Colors.green;
    String imagePath = "";

    if (status.estado == "S") {
      cor = Colors.grey;
      imagePath = AppImages.MANUTENCAO;
    } else {
      if (status.isHorasOffline! > 0) {
        imagePath = AppImages.OFFLINE;
        cor = Colors.red;
      } else if (status.isHoraSleeping! > 0) {
        imagePath = AppImages.DORMINDO;
        cor = Colors.green;
      } else if (status.isHorasOnline! >= 1) {
        cor = Colors.green;
        imagePath = AppImages.ONLINE;
      } else if (status.isHorasOnline! * 60 > 20) {
        cor = Colors.green.withOpacity(.2);
        imagePath = AppImages.ONLINE;
      } else {
        imagePath = AppImages.ONLINE;
      }
    }
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 85,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage(
                AppImages.MULTICAIXA,
              ),
              fit: BoxFit.scaleDown,
              opacity: .3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "ATM ID: ${atm.atmSigitCode}",
                style: GoogleFonts.sairaStencilOne(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              Text(
                "CCB: ${atm.ccb}",
                style: GoogleFonts.rajdhani(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage(
                imagePath,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EstadoDinheiro extends StatefulWidget {
  final AtmStatusModel status;
  const EstadoDinheiro({super.key, required this.status});

  @override
  State<EstadoDinheiro> createState() => _EstadoDinheiroState();
}

class _EstadoDinheiroState extends State<EstadoDinheiro> {
  @override
  @override
  Widget build(BuildContext context) {
    if (widget.status.estado == "S") {
      if (widget.status.estadoDinheiro == 1) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
              style: GoogleFonts.rajdhani(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else if (widget.status.estadoDinheiro == 2) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
              style: GoogleFonts.rajdhani(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {}
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
            style: GoogleFonts.rajdhani(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    if (widget.status.isHorasOffline! > 0) {
      if (widget.status.estadoDinheiro == 1) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
              style: GoogleFonts.rajdhani(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else if (widget.status.estadoDinheiro == 2) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
              style: GoogleFonts.rajdhani(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {}

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
            style: GoogleFonts.rajdhani(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (widget.status.isHoraSleeping! > 0) {
      if (widget.status.estadoDinheiro == 1) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
              style: GoogleFonts.rajdhani(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else if (widget.status.estadoDinheiro == 2) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
              style: GoogleFonts.rajdhani(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {}

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
            style: GoogleFonts.rajdhani(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    if (widget.status.estadoDinheiro == 1) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
            style: GoogleFonts.rajdhani(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (widget.status.estadoDinheiro == 2) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
            style: GoogleFonts.rajdhani(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {}

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Center(
        child: Text(
          "${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(num.parse(widget.status.valorActual.toString()))}",
          style: GoogleFonts.rajdhani(
            color: Theme.of(context).colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class EstadoCartao extends StatelessWidget {
  final AtmStatusModel status;
  const EstadoCartao({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status.estado == "S") {
      if (status.estadoCartao == 1) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(50),
          ),
        );
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(50),
        ),
      );
    }

    if (status.isHorasOffline! > 0) {
      if (status.estadoCartao == 1) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(50),
          ),
        );
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
        ),
      );
    } else if (status.isHoraSleeping! > 0) {
      if (status.estadoCartao == 1) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(50),
          ),
        );
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
        ),
      );
    }

    if (status.estadoCartao == 1) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(50),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

class EstadoPapel extends StatelessWidget {
  final AtmStatusModel status;
  const EstadoPapel({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status.estado == "S") {
      if (status.estadoPapel == 1) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        );
      }
      if (status.estadoPapel == 2) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        );
      }
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      );
    }

    if (status.isHorasOffline! > 0) {
      if (status.estadoPapel == 1) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        );
      }
      if (status.estadoPapel == 2) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        );
      }
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      );
    } else if (status.isHoraSleeping! > 0) {
      if (status.estadoPapel == 1) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        );
      }
      if (status.estadoPapel == 2) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        );
      }
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      );
    }

    if (status.estadoPapel == 1) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      );
    }
    if (status.estadoPapel == 2) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
    );
  }
}

class EstadoWidget extends StatelessWidget {
  final AtmStatusModel status;
  const EstadoWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status.estado == "S") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Text(
              "MANUTENÇÃO",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    if (status.isHorasOffline! > 0) {
      var h = status.isHorasOffline;
      var doubleData = h! / 24;

      var str =
          h >= 24 ? doubleData.toInt().toString() + " DIA(S)" : "$h DIA(S)";
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Text(
              "OFFLINE Á $str",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
      );
    } else if (status.isHoraSleeping! > 0) {
      var h = status.isHorasOffline;
      var doubleData = h! / 24;

      var str =
          h >= 24 ? doubleData.toInt().toString() + " DIA(S)" : "$h HORA(S)";
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Text(
              "DORMINDO Á $str",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );
    } else if (status.isHorasOnline! >= 1) {
      var h = status.isHorasOffline;
      var doubleData = h! / 24;

      var str =
          h >= 24 ? doubleData.toInt().toString() + " DIA(S)" : "$h HORA(S)";
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Text(
              "ONLINE Á $str",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );
    } else if (status.isHorasOnline! * 60 > 20) {
      var min = status.isHorasOffline! * 60;

      var str = (min > 60)
          ? ((min / 60) >= 24
              ? (((min / 60) / 24).toString() + " DIA(S)")
              : ((min / 60).toString() + "HORA(S)"))
          : min.toString() + " MIN";

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Text(
              "ONLINE Á $str",
              style: GoogleFonts.rajdhani(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topLeft,
          child: Text(
            "ONLINE",
            style: GoogleFonts.rajdhani(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}

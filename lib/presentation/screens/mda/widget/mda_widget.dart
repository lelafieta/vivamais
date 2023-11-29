import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maxalert/models/mda_model.dart';
import 'package:maxalert/utils/app_colors.dart';
import 'package:maxalert/utils/app_icons.dart';
import 'package:maxalert/utils/app_images.dart';

class MdaWidget extends StatefulWidget {
  final MdaModel mda;
  const MdaWidget({super.key, required this.mda});

  @override
  State<MdaWidget> createState() => _MdaWidgetState();
}

class _MdaWidgetState extends State<MdaWidget> {
  ValueNotifier<String> textPapel = ValueNotifier<String>("");
  ValueNotifier<String> textSlote = ValueNotifier<String>("");
  ValueNotifier<String> textMoney = ValueNotifier<String>("");
  ValueNotifier<String> textEstado = ValueNotifier<String>("");

  ValueNotifier<Color> colorPapel = ValueNotifier<Color>(Colors.black);
  ValueNotifier<Color> colorSlote = ValueNotifier<Color>(Colors.black);
  ValueNotifier<Color> colorMoney = ValueNotifier<Color>(Colors.black);
  ValueNotifier<Color> colorEstado = ValueNotifier<Color>(Colors.black);
  int press = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        press = 1;

        if (widget.mda.mdaStatus == "success_state") {
          colorEstado.value = Colors.green;
          textEstado.value = "ONLINE";
        } else if (widget.mda.mdaStatus != "success_state" &&
            widget.mda.mdaStatus != "warning_state") {
          colorEstado.value = Colors.red;
          textEstado.value = "OFFLINE";
        } else {
          colorEstado.value = Colors.orange;
          textEstado.value = "ANOMALIA";
        }

        if (widget.mda.mdaPapel == "PAPER_FULL") {
          colorPapel.value = Colors.green;
          textPapel.value = "COM PAPEL";
        } else if (widget.mda.mdaPapel == "PAPER_LOW") {
          colorPapel.value = Colors.orange;
          textPapel.value = "POUCO";
        } else {
          colorPapel.value = Colors.red;
          textPapel.value = "SEM PAPEL";
        }

        if (int.parse(widget.mda.mdaMontanteActual.toString()) < 20000000) {
          colorMoney.value = Colors.orange;
          textMoney.value = "ABAIXO DO VALOR DE RECOLHA";
        } else {
          colorMoney.value = Colors.green;
          textMoney.value = "SUFUCIENTE PARA RECOLHA";
        }

        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isDismissible: true,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              height: 170,
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
                          "INFORMAÇÕES DO MDA (${widget.mda.mdaCode})",
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
                    Container(
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
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  children: [
                                    Text(
                                      "PAPEL: ",
                                      style: GoogleFonts.rajdhani(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "${textPapel.value}",
                                      style: GoogleFonts.rajdhani(
                                        fontWeight: FontWeight.w900,
                                        color: colorPapel.value,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
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
                                  Text(
                                    "DINHEIRO: ",
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "${textMoney.value}",
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w900,
                                      color: colorMoney.value,
                                      fontSize: 16,
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
                                  Text(
                                    "ESTADO: ",
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "${textEstado.value}",
                                    style: GoogleFonts.rajdhani(
                                      fontWeight: FontWeight.w900,
                                      color: colorEstado.value,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Center(
              //       child: FittedBox(
              //         fit: BoxFit.scaleDown,
              //         child: Text(
              //           "INFORMAÇÕES DO MDA (${widget.mda.mdaCode})",
              //           style: GoogleFonts.rajdhani(
              //             fontSize: 18,
              //             fontWeight: FontWeight.w900,
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: 10,
              //     ),
              //     Expanded(
              //       child: Container(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Row(
              //               children: [
              //                 Container(
              //                   width: 20,
              //                   height: 20,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(50),
              //                     color: colorPapel.value,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Row(
              //                   children: [
              //                     FittedBox(
              //                       fit: BoxFit.scaleDown,
              //                       child: Text(
              //                         "PAPEL: ",
              //                         style: GoogleFonts.rajdhani(
              //                           fontWeight: FontWeight.w600,
              //                           fontSize: 16,
              //                         ),
              //                       ),
              //                     ),
              //                     FittedBox(
              //                       fit: BoxFit.scaleDown,
              //                       child: Text(
              //                         "${textPapel.value}",
              //                         style: GoogleFonts.rajdhani(
              //                           fontWeight: FontWeight.w900,
              //                           color: colorPapel.value,
              //                           fontSize: 16,
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //             SizedBox(
              //               height: 10,
              //             ),
              //             Row(
              //               children: [
              //                 Container(
              //                   width: 20,
              //                   height: 20,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(50),
              //                     color: colorSlote.value,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Row(
              //                   children: [
              //                     FittedBox(
              //                       fit: BoxFit.scaleDown,
              //                       child: Text(
              //                         "SLOTE CARD: ",
              //                         style: GoogleFonts.rajdhani(
              //                           fontWeight: FontWeight.w600,
              //                           fontSize: 16,
              //                         ),
              //                       ),
              //                     ),
              //                     FittedBox(
              //                       fit: BoxFit.scaleDown,
              //                       child: Text(
              //                         "${textSlote.value}",
              //                         style: GoogleFonts.rajdhani(
              //                           fontWeight: FontWeight.w900,
              //                           color: colorSlote.value,
              //                           fontSize: 16,
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //             SizedBox(
              //               height: 10,
              //             ),
              //             Row(
              //               children: [
              //                 Container(
              //                   width: 20,
              //                   height: 20,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(50),
              //                     color: colorMoney.value,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Row(
              //                   children: [
              //                     FittedBox(
              //                       fit: BoxFit.scaleDown,
              //                       child: Text(
              //                         "DINHEIRO: ",
              //                         style: GoogleFonts.rajdhani(
              //                           fontWeight: FontWeight.w600,
              //                           fontSize: 16,
              //                         ),
              //                       ),
              //                     ),
              //                     FittedBox(
              //                       fit: BoxFit.scaleDown,
              //                       child: Text(
              //                         "${textMoney.value}",
              //                         style: GoogleFonts.rajdhani(
              //                           fontWeight: FontWeight.w900,
              //                           color: colorMoney.value,
              //                           fontSize: 16,
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //             SizedBox(
              //               height: 10,
              //             ),
              //             Row(
              //               children: [
              //                 Container(
              //                   width: 20,
              //                   height: 20,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(50),
              //                     color: colorEstado.value,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Row(
              //                   children: [
              //                     FittedBox(
              //                       fit: BoxFit.scaleDown,
              //                       child: Text(
              //                         "ESTADO: ",
              //                         style: GoogleFonts.rajdhani(
              //                           fontWeight: FontWeight.w600,
              //                           fontSize: 16,
              //                         ),
              //                       ),
              //                     ),
              //                     FittedBox(
              //                       fit: BoxFit.scaleDown,
              //                       child: Text(
              //                         "${textEstado.value}",
              //                         style: GoogleFonts.rajdhani(
              //                           fontWeight: FontWeight.w900,
              //                           color: colorEstado.value,
              //                           fontSize: 16,
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            );
          },
        ).whenComplete(() {
          setState(() {
            press = 0;
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
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${widget.mda.provincia}",
                            style: GoogleFonts.poppins(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 12),
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
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${widget.mda.denominacao}",
                            style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.primary),
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
                      Icon(
                        Icons.monetization_on,
                        size: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child:
                            (widget.mda.mdaMontanteActual.toString() == 'None')
                                ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "0",
                                      style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 10,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${NumberFormat.currency(locale: 'pt_BR', symbol: 'AOA \$').format(num.parse(widget.mda.mdaMontanteActual.toString()))}",
                                      style: GoogleFonts.rajdhani(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 10,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.key,
                                    size: 11,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.rajdhani(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 10,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'CODE: ',
                                        ),
                                        TextSpan(
                                          text: '${widget.mda.mdaCode}',
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                      left: 10,
                      right: 40,
                      top: 100,
                      child: estadoContainer(widget.mda.mdaStatus!, context)),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 40,
                    child: estadoPapel(context),
                  ),
                  Positioned(
                    left: 40,
                    right: 10,
                    top: 170,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
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
                        AppImages.MDA,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.values.first,
                      ),
                    ),
                  ),
                  Positioned(
                      left: 50,
                      right: 50,
                      top: 30,
                      child: estadoText(widget.mda.mdaStatus!, context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget estadoText(String estado, BuildContext context) {
    if (estado == "success_state") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            "ONLINE",
            style: GoogleFonts.rajdhani(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      );
    } else if (estado == "warning_state") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            "ANOMALIA",
            style: GoogleFonts.rajdhani(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Center(
        child: Text(
          "OFFLINE",
          style: GoogleFonts.rajdhani(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget estadoContainer(String estado, BuildContext context) {
    if (estado == "success_state") {
      return Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width - 320,
        height: 60,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (widget.mda.mdaMontanteActual == "None")
                  ? Text(
                      "0",
                      style: GoogleFonts.rajdhani(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "${NumberFormat.currency(locale: 'pt_BR', symbol: '\$').format(num.parse(widget.mda.mdaMontanteActual.toString()))}",
                      style: GoogleFonts.rajdhani(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
              Text(
                "AOA",
                style: GoogleFonts.rajdhani(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (estado == "warning_state") {
      return Container(
        color: Colors.orange,
        width: MediaQuery.of(context).size.width - 320,
        height: 60,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (widget.mda.mdaMontanteActual == "None")
                  ? Text(
                      "0",
                      style: GoogleFonts.rajdhani(
                        color: Theme.of(context).colorScheme.background,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "${NumberFormat.currency(locale: 'pt_BR', symbol: '\$').format(num.parse(widget.mda.mdaMontanteActual.toString()))}",
                      style: GoogleFonts.rajdhani(
                        color: Theme.of(context).colorScheme.background,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
              Text(
                "AOA",
                style: GoogleFonts.rajdhani(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      color: Colors.red,
      width: MediaQuery.of(context).size.width - 320,
      height: 60,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (widget.mda.mdaMontanteActual == "None")
                ? Text(
                    "0",
                    style: GoogleFonts.rajdhani(
                      color: Theme.of(context).colorScheme.background,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "${NumberFormat.currency(locale: 'pt_BR', symbol: '\$').format(num.parse(widget.mda.mdaMontanteActual.toString()))}",
                    style: GoogleFonts.rajdhani(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
            Text(
              "AOA",
              style: GoogleFonts.rajdhani(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget estadoPapel(BuildContext context) {
    if (widget.mda.mdaPapel == "PAPER_LOW") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.orange,
        ),
        child: Center(
          child: Text(
            "POUCO PAPEL",
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    if (widget.mda.mdaPapel == "PAPER_FULL") {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
        ),
        child: Center(
          child: Text(
            "COM PAPEL",
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red,
      ),
      child: Center(
        child: Text(
          "SEM PAPEL",
          style: GoogleFonts.rajdhani(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ParallelogramWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surfaceVariant;
    return CustomPaint(
      painter: ParallelogramPainter(surfaceVariantColor: color),
      child: Text("data"),
    );
  }
}

class ParallelogramPainter extends CustomPainter {
  final Color surfaceVariantColor;

  ParallelogramPainter({required this.surfaceVariantColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = surfaceVariantColor;

    final Path path = Path()
      ..moveTo(0, size.height) // Ponto inferior esquerdo
      ..lineTo(size.width + 990 * -.10, 0) // Ponto superior esquerdo
      ..lineTo(size.width - 24, 0) // Ponto superior direito
      ..lineTo(size.width * 0.7, size.height) // Ponto inferior direito
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
